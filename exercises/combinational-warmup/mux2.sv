module mux2 (
    input  logic d0,
    input  logic d1,
    input  logic s,
    output logic y
);
  // Selects d1 when s is high, d0 when s is low
  assign y = s ? d1 : d0;

endmodule