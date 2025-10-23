`timescale 1ns/1ps

module test_bench;

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////

reg ref_clk_tb;
reg uart_clk_tb;
reg rst_tb;
reg rx_in_tb;
wire tx_out_tb;

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////

reg [10:0]get_capt;

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////

TOP DUT (ref_clk_tb, uart_clk_tb, rst_tb, rx_in_tb, tx_out_tb);

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////

parameter ref_period = 10;
parameter uart_period = 271.26736;

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////

always #(0.5*ref_period) ref_clk_tb = ~ref_clk_tb;
always #(0.5*uart_period) uart_clk_tb = ~uart_clk_tb;

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////

initial begin

    //System functions.
    $dumpfile("SYSTEM_TOP.vcd") ;       
    $dumpvars; 


    init;
    reset;


    // WRITE_CMD
    send_data('b0,'hAA);
    send_data('b0,'h05);
    send_data('b1,'h26);

    // READ_CMD
    send_data('b0,'hBB);
    send_data('b0,'h05);


    check(1, 'h26);


    // WRITE_CMD
    send_data('b0,'hAA);
    send_data('b1,'h07);
    send_data('b1,'h31);

    // READ_CMD
    send_data('b0,'hBB);
    send_data('b1,'h07);

    check(2, 'h31);

    // WRITE_CMD
    send_data('b0,'hAA);
    send_data('b1,'h08);
    send_data('b0,'h30);

    // READ_CMD
    send_data('b0,'hBB);
    send_data('b1,'h08);

    check(3, 'h30);

    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    
    // ALU_W_OP
    send_data('b0,'hCC);
    send_data('b0,'h05);
    send_data('b1,'h07);
    send_data('b0,'h00);

    check(4, 'h57);

    // ALU_W_OP
    send_data('b0,'hCC);
    send_data('b0,'h05);
    send_data('b1,'h08);
    send_data('b0,'h00);

    check(5, 'h56);

    // ALU_W_OP
    send_data('b0,'hCC);
    send_data('b1,'h07);
    send_data('b1,'h08);
    send_data('b0,'h00);

    check(6, 'h61);


    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////

    // WRITE_CMD
    send_data('b0,'hAA);
    send_data('b0,'h00);
    send_data('b1,'h43);

    // WRITE_CMD
    send_data('b0,'hAA);
    send_data('b1,'h01);
    send_data('b0,'h30);

    // ALU_W_NOP
    send_data('b0,'hCC);
    send_data('b0,'h00);
    send_data('b1,'h01);
    send_data('b0,'h00);

    check(7, 'h73);


    // WRITE_CMD
    send_data('b0,'hAA);
    send_data('b0,'h00);
    send_data('b0,'h03);

    // WRITE_CMD
    send_data('b0,'hAA);
    send_data('b1,'h01);
    send_data('b1,'h01);

    // ALU_W_NOP
    send_data('b0,'hDD);
    send_data('b1,'h01);

    check(8, 'h02);

    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    


    #(32*100*uart_period);
    $stop;
end


/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
task init;
begin
    ref_clk_tb = 'b0;
    uart_clk_tb = 'b0;
    rst_tb = 'b1;
    rx_in_tb = 'b1;
    #(5 * uart_period);
end
endtask

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
task reset;
begin
    rst_tb = 'b0;
    #ref_period;
    rst_tb = 'b1;
    #(100*uart_period);
end
endtask

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
task send_data;
input par_bit;
input [7:0] byte;
integer i;
begin
    for(i=10;i>=0;i=i-1)
    begin
        if(i==10)
        begin
            rx_in_tb = 'b0;
        end
        else if(i==1)
        begin
            rx_in_tb = par_bit;
        end
        else if(i==0)
        begin
            rx_in_tb = 'b1;
        end
        else
        begin
            rx_in_tb = byte[i-2];
        end
        #(32*uart_period);
    end
    //#(32*uart_period);
end
endtask

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
task capture;
integer i;
begin
    @(negedge tx_out_tb)
    for(i=10;i>=0;i=i-1)
    begin
        get_capt[i] = tx_out_tb;
        #(32*uart_period);
    end
end
endtask

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
task check;
input [16:0] ind;
input [7:0]  byte;
begin
    capture;
    if(get_capt[8:1] == byte)
    begin
        $display("Test%d is PASSED", ind);
    end
    else
    begin
        $display("Test%d is FAILED", ind);
    end

end
endtask

endmodule