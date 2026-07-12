module lightfsm(
    
    input logic CLK,
    input logic BTN_N,
    output logic LEDR_N,
    output logic LEDG_N);
    typedef enum logic [2:0] {S0, S1, S2} statetype; //s0 is red, s1 is green, s2 is yellow
    statetype state = S0, nextstate;
    localparam MAX = 12_000_000; // one second
    logic [25:0] counter = 0;
    logic [25:0] target_cycles = 12000000 * 3;
    logic timer_done;
    assign timer_done = (counter == target_cycles - 1);


    //state register
    always_ff @(posedge CLK, negedge BTN_N) 
        begin
            if (!BTN_N) counter <= 0;
            else if (timer_done == 1) counter <= 0;
            else counter <= counter + 1;
        end
        
    //timer register that handles the counter
    always_ff @(posedge CLK, negedge BTN_N) //need negedge of BTN_N
        begin
            if (!BTN_N) state <= S0;
            else       state <= nextstate; // This is all it needs!
        end
    

    //next state logic 
    always_comb 
        begin
        // Default values to prevent latches
        nextstate = S0;
        target_cycles = MAX * 3; 

        case (state)
            S0: 
            begin
                target_cycles = MAX * 3; // 3 seconds for red
                if (timer_done) nextstate = S1;
                else nextstate = S0;
            end
            S1: 
            begin
                target_cycles = MAX * 5; // 5 seconds for green
                if (timer_done) nextstate = S2;
                else nextstate = S1;
            end
            S2: 
            begin
                target_cycles = MAX * 1; // 1 second for yellow
                if (timer_done) nextstate = S0;
                else nextstate = S2;
            end
            default: 
            begin
                nextstate = S0;
                target_cycles = MAX * 3;
            end
        endcase
    end

    //output logic
    //we will have red be red led on, green with green led on, and yellow be when both off
    assign LEDR_N = ~(state == S0);
    assign LEDG_N = ~(state == S1);

endmodule
