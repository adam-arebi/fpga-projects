module counter_leds (
    input  logic CLK,
    output logic LEDR_N,
    output logic LEDG_N);

    localparam MAX = 12_000_000; //once every 1 second
    logic [23:0] divider = 0;
    logic [1:0] count = 0;
    assign LEDR_N = ~count [0];
    assign LEDG_N = ~count [1];


    always_ff@(posedge CLK) 
    begin
        if (divider == MAX-1) 
        begin
            divider <=0;
            count <= count + 1;

            if  (count == 3)
            begin
                count <= 0;
            end
        end
        
        else 
        begin 
            divider <= divider + 1;
        end
        
    end
endmodule