module alu8_tb;

    reg  [7:0] A;
    reg  [7:0] B;
    reg  [2:0] opcode;

    wire [7:0] result;
    wire zero;
    wire carry;

    // Instantiate the ALU
    alu8 uut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .zero(zero),
        .carry(carry)
    );

    initial begin
        $monitor(
            "Time=%0t A=%d B=%d opcode=%b result=%d zero=%b carry=%b",
            $time, A, B, opcode, result, zero, carry
        );
        // Test addition
        A = 8'd10;
        B = 8'd20;
        opcode = 3'b000;
        #10;

        // Test addition with carry
        A = 8'd255;
        B = 8'd1;
        opcode = 3'b000;
        #10;

        // Test subtraction
        A = 8'd20;
        B = 8'd10;
        opcode = 3'b001;
        #10;

        // Test subtraction that gives zero
        A = 8'd10;
        B = 8'd10;
        opcode = 3'b001;
        #10;

        // Test AND
        A = 8'b11001100;
        B = 8'b10101010;
        opcode = 3'b010;
        #10;

        // Test OR
        opcode = 3'b011;
        #10;

        // Test XOR
        opcode = 3'b100;
        #10;

        // Test NOT A
        opcode = 3'b101;
        #10;

        // Test shift left
        A = 8'b10110010;
        opcode = 3'b110;
        #10;

        // Test shift right
        A = 8'b10110011;
        opcode = 3'b111;
        #10;

        $finish;
    end

endmodule