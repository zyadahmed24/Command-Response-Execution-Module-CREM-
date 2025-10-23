`timescale 1ns/1ps

module DATA_SYNC_tb;

parameter num_stag  = 4;
parameter bus_width = 8;

parameter period1   = 20;
parameter period2   = 10;

reg  [bus_width-1:0] Unsync_bus_tb;
reg                  bus_enable_tb;
reg                  clk_tb, clk2_tb;
reg                  rst_tb;
wire [bus_width-1:0] sync_bus_tb;
wire                 enable_pulse;

DATA_SYNC #(.NUM_STAGES(num_stag), .BUS_WIDTH(bus_width)) DUT(Unsync_bus_tb, bus_enable_tb, clk_tb, rst_tb, sync_bus_tb, enable_pulse);

always #(0.5*period1) clk2_tb = ~clk2_tb;
always #(0.5*period2) clk_tb  = ~clk_tb;

initial begin
    init;

    rest;

    sendData('b10010011);
    sendData('b10111011);
    $stop;
end

task init;
begin
    clk2_tb  = 'b0;
    clk_tb   = 'b0;
    rst_tb   = 'b1;
    Unsync_bus_tb = 'b0;
    bus_enable_tb = 'b0;
    #(10*period1);
end
endtask

task rest;
begin
    rst_tb = 'b0;
    #period1;
    rst_tb = 'b1;
    #period1;
end
endtask

task sendData;
input [bus_width-1:0] data;
integer check1, check2;
begin
    @(negedge clk2_tb);
    bus_enable_tb = 'b1;
    Unsync_bus_tb = data;
    check1 = $time;
    $display("enable at time %t   %d", $time, check1);

    #period1;
    bus_enable_tb = 'b0;
    @(sync_bus_tb == Unsync_bus_tb);
    check2 = $time;
    $display("pulse at time %t   %d", $time, check2);

    if(check1 == (check2 - (num_stag*10) - 5))
        $display("Test PASS");
    else
        $display("Test FAIL");

        
    #(10*period2);
end
endtask

endmodule