// Bo so sanh bang 16 bit
module cmp16 (
    input  [15:0] a, b,
    output        eq
);
    assign eq = (a == b);
endmodule
