`timescale 1ns / 1ps

module top_module ( 
    input  wire clk, input  wire rst, input  wire PCSrc, input  wire [31:0] inst,        
    output wire [31:0] pc, output wire [31:0] imm       
);

    wire [31:0] pc_next_seq;        
    wire [31:0] branch_target;      
    wire [31:0] pc_next;            

    ProgramCounter u_pc ( .clk(clk), .rst(rst),.pc_next(pc_next), .pc(pc) );
    pcAdder u_pc_add ( .pc(pc), .pc_next_seq(pc_next_seq));

    immGen m3 (.inst(inst), .imm(imm) );

    branchAdder m4 ( .pc(pc),.imm(imm), .branch_target(branch_target));

    mux2 m5 ( .in0(pc_next_seq), .in1(branch_target), .sel(PCSrc), .out(pc_next));

endmodule