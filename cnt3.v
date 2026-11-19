// Bo dem len 3 bit (dem vi tri chu so). clr uu tien hon en
module cnt3 (
    input clk, rst, clr, en,
    output reg [2:0] q
);
    always @(posedge clk)
        if (rst | clr) q <= 3'd0;
        else if (en)   q <= q + 3'd1;
endmodule
