`timescale 1ns/1ps
module tb;
    reg clk=0, rst=1, press=0, enter=0, clear=0, change=0; reg [3:0] d=0;
    wire unlock, err, alarm; wire [2:0] state;
    lock_top_ref dut(.*);
    always #5 clk = ~clk;
    task key(input [3:0] k); begin d=k; press=1; @(posedge clk); #1 press=0; @(posedge clk); #1; end endtask
    task ent; begin enter=1; @(posedge clk); #1 enter=0; @(posedge clk); #1; end endtask
    task clr; begin clear=1; @(posedge clk); #1 clear=0; @(posedge clk); #1; end endtask
    task chg; begin change=1; @(posedge clk); #1 change=0; @(posedge clk); #1; end endtask
    task num(input [15:0] n); begin key(n[15:12]); key(n[11:8]); key(n[7:4]); key(n[3:0]); end endtask
    integer i;
    initial begin
        repeat(2) @(posedge clk); #1 rst=0;
        $display("reset: state=%0d unlock=%b", state, unlock);
        num(16'h1234); ent; $display("dung: state=%0d unlock=%b", state, unlock);
        repeat(12) @(posedge clk); #1 $display("sau timer: state=%0d unlock=%b", state, unlock);
        num(16'h1111); ent; $display("sai1: state=%0d err=%b fail=%0d", state, err, dut.fail_q);
        num(16'h2222); ent; $display("sai2: state=%0d err=%b fail=%0d", state, err, dut.fail_q);
        key(1); key(2); clr; $display("clear: state=%0d", state);
        num(16'h1234); ent; $display("dung sau 2 sai: state=%0d unlock=%b fail=%0d", state, unlock, dut.fail_q);
        chg; $display("change: state=%0d", state);
        num(16'h5678); ent; $display("doi MK xong: state=%0d pass=%h", state, dut.pass_q);
        num(16'h1234); ent; $display("MK cu: state=%0d err=%b", state, err);
        num(16'h5678); ent; $display("MK moi: state=%0d unlock=%b", state, unlock);
        clr; $display("khoa tay: state=%0d unlock=%b", state, unlock);
        num(16'h0001); ent; num(16'h0002); ent; num(16'h0003); ent;
        $display("sai3: state=%0d alarm=%b fail=%0d", state, alarm, dut.fail_q);
        key(5); $display("bam khi bao dong khong mo: state=%0d unlock=%b", state, unlock);
        clr; num(16'h5678); ent; $display("mat khau dung khi alarm: state=%0d alarm=%b", state, alarm);
        clr; num(16'h9999); ent; $display("master: state=%0d alarm=%b fail=%0d", state, alarm, dut.fail_q);
        num(16'h5678); ent; $display("mo lai: state=%0d unlock=%b", state, unlock);
        $finish;
    end
endmodule
