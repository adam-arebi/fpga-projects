module lightfsm(
    
    input logic CLK,
    input logic BTN_N,
    output logic LEDR_N,
    output logic LEDG_N);
    typedef enum logic [1:0] {RED, GREEN, YELLOW} statetype;
    statetype state = RED, nextstate;
    localparam MAX = 12_000_000; // one second
    logic [25:0] counter = 0;
    logic [25:0] target_cycles;
    logic timer_done;
    assign timer_done = (counter == target_cycles - 1);


    //timer register that handles the counter
    always_ff @(posedge CLK, negedge BTN_N) //needs negedge of BTN_N because it's an inverse button
        begin
            if (!BTN_N) counter <= 0;
            else if (timer_done == 1) counter <= 0;
            else counter <= counter + 1;
        end
        
    //state register
    always_ff @(posedge CLK, negedge BTN_N) //need negedge of BTN_N
        begin
            if (!BTN_N) state <= RED;
            else       state <= nextstate; // This is all it needs!
        end
    

    //next state logic 
    always_comb 
        begin
        // Default values to prevent latches
        nextstate = RED;
        target_cycles = MAX * 3; 

        case (state)
            RED: 
            begin
                target_cycles = MAX * 3; // 3 seconds for red
                if (timer_done) nextstate = GREEN;
                else nextstate = RED;
            end
            S1: 
            begin
                target_cycles = MAX * 5; // 5 seconds for green
                if (timer_done) nextstate = YELLOW;
                else nextstate = GREEN;
            end
            S2: 
            begin
                target_cycles = MAX * 1; // 1 second for yellow
                if (timer_done) nextstate = RED;
                else nextstate = YELLOW;
            end
            default: 
            begin
                nextstate = RED;
                target_cycles = MAX * 3;
            end
        endcase
    end

    //output logic
    //we will have red be red led on, green with green led on, and yellow be when both off
    assign LEDR_N = ~(state == RED);
    assign LEDG_N = ~(state == GREEN);

endmodule
