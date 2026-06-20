//testbench for comparator4
module comparator4_tb;

    logic [3:0] a;
    logic [3:0] b;
    logic lt;
    logic eq;
    logic gt;

    comparator4 dut (.a(a), .b(b), .lt(lt), .eq(eq), .gt(gt));

    initial begin
        $dumpfile ("comparator4.vcd");
        $dumpvars (0, comparator4_tb);

        a = 4'b0000; b = 4'b0000; #10; //equal both 0
        a = 4'b1111; b = 4'b1111; #10; //equal both 15
        a = 4'b0101; b = 4'b0101; #10; //equal both 5
        a = 4'b0000; b = 4'b1111; #10; //a=0, b=15 less than
        a = 4'b0011; b = 4'b0100; #10; //a=3, b=4 less than
        a = 4'b0111; b = 4'b1000; #10; //a=7, b=8 less than
        a = 4'b1111; b = 4'b0000; #10; //a=15, b=0 greater than
        a = 4'b0100; b = 4'b0011; #10; //a=4, b=3 greater than
        a = 4'b1000; b = 4'b0111; #10; //a=8, b=7 greater than

        $finish;
    end
endmodule