// Bo giai ma 2 -> 4 co enable
module dec2to4 (
    input        en,
    input  [1:0] sel,
    output [3:0] y
);
    assign y = en ? (4'b0001 << sel) : 4'b0000;
endmodule
