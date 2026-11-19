`timescale 1ns / 1ps

module top_module_tb;
    reg clk;
    reg rst;
    reg PCSrc;
    reg [31:0] inst;

    wire [31:0] pc;
    wire [31:0] imm;

    top_module u_uut (
        .clk(clk), 
        .rst(rst), 
        .PCSrc(PCSrc), 
        .inst(inst), 
        .pc(pc), 
        .imm(imm)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        PCSrc = 0;
        inst = 32'd0;
        #10;
        
        rst = 0; 
        #30; 
        
        inst = 32'h00A00013; 
        #10;
        
        inst = 32'hFF600013;
        #10;

        inst = 32'h00000A23;
        #10;
        
        inst = 32'h00000463;
        PCSrc = 1; 
        #10;
        
        PCSrc = 0;
        inst = 32'h00000000;
        #20;

        $finish;
    end
endmodule