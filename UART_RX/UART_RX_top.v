module uart_rx (
    input wire        RX_IN,
    input wire        PAR_EN,
    input wire        PAR_TYP,
    input wire        clk, rst,

    output wire       data_valid,
    output wire [7:0] P_DATA
);


wire       dat_samp_en;
wire [3:0] edge_cnt;
wire [3:0] bit_cnt;
wire       enaple;
wire       deser_en;
wire       stp_err;
wire       stp_chk_en;
wire       strt_glith;
wire       strt_chk_en;
wire       par_err;
wire       par_chk_en;
wire       sampled_bit;


fsm FSM             (RX_IN, PAR_EN, edge_cnt, bit_cnt, par_err, strt_glith, stp_err, clk, rst, dat_samp_en, enaple, deser_en, par_chk_en, strt_chk_en, stp_chk_en, data_valid);
edge_bit_counter EDG(clk, rst, enaple, bit_cnt, edge_cnt);
sampler SAM         (RX_IN, dat_samp_en, clk, rst, edge_cnt, sampled_bit);
deserializer DES    (sampled_bit, deser_en, clk, rst, P_DATA);
par_chk PAR         (par_chk_en, sampled_bit, P_DATA, PAR_TYP, par_err);
strt_chk STR        (strt_chk_en, sampled_bit, strt_glith);
stp_chk STP         (stp_chk_en, sampled_bit, stp_err);
    
endmodule