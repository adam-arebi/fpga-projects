module tx (
    input logic CLK, 
    input logic reset,

    input logic tx_enb, //from the baud rate generator 
    input logic tx_start, //trigger to start new transmission

    input logic [7:0] data_in, //8 bit parallel bits
    output logic tx, //serial bit stream

    output logic tx_ready); //status logic: 1 when idle, 0 when busy transmitting

    typedef enum logic [1:0] {IDLE, START, DATA, STOP} statetype;
    statetype state, nextstate;

    logic [2:0] bit_cntr ; //bit counter so that only 8 bits are sent

    logic pending; //1: a byte is waiting to be sent, 0: no byte incoming

    logic [7:0] data_reg; //snapshot of data_in, taken when transmission begins

    //state regster
    always_ff@(posedge CLK, negedge reset)
    begin
        if (!reset) state <= IDLE;
        else state <= nextstate;
    end
    
    //increment bit counter sequential logic
    always_ff@(posedge CLK)
    begin
        if (!reset) bit_cntr <= 0;
        else if ((state == IDLE) | (state == START)) bit_cntr <= 0;
        else if (state == DATA)
        begin
            if (tx_enb) bit_cntr <= bit_cntr +1;
            else bit_cntr <= bit_cntr;
        end
        
    end

    //ensure that the start isn't lost within the cycles
    always_ff@(posedge CLK)
    begin
        if (!reset) pending <= 0;
        else if (tx_start) pending <= 1;
        else if (state == IDLE && tx_enb) pending <= 0;
    end

    //latch the byte at the moment we accept it
    always_ff@(posedge CLK)
    begin
        if (state == IDLE && tx_enb && pending) data_reg <= data_in;
    end

    //next state logic
    always_comb
    begin
        case (state)
            IDLE : 
            begin
                if (tx_enb && pending) nextstate = START;
                else nextstate = IDLE;
            end
            START :
            begin
                if (tx_enb) nextstate = DATA;
                else nextstate = START;
            end
            DATA : 
            begin
                if (tx_enb) 
                begin
                    if (bit_cntr == 7) nextstate = STOP;
                    else nextstate = DATA;
                end
                else nextstate = DATA;
            end
            STOP :
            begin
                if (tx_enb) nextstate = IDLE;
                else nextstate = STOP;
            end
            default : nextstate = IDLE;
        endcase
    end
                
    assign tx_ready = (state == IDLE) && !pending; //idle and nothing cued
    always_comb
    case (state)
        IDLE : tx = 1;
        START : tx = 0;
        DATA : tx = data_reg[bit_cntr]; //picks LSB by picking the index of cntr (UART standard)
        STOP : tx = 1;
        default : tx = 1;
    endcase

endmodule
