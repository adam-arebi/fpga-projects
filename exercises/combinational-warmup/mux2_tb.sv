module mux2_tb;

    logic d0, d1, s;
    logic y;

    mux2 dut (.d0(d0), .d1(d1), .s(s), .y(y));

    initial begin
        $dumpfile("mux2.vcd");
        $dumpvars(0, mux2_tb);

        d0 = 0; d1 = 0; s = 0; #10;
        d0 = 0; d1 = 1; s = 0; #10;
        d0 = 0; d1 = 1; s = 1; #10;
        d0 = 1; d1 = 0; s = 0; #10;
        d0 = 1; d1 = 0; s = 1; #10;
        d0 = 1; d1 = 1; s = 1; #10;
        $finish;
    end
endmodule