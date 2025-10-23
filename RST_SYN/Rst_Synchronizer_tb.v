`timescale 1ns/1ps

module RST_SYNC_tb;

parameter num_stag  = 4;

parameter period1   = 20;
parameter period2   = 10;

reg                  clk_tb, clk2_tb;
reg                  rst_tb;
wire                 sync_rst_tb;

RST_SYNC #(.NUM_STAGES(num_stag)) DUT(clk_tb, rst_tb, sync_rst_tb);

always #(0.5*period1) clk2_tb = ~clk2_tb;
always #(0.5*period2) clk_tb  = ~clk_tb;

initial begin
    init;

    rest;
    
    rest;
    $stop;
end

task init;
begin
    clk2_tb  = 'b0;
    clk_tb   = 'b0;
    rst_tb   = 'b1;
    #(10*period1);
end
endtask

task rest;
integer check1, check2;
begin
    @(negedge clk2_tb);
    rst_tb = 'b0;
    check1 = $time;
    $display("rest at time %t   %d", $time, check1);
    #period2;

    rst_tb = 'b1;
    @(sync_rst_tb == 'b1);
    check2 = $time;
    $display("Sync at time %t   %d", $time, check2);

    if(check1 == (check2 - ((num_stag)*10) - 5))
        $display("Test PASS");
    else
        $display("Test FAIL");

        
    #(10*period2);
    #period1;
end
endtask

endmodule