`timescale 1ns/1ps

module samp_tb;

reg rx_in_tb;
reg dat_samp_en_tb;
reg clk_tb, rst_tb;
wire [3:0] edge_cnt_tb;
wire sampled_bit_tb;

reg enaple_tb;
wire [3:0] bit_cnt_tb;
//wire [3:0] edge_cnt_tb;

reg clk2_tb;

sampler dut1(rx_in_tb, dat_samp_en_tb, clk_tb, rst_tb, edge_cnt_tb, sampled_bit_tb);
edge_bit_counter dut2(clk_tb, rst_tb, enaple_tb, bit_cnt_tb, edge_cnt_tb);

always #5 clk_tb = ~clk_tb;
parameter period1 = 10 ;
parameter period2 = 16*10;
always #(0.5*period2) clk2_tb = ~clk2_tb;


initial begin
    clk_tb = 'b1;
    clk2_tb = 'b0;
    rst_tb = 'b1;
    dat_samp_en_tb = 'b0;
    enaple_tb = 'b0;
    rx_in_tb = 'b0;
    #(5*period1);

    rst_tb = 'b0;
    #(1*period1);
    rst_tb = 'b1;
    #(2*period1);

    dat_samp_en_tb = 'b1;
    enaple_tb = 'b1;
    rx_in_tb  = 'b1;
    #(7*period1);
    rx_in_tb = 'b0;
    #period1;
    rx_in_tb = 'b0;
    #period1;
    rx_in_tb = 'b1;
    #(7*period1);
    rx_in_tb = 'b0;
    #(6*period1);
    rx_in_tb = 'b1;
    #period1;
    rx_in_tb = 'b0;
    #period1;
    rx_in_tb = 'b1;

    #(2*period2);
    $stop;
end

endmodule
