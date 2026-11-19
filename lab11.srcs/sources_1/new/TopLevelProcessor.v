`timescale 1ns / 1ps

module TopLevelProcessor (input wire clk, input wire rst, output wire [15:0] led);
    wire slow_clk;
    wire [31:0] pc;
    wire [31:0] pc_next;
    wire [31:0] pc_next_seq;
    wire [31:0] branch_target;
    wire [31:0] instruction;
    
    wire RegWrite, MemRead, MemWrite, ALUSrc, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;
    wire PCSrc;
    
    wire [31:0] imm;
    wire [31:0] readData1;
    wire [31:0] readData2;
    wire [31:0] ALUB;
    wire [31:0] ALUResult;
    wire Zero;
    wire [31:0] mem_read_data;
    wire [31:0] writeData;

    clock_divider u_clk_div (
        .clk_in(clk),
        .rst(rst),
        .clk_out(slow_clk)
    );

    ProgramCounter m0 (
        .clk(slow_clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc(pc)
    );

    pcAdder m1 (
        .pc(pc),
        .pc_next_seq(pc_next_seq)
    );

    instructionMemory m2 (
        .instAddress(pc),
        .instruction(instruction)
    );

    main_control m3 (
        .opcode(instruction[6:0]),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .Branch(Branch)
    );

    alu_control m4 (
        .ALUOp(ALUOp),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .ALUControl(ALUControl)
    );

    immGen m5 (
        .inst(instruction),
        .imm(imm)
    );

    registerfile m6 (
        .clk(slow_clk),
        .rst(rst),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .writeData(writeData),
        .we(RegWrite),
        .readData1(readData1),
        .readData2(readData2)
    );

    mux2 m7 (
        .in0(readData2),
        .in1(imm),
        .sel(ALUSrc),
        .out(ALUB)
    );

    alu m8 (
        .A(readData1),
        .B(ALUB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    DataMemory m9 (
        .clk(slow_clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(ALUResult[8:0]), 
        .write_data(readData2),
        .read_data(mem_read_data)
    );

    mux2 m10 (
        .in0(ALUResult),
        .in1(mem_read_data),
        .sel(MemtoReg),
        .out(writeData)
    );

    branchAdder m11 (
        .pc(pc),
        .imm(imm),
        .branch_target(branch_target)    
    );

    assign PCSrc = Branch & Zero;

    mux2 m12 ( 
        .in0(pc_next_seq), 
        .in1(branch_target), 
        .sel(PCSrc), 
        .out(pc_next)
    );
    
    assign led = ALUResult[15:0];
    
endmodule

module clock_divider (
    input wire clk_in,    
    input wire rst,       
    output reg clk_out
);

    reg [25:0] count = 0; 
  
// localparam MAX_COUNT = 2;            // Commented out for hardware implementation
localparam MAX_COUNT = 50_000_000 - 1;  // 1 Hz slow clock for Basys 3 board

    always @(posedge clk_in) begin
        if (rst) begin
            count <= 0;
            clk_out <= 0;
        end 
        else if (count == MAX_COUNT) begin
            count <= 0;
            clk_out <= ~clk_out; 
        end 
        else begin
            count <= count + 1;
        end
    end

endmodule