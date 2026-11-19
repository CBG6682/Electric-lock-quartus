// So sanh 4 bit voi hang so 10 -> bao het gio (doi 10 thanh so khac de chinh thoi gian mo)
module cmp_k10 (
    input  [3:0] a,
    output       eq
);
    assign eq = (a == 4'd10);
endmodule
