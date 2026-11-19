`timescale 1ns / 1ps

module pcAdder ( input  wire [31:0] pc, output wire [31:0] pc_next_seq );
    assign pc_next_seq = pc + 32'd4;
endmodule