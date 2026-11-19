`timescale 1ns / 1ps

module instructionMemory #(
    parameter OPERAND_LENGTH = 31
)(
    input  wire [OPERAND_LENGTH:0] instAddress,
    output reg  [31:0] instruction
);

    always @(*) begin
        case (instAddress)
            32'd0:   instruction = 32'h00A00093; // addi x1, x0, 10   -> ALUResult = 10  (0x000A)
            32'd4:   instruction = 32'hFFC00113; // addi x2, x0, -4   -> ALUResult = -4  (0xFFFC)
            32'd8:   instruction = 32'h002081B3; // add  x3, x1, x2   -> ALUResult = 6   (0x0006)
            32'd12:  instruction = 32'h00302623; // sw   x3, 12(x0)   -> ALUResult = 12  (0x000C)
            32'd16:  instruction = 32'h40308233; // sub  x4, x1, x3   -> ALUResult = 4   (0x0004)
            32'd20:  instruction = 32'h00C02283; // lw   x5, 12(x0)   -> ALUResult = 12  (0x000C)
            32'd24:  instruction = 32'h005080B3; // add  x1, x1, x5   -> ALUResult = 16  (0x0010)
            32'd28:  instruction = 32'h00408263; // beq  x1, x4, 4    -> ALUResult = 12  (0x000C)
            default: instruction = 32'h00008093; // addi x1, x1, 0    -> holds ALUResult = 16 (0x0010)
        endcase
    end

endmodule