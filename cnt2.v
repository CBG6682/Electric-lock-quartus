// Bo dem len 2 bit (dem so lan nhap sai)
module cnt2 (
    input clk, rst, clr, en,
    output reg [1:0] q
);
    always @(posedge clk)
        if (rst | clr) q <= 2'd0;
        else if (en)   q <= q + 2'd1;
endmodule
