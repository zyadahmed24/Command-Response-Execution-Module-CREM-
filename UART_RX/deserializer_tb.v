`timescale 1ns/1ps

module des_tb;

reg sampled_bit_tb;
reg deser_en_tb;
reg clk_tb, rst_tb;
wire [7:0] p_data_tb;

deserializer dut(sampled_bit_tb, deser_en_tb, clk_tb, rst_tb, p_data_tb);

always #5 clk_tb = ~clk_tb;

integer  i=0;
reg [7:0] x = 8'b11110000;

initial begin
    clk_tb = 'b0;
    rst_tb = 'b1;
    deser_en_tb = 'b0;
    #(5*10);

    rst_tb = 'b0;
    #10; 
    rst_tb = 'b1;
    #10;

    deser_en_tb = 'b1;

    for(i=7; i>=0 ; i=i-1)
    begin
        sampled_bit_tb = x[i];
        #10;
    end


    #50;
    $stop;
end


endmodule