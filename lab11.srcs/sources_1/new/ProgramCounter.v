module ProgramCounter (input wire clk, input wire rst,
                       input wire [31:0] pc_next, output reg [31:0] pc);
    always @(posedge clk or posedge rst) begin
        if (rst) pc <= 32'd0;
        else pc <= pc_next;
    end
endmodule