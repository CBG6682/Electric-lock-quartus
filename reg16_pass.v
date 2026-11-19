// Thanh ghi mat khau 16 bit (4 chu so BCD), reset ve 1234
module reg16_pass (
    input         clk, rst, en,
    input  [15:0] d,
    output reg [15:0] q
);
    always @(posedge clk)
        if (rst)     q <= 16'h1234;
        else if (en) q <= d;
endmodule
