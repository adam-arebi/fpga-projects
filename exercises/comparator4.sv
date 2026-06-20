//4 bit comparator

module comparator4(
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic lt,
    output logic eq,
    output logic gt
);
    assign lt = a < b;
    assign eq = a == b;
    assign gt = a > b;

endmodule