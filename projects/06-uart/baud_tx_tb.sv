module baud_tx_tb();

    logic CLK, reset;
    logic tx_enb, tx_start;
    logic [7:0] data_in;
    logic tx;
    logic tx_ready;

    //instantiate the dut
    baud_rate_generator brg(.CLK(CLK), .tx_enb(tx_enb), .rx_enb());
    tx dut (.CLK(CLK), .reset(reset), .tx_enb(tx_enb), .tx_start(tx_start), .data_in(data_in), .tx(tx), .tx_ready(tx_ready));

    //clock
    initial CLK = 0;
    always #5 CLK = ~CLK;

    //stimulus
    initial begin
        $dumpfile("tx_tb.vcd"); //waveform output for surfer
        $dumpvars(0, baud_tx_tb);

        reset = 0; data_in = 0; tx_start = 0; //set initial values

        #20; reset = 1; 

        #40; data_in = 8'h41; //the byte (41)
        tx_start = 1;
        #10; tx_start = 0; //one clock cycle
        #5000 $finish;
    end
endmodule




