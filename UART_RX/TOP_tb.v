`timescale 1ns/1ps

module uart_rx_tb;

reg rx_in_tb;
reg par_en_tb;
reg par_typ_tb;
reg clk_tb, rst_tb;

wire       data_valid_tb;
wire [7:0] p_data; 

uart_rx dut(rx_in_tb, par_en_tb, par_typ_tb, clk_tb, rst_tb, data_valid_tb, p_data);

reg clk2_tb;

parameter period1 = 5 ;
parameter period2 = 16*period1;

always #(0.5*period1) clk_tb  = ~clk_tb;
always #(0.5*period2) clk2_tb = ~clk2_tb;

initial begin
    init;
    reset;
    start_operation('b0,'b01111011111);
    start_operation('b0,'b01101011111);
    $stop;
end

task init;
begin
    clk_tb     = 'b1;
    clk2_tb    = 'b0;
    rst_tb     = 'b1;
    rx_in_tb   = 'b1;
    par_en_tb  = 'b1;
    par_typ_tb = 'b0;
end
endtask

task reset;
begin
    rst_tb = 'b0;
    #period1;
    rst_tb = 'b1;
    #period1;
end
endtask

task start_operation;
input reg         type;
input reg [11:0]  number;
integer i;
begin
    if(type == 0)
    begin
        par_typ_tb = 'b0;
        for(i=10; i>=0 ; i=i-1)
        begin
            @(posedge clk2_tb);
            rx_in_tb = number[i];
        end
        @(posedge clk2_tb);
        #period2;
    end
    else
    begin
        par_typ_tb = 'b1;
        for(i=10; i>=0 ; i=i-1)
        begin
            @(posedge clk2_tb);
            rx_in_tb = number[i];
        end
        @(posedge clk2_tb);
        #period2;
    end
end
endtask



endmodule