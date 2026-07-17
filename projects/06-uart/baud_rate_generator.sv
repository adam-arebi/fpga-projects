//9600 baud rate generator
//icebreaker has 12 MHz so tx counter is 12MHz/9600 = 1250. 
//for oversampling rx 12MHz/(9600x16)~= 78
//tx is 11 bits and rx is 7 bits
module baud_rate_generator(
    input logic CLK,
    output logic tx_enb, rx_enb);

    logic [10:0] tx_counter = 0;
    logic [6:0] rx_counter = 0;
    localparam tx_max = 10; //change to 1250
    localparam rx_max = 78; //78.125 but rounded down

    //TX
    always_ff@(posedge CLK)
    begin
        if (tx_counter == tx_max-1) tx_counter <= 0;
        else tx_counter <= tx_counter + 1;
    end

    //RX
    always_ff@(posedge CLK)
    begin
        if (rx_counter == rx_max-1) rx_counter <= 0;
        else rx_counter <= rx_counter +1;
    end

    assign tx_enb = (tx_counter == 0);
    assign rx_enb = (rx_counter == 0);

endmodule