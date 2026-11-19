`timescale 1ns / 1ps

// 512 x 32 data memory, asynchronous read, synchronous write
module DataMemory (
    input clk,
    input MemRead,
    input MemWrite,
    input [8:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);
    reg [31:0] mem_array [0:511];
    assign read_data = MemRead ? mem_array[address] : 32'b0;
    always @(posedge clk) begin
        if (MemWrite) begin
            mem_array[address] <= write_data;
        end
    end
endmodule