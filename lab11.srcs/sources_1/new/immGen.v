`timescale 1ns / 1ps

module immGen (input  wire [31:0] inst, output reg  [31:0] imm);
    wire [6:0] opcode = inst[6:0]; 
    always @(*) begin
        case (opcode)
            7'b0000011, 
            7'b0010011: begin
                imm = {{20{inst[31]}}, inst[31:20]};
            end
            
            7'b0100011: begin
                imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            end
            
            7'b1100011: begin
                imm = {{20{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8]};
            end
            
            default: begin
                imm = 32'd0; 
            end
        endcase
    end
endmodule