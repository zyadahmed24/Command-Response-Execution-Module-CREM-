module FIFO #(parameter DATA_WIDTH = 8, MEM_DEPTH = 8, PTR_WIDTH = 4) (
    input wire W_CLK, W_RST,
    input wire W_INC,
    input wire [DATA_WIDTH-1:0] WR_DATA,

    input wire R_CLK, R_RST,
    input wire R_INC,

    output wire Full,
    output wire Empty,
    output wire [DATA_WIDTH-1:0] RD_DATA
);

wire [PTR_WIDTH-2:0] raddr;
wire [PTR_WIDTH-2:0] waddr;
wire [PTR_WIDTH-1:0] rptr;
wire [PTR_WIDTH-1:0] wptr;
wire [PTR_WIDTH-1:0] rq2_wptr;
wire [PTR_WIDTH-1:0] wq2_rptr;

FIFO_RD #(PTR_WIDTH, PTR_WIDTH-1) rptr8empty (R_CLK, R_RST, R_INC, rq2_wptr, Empty, raddr, rptr);
FIFO_WR #(PTR_WIDTH, PTR_WIDTH-1) wptr8full  (W_CLK, W_RST, W_INC, wq2_rptr, Full, waddr, wptr); 
DF_SYNC #(PTR_WIDTH)         sync_w2r   (R_CLK, R_RST, wptr, rq2_wptr);
DF_SYNC #(PTR_WIDTH)              sync_r2w   (W_CLK, W_RST, rptr, wq2_rptr);
fifo_mem #(DATA_WIDTH, MEM_DEPTH, PTR_WIDTH-1) mem        (WR_DATA, W_INC, Full, waddr, raddr, W_CLK, RD_DATA);


endmodule