// Self-checking testbench for the 8-bit ALU
`timescale 1ns/1ps
module alu_tb;
    reg  [7:0] A, B;
    reg  [2:0] opcode;
    wire [7:0] result;
    wire       carry, zero;

    integer pass_count = 0;
    integer fail_count = 0;

    alu dut (.A(A), .B(B), .opcode(opcode),
             .result(result), .carry(carry), .zero(zero));

    // Apply one set of inputs, wait, compare all three outputs
    task check(input [2:0] op, input [7:0] a, input [7:0] b,
               input [7:0] exp_r, input exp_c, input exp_z,
               input [8*24-1:0] name);
        begin
            opcode = op; A = a; B = b;
            #10;
            if (result === exp_r && carry === exp_c && zero === exp_z) begin
                pass_count = pass_count + 1;
                $display("PASS  %0s", name);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL  %0s: A=%0d B=%0d op=%b | got r=%0d c=%b z=%b | exp r=%0d c=%b z=%b",
                         name, a, b, op, result, carry, zero, exp_r, exp_c, exp_z);
            end
        end
    endtask

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        //        op      A      B      result carry zero  name
        check(3'b000, 8'd5,   8'd3,   8'd8,   1'b0, 1'b0, "ADD 5+3");
        check(3'b000, 8'd255, 8'd1,   8'd0,   1'b1, 1'b1, "ADD 255+1 carry");
        check(3'b000, 8'd0,   8'd0,   8'd0,   1'b0, 1'b1, "ADD 0+0 zero");
        check(3'b000, 8'd200, 8'd100, 8'd44,  1'b1, 1'b0, "ADD 200+100 carry");
        check(3'b001, 8'd10,  8'd3,   8'd7,   1'b0, 1'b0, "SUB 10-3");
        check(3'b001, 8'd3,   8'd10,  8'd249, 1'b1, 1'b0, "SUB 3-10 borrow");
        check(3'b001, 8'd42,  8'd42,  8'd0,   1'b0, 1'b1, "SUB 42-42 zero");
        check(3'b001, 8'd0,   8'd1,   8'd255, 1'b1, 1'b0, "SUB 0-1 borrow");
        check(3'b010, 8'hF0,  8'hAA,  8'hA0,  1'b0, 1'b0, "AND F0&AA");
        check(3'b010, 8'hF0,  8'h0F,  8'h00,  1'b0, 1'b1, "AND F0&0F zero");
        check(3'b011, 8'hF0,  8'h0F,  8'hFF,  1'b0, 1'b0, "OR F0|0F");
        check(3'b011, 8'h00,  8'h00,  8'h00,  1'b0, 1'b1, "OR 0|0 zero");
        check(3'b100, 8'hFF,  8'hAA,  8'h55,  1'b0, 1'b0, "XOR FF^AA");
        check(3'b100, 8'h5A,  8'h5A,  8'h00,  1'b0, 1'b1, "XOR self zero");
        check(3'b101, 8'b0000_0011, 8'd0, 8'b0000_0110, 1'b0, 1'b0, "SHL 03");
        check(3'b101, 8'b1000_0001, 8'd0, 8'b0000_0010, 1'b1, 1'b0, "SHL 81 msb out");
        check(3'b101, 8'b1000_0000, 8'd0, 8'b0000_0000, 1'b1, 1'b1, "SHL 80 to zero");
        check(3'b110, 8'b1100_0000, 8'd0, 8'b0110_0000, 1'b0, 1'b0, "SHR C0");
        check(3'b110, 8'b0000_0011, 8'd0, 8'b0000_0001, 1'b1, 1'b0, "SHR 03 lsb out");
        check(3'b110, 8'b0000_0001, 8'd0, 8'b0000_0000, 1'b1, 1'b1, "SHR 01 to zero");
        check(3'b111, 8'd77,  8'd77,  8'd1,   1'b0, 1'b0, "CMP equal");
        check(3'b111, 8'd77,  8'd78,  8'd0,   1'b0, 1'b1, "CMP unequal");
        check(3'b111, 8'd0,   8'd0,   8'd1,   1'b0, 1'b0, "CMP 0==0");
        check(3'b111, 8'd255, 8'd255, 8'd1,   1'b0, 1'b0, "CMP 255==255");

        $display("----------------------------------------");
        $display("RESULT: %0d passed, %0d failed", pass_count, fail_count);
        if (fail_count == 0) $display("ALL TESTS PASSED");
        $finish;
    end
endmodule
