module decoder2to4_tb;

    logic [1:0] a;
    logic [3:0] y;

    decoder2to4 dut (.a(a), .y(y));

    initial begin
        $dumpfile("decoder2to4.vcd");
        $dumpvars(0, decoder2to4_tb);

        a = 2'b00; #10;
        a = 2'b01; #10;
        a = 2'b10; #10;
        a = 2'b11; #10;

        $finish;
    end

endmodule