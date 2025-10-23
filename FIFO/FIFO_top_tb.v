`timescale 1ns/1ps

module FIFO_tb;

parameter DATA_WIDTH = 8;
parameter MEM_DEPTH = 8;
parameter PTR_WIDTH = 4;

parameter w_period = 10;
parameter r_period = 25;

reg w_clk_tb, w_rst_tb;
reg w_inc_tb;
reg [DATA_WIDTH-1:0] wr_data_tb;
reg r_clk_tb, r_rst_tb;
reg r_inc_tb;
wire full_tb;
wire empty_tb;
wire [DATA_WIDTH-1:0] rd_data_tb;
integer x;

FIFO #(DATA_WIDTH, MEM_DEPTH, PTR_WIDTH) DUT (w_clk_tb, w_rst_tb, w_inc_tb, wr_data_tb, r_clk_tb, r_rst_tb, r_inc_tb, full_tb, empty_tb, rd_data_tb);

always #(0.5*w_period) w_clk_tb = ~w_clk_tb;
always #(0.5*r_period) r_clk_tb = ~r_clk_tb;

initial begin
    init;
    reset;
    write;
    #(5*r_period);

    for(x=0;x<10;x=x+1)
    begin
        rink;
    end
    $stop;
end
    
task init;
begin
    w_clk_tb = 'b0;
    r_clk_tb = 'b0;
    w_rst_tb = 'b1;
    r_rst_tb = 'b1;
    w_inc_tb = 'b0;
    r_inc_tb = 'b0;
    wr_data_tb = 'b0;
    #(10*r_period);
end
endtask

task reset;
begin
    w_rst_tb = 'b0;
    r_rst_tb = 'b0;
    #(r_period);
    w_rst_tb = 'b1;
    r_rst_tb = 'b1;
    #(5*r_period);
end
endtask

task winc;
begin
    w_inc_tb = 'b1;
    #w_period;
    w_inc_tb = 'b0;
    #w_period;
end
endtask

task write;
integer i;
begin
    wr_data_tb = 'b11110001;
    winc;
    wr_data_tb = 'b11111001;
    winc;
    wr_data_tb = 'b11110101;
    winc;
    wr_data_tb = 'b11110011;
    winc;
    wr_data_tb = 'b11010001;
    winc;
    wr_data_tb = 'b11100001;
    winc;
    wr_data_tb = 'b01110001;
    winc;
    wr_data_tb = 'b11010101;
    winc;
    wr_data_tb = 'b00110001;
    winc;
    wr_data_tb = 'b00111101;
    winc;
    wr_data_tb = 'b00111101;
    winc;
    wr_data_tb = 'b00111101;
    winc;
    wr_data_tb = 'b00111101;
    winc;
    wr_data_tb = 'b00111101;
    winc;
    wr_data_tb = 'b00111101;
    winc;
end
endtask

task rink;
begin
    r_inc_tb = 'b1;
    #r_period;
    r_inc_tb = 'b0;
    #r_period;
end
endtask


endmodule