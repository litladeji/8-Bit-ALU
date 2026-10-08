`timescale 1ns/1ps
module alu (
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [2:0] opcode,
    output wire zero,
    output reg carry,
    output reg [7:0] result
);

localparam OP_ADD = 3'b000;
localparam OP_SUB = 3'b001;
localparam OP_AND = 3'b010;
localparam OP_OR = 3'b011;
localparam OP_XOR = 3'b100;
localparam OP_SHL = 3'b101;
localparam OP_SHR = 3'b110;
localparam OP_CMP = 3'b111;

assign zero = (result == 8'h00);
always @(*) begin
        result = 8'h00;
        carry  = 1'b0;

        case (opcode)
            OP_ADD: begin
                {carry, result} = A + B;
            end

            OP_SUB: begin
                // Example using A < B borrow convention;
                result = A - B;
                carry  = (A < B);
            end

            OP_AND: begin
                result = A & B;
                carry  = 1'b0;
            end

            OP_OR: begin
                result = A | B;
                carry  = 1'b0;
            end

            OP_XOR: begin
                result = A ^ B;
                carry  = 1'b0;
            end

            OP_SHL: begin
                result = {A[6:0], 1'b0};
                carry  = A[7];
            end

            OP_SHR: begin
                result = {1'b0, A[7:1]};
                carry  = A[0];
            end

            OP_CMP: begin
                result = (A == B) ? 8'h01 : 8'h00;
                carry  = 1'b0;
            end

            default: begin
                result = 8'h00;
                carry  = 1'b0;
            end
        endcase
    end
endmodule
