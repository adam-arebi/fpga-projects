module blink_1hz (
    input logic CLK,
    output logic LEDR_N);

    localparam MAX = 6_000_000;
    logic [23:0] counter = 0;
    logic state = 1;
    assign LEDR_N = ~state; //so that 1 is on

    always_ff@(posedge CLK) 
    begin
        if (counter == MAX-1) 
        begin
            counter <=0;
            state <= ~state;
        end
        
        else 
        begin 
            counter <= counter + 1;
        end
    end
endmodule


