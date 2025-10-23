`timescale 1ns/1ps

module edge_tb;

reg clk_tb, rst_tb;
reg enaple_tb;
wire [3:0] bit_cnt_tb;
wire [3:0] edge_cnt_tb;

edge_bit_counter dut(clk_tb, rst_tb, enaple_tb, bit_cnt_tb, edge_cnt_tb);

always #5 clk_tb = ~clk_tb;


initial begin
    clk_tb = 'b0;
    rst_tb = 'b1;
    enaple_tb = 'b0;
    #20;

    rst_tb = 'b0;
    #10;
    rst_tb = 'b1;

    enaple_tb = 'b1;
    #100;

    enaple_tb = 'b0;
    #10;

    enaple_tb = 'b1;
    #1600
    $stop;
end


endmodule