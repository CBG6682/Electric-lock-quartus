// MUX 2 -> 1, 16 bit. sel=0 chon a, sel=1 chon b
module mux16_2 (
    input         sel,
    input  [15:0] a, b,
    output [15:0] y
);
    assign y = sel ? b : a;
endmodule
