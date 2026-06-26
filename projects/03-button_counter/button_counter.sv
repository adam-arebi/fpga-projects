//BTN_N
module button_counter(
    input logic CLK,
    input logic BTN_N,
    output logic LEDG_N,
    output logic LEDR_N
);

logic ff1, synced;
logic synced_prev;
logic press_pulse;
logic [1:0] count;
assign LEDR_N = ~count [0];
assign LEDG_N = ~count [1];

//synchronizer
always_ff@(posedge CLK)
begin
    ff1 <= ~BTN_N;
    synced <= ff1; 
end

//edge trigger 
always_ff@(posedge CLK)
begin
    synced_prev <= synced; //make synced_prev just whatever synced was at clk edge and it holds it
end

assign press_pulse = synced & ~synced_prev;

//counter, gated by the pulse
always_ff@(posedge CLK)
begin
    if (press_pulse)
    begin
        count <= count+1;
    end
end


endmodule
