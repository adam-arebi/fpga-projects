module pwm2led (
    input logic CLK,
    output logic LEDR_N,
    output logic LEDG_N);

    localparam pwmMAX = 8191; //2^13 - 1 so it overflows easily
    logic [12:0] count = 0; 
    logic [12:0] duty_red = 0;
    logic sweep_direction = 1;

    assign LEDR_N = ~(count < duty_red);
    assign LEDG_N = ~(count < (pwmMAX - duty_red));


    always_ff @(posedge CLK) //counter
        count <= count + 1; //no need for if statement because it automatically wraps

    always_ff@(posedge CLK) //changing sweep direction and changing duty 
        if (count == pwmMAX) 
        begin            //so when the ramp is over
            if (duty_red == pwmMAX -1) sweep_direction <= 0;//start heading down before reaching top or else it will get stuck at top
            if (duty_red == 0) sweep_direction <= 1;//start heading up before reaching bottom or it will get stuck
            if (sweep_direction) duty_red <= duty_red + 1;
            else duty_red <= duty_red - 1;
        end
        
endmodule

