module TOP (
    input wire REF_CLK,
    input wire UART_CLK,
    input wire RST,
    input wire RX_IN,

    output wire TX_OUT
);

wire PAR_EN, PAR_TYP;
wire data_valid;
wire [7:0] P_DATA;
wire [7:0] RD_DATA;
wire F_EMPTY;
wire FIFO_FULL;
wire RD_INC;
wire [7:0] WR_DATA;
wire WR_INC;
wire Busy;
wire TX_CLK;
wire RX_CLK;
wire RST1, RST2;
wire [3:0] mux_rx_out;
wire WrEn, RdEn;
wire [3:0] Addr;
wire [7:0] Wr_D, Rd_D;
wire Rd_D_Vld;
wire [7:0] REG2, REG3;
wire [7:0] OP_A, OP_B;
wire [7:0] DATA;
wire sync_enaple;
wire [7:0] ALU_OUT;
wire ALU_OUT_VALID;
wire ALU_nop_opr;
wire ALU_op_opr;
wire ALU_op_A, ALU_op_B;
wire [3:0] ALU_FUN;
wire ALU_EN;
wire Gate_En;
wire ALU_CLK;


CLK_GATE clk_gate (Gate_En, REF_CLK, ALU_CLK);

ALU alu (OP_A, OP_B, ALU_EN, ALU_FUN, ALU_CLK, RST1, ALU_OUT, ALU_OUT_VALID);

SYS_CTRL sys_ctrl (DATA, sync_enaple, FIFO_FULL, Rd_D, Rd_D_Vld, REF_CLK, RST1, ALU_OUT, ALU_OUT_VALID, ALU_nop_opr, ALU_op_opr, ALU_op_A, ALU_op_B, ALU_FUN, ALU_EN, Gate_En, WR_DATA, WR_INC, WrEn, RdEn, Addr, Wr_D);


DATA_SYNC data_synchron (P_DATA, data_valid, REF_CLK, RST1, DATA, sync_enaple);

FIFO fifo (REF_CLK, RST1, WR_INC, WR_DATA, TX_CLK, RST2, RD_INC, FIFO_FULL, F_EMPTY, RD_DATA);


RegFile reg_file (WrEn, RdEn, REF_CLK, RST1, Addr, Wr_D, ALU_nop_opr, ALU_op_opr, ALU_op_A, ALU_op_B, Rd_D, Rd_D_Vld, OP_A, OP_B, REG2, REG3);


RST_SYNC rst_sync_1 (REF_CLK, RST, RST1);
RST_SYNC rst_sync_2 (UART_CLK, RST, RST2);

mux_rx_clk_div mux_rx_cd({2'b00, REG2[7:2]}, mux_rx_out);
ClkDiv clk_div_RX (UART_CLK, RST2, 1'b1, {4'b0000,mux_rx_out}, RX_CLK);
ClkDiv clk_div_TX (UART_CLK, RST2, 1'b1, REG3, TX_CLK);

uart_rx_up uart_rx(RX_IN, REG2[0], REG2[1], RX_CLK, RST2, {2'b00, REG2[7:2]}, data_valid, P_DATA);
uart_tx    uart_tx(REG2[0], RD_DATA, !F_EMPTY, REG2[1], TX_CLK, RST2, TX_OUT, Busy);
pulse_gen pulse_generate(TX_CLK, RST2, Busy, RD_INC);




    
endmodule