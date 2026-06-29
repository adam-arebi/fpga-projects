module pwm (
    input logic CLK,
    output logic LEDR_N);


    localparam pwmMAX = 8191; //2^13 - 1 so it overflows easily
    logic [12:0] count = 0; 
    logic state;
    logic [12:0] duty = 0;
    logic sweep_direction = 1;
    assign LEDR_N = ~state;
    assign state = (count < duty);


    always_ff @(posedge CLK) //counter
        count <= count + 1; //no need for if statement because it automatically wraps

    always_ff@(posedge CLK) //changing sweep direction and changing duty 
        if (count == pwmMAX) 
        begin            //so when the ramp is over
            if (duty == pwmMAX -1) sweep_direction <= 0;//start heading down before reaching top or else it will get stuck at top
            if (duty == 0) sweep_direction <= 1;//start heading up before reaching bottom or it will get stuck
            if (sweep_direction) duty <= duty + 1;
            else duty <= duty - 1;
        end
        
endmodule

