module alu8 (
    input  [7:0] A,
    input  [7:0] B,
    input  [2:0] opcode,
    output reg [7:0] result,
    output reg zero,
    output reg carry
);

    reg [8:0] temp;

    always @(*) begin
        result = 8'b0;
        carry = 1'b0;
        temp = 9'b0;

        case (opcode)

            3'b000: begin
                temp = {1'b0, A} + {1'b0, B};
                result = temp[7:0];
                carry = temp[8];
            end

            3'b001: begin
                temp = {1'b0, A} - {1'b0, B};
                result = temp[7:0];
                carry = temp[8];
            end

            3'b010: begin
                result = A & B;
            end

            3'b011: begin
                result = A | B;
            end

            3'b100: begin
                result = A ^ B;
            end

            3'b101: begin
                result = ~A;
            end

            3'b110: begin
                result = A << 1;
                carry = A[7];
            end

            3'b111: begin
                result = A >> 1;
                carry = A[0];
            end

        endcase

        zero = (result == 8'b00000000);
    end

endmodule