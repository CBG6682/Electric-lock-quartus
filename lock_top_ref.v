// Top-level THAM CHIEU (chi de kiem tra bang Verilog). Trong Quartus ban ve lai bang .bdf
module lock_top_ref (
    input clk, rst, press, enter, clear, change,
    input  [3:0] d,
    output unlock, err, alarm,
    output [2:0] state
);
    wire [3:0]  dec_y;
    wire [3:0]  r0, r1, r2, r3;
    wire [2:0]  pos;
    wire [15:0] in_word = {r0, r1, r2, r3};
    wire [15:0] pass_q, master, ref_word;
    wire [1:0]  fail_q;
    wire [3:0]  tmr_q;
    wire match, tmr_done;
    wire ld_digit, clr_pos, fail_inc, fail_clr, ld_pass, sel_master, tmr_en, tmr_clr;

    dec2to4 u_dec (.en(ld_digit), .sel(pos[1:0]), .y(dec_y));
    reg4 u_r0 (.clk(clk), .rst(rst), .en(dec_y[0]), .d(d), .q(r0));
    reg4 u_r1 (.clk(clk), .rst(rst), .en(dec_y[1]), .d(d), .q(r1));
    reg4 u_r2 (.clk(clk), .rst(rst), .en(dec_y[2]), .d(d), .q(r2));
    reg4 u_r3 (.clk(clk), .rst(rst), .en(dec_y[3]), .d(d), .q(r3));
    cnt3 u_pos (.clk(clk), .rst(rst), .clr(clr_pos), .en(ld_digit), .q(pos));

    reg16_pass u_pass (.clk(clk), .rst(rst), .en(ld_pass), .d(in_word), .q(pass_q));

    master_const u_mst (.y(master));
    mux16_2 u_mux (.sel(sel_master), .a(pass_q), .b(master), .y(ref_word));
    cmp16 u_cmp (.a(in_word), .b(ref_word), .eq(match));

    cnt2 u_fail (.clk(clk), .rst(rst), .clr(fail_clr), .en(fail_inc), .q(fail_q));

    cnt4 u_tmr (.clk(clk), .rst(rst), .clr(tmr_clr), .en(tmr_en), .q(tmr_q));
    cmp_k10 u_k10 (.a(tmr_q), .eq(tmr_done));

    ctrl_fsm u_fsm (.clk(clk), .rst(rst), .press(press), .enter(enter), .clear(clear),
        .change(change), .match(match), .full(pos[2]), .tmr_done(tmr_done),
        .fail_cnt(fail_q), .state(state), .ld_digit(ld_digit), .clr_pos(clr_pos),
        .fail_inc(fail_inc), .fail_clr(fail_clr), .ld_pass(ld_pass), .sel_master(sel_master),
        .tmr_en(tmr_en), .tmr_clr(tmr_clr), .unlock(unlock), .err(err), .alarm(alarm));
endmodule
