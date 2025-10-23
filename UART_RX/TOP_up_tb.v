`timescale 1ns/1ps

module uart_rx_up_tb;

reg       rx_in_tb;
reg       par_en_tb;
reg       par_typ_tb;
reg       clk_tb, rst_tb;
reg [7:0] prescale_tb;

wire       data_valid_tb;
wire [7:0] p_data; 

uart_rx_up dut(rx_in_tb, par_en_tb, par_typ_tb, clk_tb, rst_tb, prescale_tb, data_valid_tb, p_data);

reg clk2_tb;

parameter period1 = 5 ;
parameter period2 = 16*period1; // to change the prescaler, you have to change 16 depending on your prescaler.

always #(0.5*period1) clk_tb  = ~clk_tb;
always #(0.5*period2) clk2_tb = ~clk2_tb;

integer x;

initial begin
    init;
    reset;
    //normal tests
    start_operation_norm('b0,'b01111011111);
    // start_operation_norm('b1,'b01101011111);
    // start_operation_norm_nopar('b0110001111);
    // //send 2 consective 
    // $display("Here we are at %t",$time);
    // start_operation_norm_nopar_2mes('b0111010101,'b0100101111);
    // //start glitch test
    // start_operation_glitch('b0,10-0,'b01001000111);
    // //parity bit error test
    // start_operation_glitch('b0,6,'b01001000111);
    // //stop bit error test
    // start_operation_glitch('b0,0,'b01001000111);
    // //send 2 consective 
    // $display("Here we are at %t",$time);
    // start_operation_norm_nopar_2mes('b0111010101,'b0100101111);
    $stop;
end

task init;
begin
    clk_tb     = 'b0;
    clk2_tb    = 'b0;
    rst_tb     = 'b1;
    rx_in_tb   = 'b1;
    par_en_tb  = 'b1;
    par_typ_tb = 'b0;
    prescale_tb   = 'd16;
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

task start_operation_norm;
input reg         type;
input reg [11:0]  number;
integer i;
begin
    par_en_tb = 'b1;
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


task start_operation_norm_nopar;
input reg [11:0]  number;
integer i;
begin
    par_en_tb = 'b0;
    for(i=9; i>=0 ; i=i-1)
    begin
        @(posedge clk2_tb);
        rx_in_tb = number[i];
    end
    @(posedge clk2_tb);
    #period2;
end
endtask



task start_operation_glitch;
input reg         type;
input reg [3:0]   ind;
input reg [10:0]  number;
integer i;
begin
    par_en_tb = 'b1;
    if(type == 0)
    begin
        par_typ_tb = 'b0;
        for(i=10; i>=0 ; i=i-1)
        begin
            if(i != ind)
            begin
                @(posedge clk2_tb);
                rx_in_tb = number[i];
            end
            else
            begin
                @(posedge clk2_tb);
                rx_in_tb = number[i];
                #(7*period1);
                for(x=0;x<3;x=x+1)
                begin
                    rx_in_tb = ~rx_in_tb;
                    #period1;
                end
                rx_in_tb = number[i];
            end
        end
        @(posedge clk2_tb);
        #period2;
    end
    else
    begin
        par_typ_tb = 'b1;
        for(i=10; i>=0 ; i=i-1)
        begin
            if(i != ind)
            begin
                @(posedge clk2_tb);
                rx_in_tb = number[i];
            end
            else
            begin
                @(posedge clk2_tb);
                rx_in_tb = number[i];
                #(7*period1);
                for(x=0;x<3;x=x+1)
                begin
                    rx_in_tb = ~rx_in_tb;
                    #period1;
                end
                rx_in_tb = number[i];
            end
        end
        @(posedge clk2_tb);
        #period2;
    end
end
endtask

task start_operation_norm_nopar_2mes;
input reg [11:0]  number1, number2;
integer i;
begin
    par_en_tb = 'b0;
    for(i=9; i>=0 ; i=i-1)
    begin
        @(posedge clk2_tb);
        rx_in_tb = number1[i];
    end
    for(i=9; i>=0 ; i=i-1)
    begin
        @(posedge clk2_tb);
        rx_in_tb = number2[i];
    end
    @(posedge clk2_tb);
    #period2;
end
endtask


endmodule