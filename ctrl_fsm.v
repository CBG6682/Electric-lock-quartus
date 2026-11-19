// Khoi dieu khien (FSM). Trang thai: 000 IDLE, 001 NHAP, 010 MO, 011 SAI, 100 BAO_DONG, 101 DOI_MK
module ctrl_fsm (
    input        clk, rst,
    input        press, enter, clear, change,
    input        match, full, tmr_done,
    input  [1:0] fail_cnt,
    output [2:0] state,
    output       ld_digit, clr_pos, fail_inc, fail_clr,
    output       ld_pass, sel_master, tmr_en, tmr_clr,
    output       unlock, err, alarm
);
    localparam IDLE = 3'd0, NHAP = 3'd1, MO = 3'd2,
               SAI  = 3'd3, BAO  = 3'd4, DOI = 3'd5;

    reg [2:0] st, nx;
    assign state = st;

    wire ent_ok = enter & full;      // ENTER hop le khi da du 4 so

    always @(posedge clk)
        if (rst) st <= IDLE;
        else     st <= nx;

    always @(*) begin
        nx = st;
        case (st)
            IDLE: if (press) nx = NHAP;
            NHAP: if (clear) nx = IDLE;
                  else if (ent_ok) begin
                      if (match)            nx = MO;
                      else if (fail_cnt[1]) nx = BAO;   // day la lan sai thu 3
                      else                  nx = SAI;
                  end
            MO:   if (tmr_done | clear) nx = IDLE;
                  else if (change)      nx = DOI;
            SAI:  if (press) nx = NHAP;
                  else if (clear) nx = IDLE;
            BAO:  if (ent_ok & match) nx = IDLE;       // match voi ma master
            DOI:  if (clear | ent_ok) nx = IDLE;
            default: nx = IDLE;
        endcase
    end

    wire s_idle = (st == IDLE), s_nhap = (st == NHAP), s_mo  = (st == MO);
    wire s_sai  = (st == SAI),  s_bao  = (st == BAO),  s_doi = (st == DOI);

    assign ld_digit   = press & ~full & (s_idle | s_nhap | s_sai | s_bao | s_doi);
    assign clr_pos    = clear | ent_ok | ((s_idle | s_sai) & ~press) | s_mo;
    assign fail_inc   = s_nhap & ent_ok & ~match;
    assign fail_clr   = s_mo | (s_bao & ent_ok & match);
    assign ld_pass    = s_doi & ent_ok;
    assign sel_master = s_bao;
    assign tmr_en     = s_mo;
    assign tmr_clr    = ~s_mo;
    assign unlock     = s_mo;
    assign err        = s_sai;
    assign alarm      = s_bao;
endmodule
