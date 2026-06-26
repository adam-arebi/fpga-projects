//BTN_N
module button_counter(
    input logic CLK,
    input logic BTN_N,
    output logic LEDG_N,
    output logic LEDR_N
);

logic ff1, synced;
logic clean_prev;
logic press_pulse;
logic [1:0] count;
assign LEDR_N = ~count [0];
assign LEDG_N = ~count [1];

localparam DB_MAX = 120_000; //enough for around 10 ms with 12MHz
logic clean;
logic [16:0] db_count; //enough to holds DB_MAX


//synchronizer
always_ff@(posedge CLK)
begin
    ff1 <= ~BTN_N;
    synced <= ff1; 
end

//edge trigger 
always_ff@(posedge CLK)
begin
    clean_prev <= clean; //make synced_prev just whatever synced was at clk edge and it holds it
end

assign press_pulse = clean & ~clean_prev;

//counter, gated by the pulse
always_ff@(posedge CLK)
begin
    if (press_pulse)
    begin
        count <= count+1;
    end
end


//debouncer

always_ff@(posedge CLK)
begin
    if (synced == clean)
    begin
        db_count <= 0;
    end
    else
    begin
        db_count <= db_count + 1;
        if (db_count == DB_MAX)
        begin
            clean <= synced;
        end
    end
end


endmodule
