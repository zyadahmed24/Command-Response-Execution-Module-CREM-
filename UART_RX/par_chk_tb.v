`timescale 1ns/1ps

module par_tb;

reg par_chk_en_tb;
reg sampled_bit_tb;
reg par_typ_tb;
reg [7:0] p_data_tb;
reg clk_tb, rst_tb;
wire par_err_tb;

par_chk dut(par_chk_en_tb, sampled_bit_tb, p_data_tb, par_typ_tb, par_err_tb);

always #5 clk_tb = ~clk_tb;

integer  i=0;
reg [7:0] x = 8'b11110000;

initial begin
    clk_tb = 'b0;
    rst_tb = 'b1;
    par_chk_en_tb = 'b0;
    par_typ_tb = 'b0;
    #(5*10);

    rst_tb = 'b0;
    #10;
    rst_tb = 'b1;
    #40;

    p_data_tb = x;
    sampled_bit_tb = 'b1;
    par_chk_en_tb = 'b1;
    #10;
    par_chk_en_tb = 'b0;

    #(5*10);
    $stop;
end

endmodule