// Tap thanh ghi 4 x 4 bit (4 chu so BCD), ghi 1 thanh ghi moi lan theo dia chi waddr
// q[15:12]=R0 (chu so 1), q[11:8]=R1, q[7:4]=R2, q[3:0]=R3 (chu so 4)
module regfile4x4 (
    input         clk, rst, we,
    input  [1:0]  waddr,
    input  [3:0]  d,
    output [15:0] q
);
    reg [3:0] r0, r1, r2, r3;

    always @(posedge clk)
        if (rst) begin
            r0 <= 4'd0; r1 <= 4'd0; r2 <= 4'd0; r3 <= 4'd0;
        end else if (we) begin
            case (waddr)
                2'd0: r0 <= d;
                2'd1: r1 <= d;
                2'd2: r2 <= d;
                2'd3: r3 <= d;
            endcase
        end

    assign q = {r0, r1, r2, r3};
endmodule