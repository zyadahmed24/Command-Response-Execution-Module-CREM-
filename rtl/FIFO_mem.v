module fifo_mem #(parameter DATA_WIDTH = 8, MEM_DEPTH = 8, ADDR_WIDTH = 3) (
    input  wire [DATA_WIDTH-1:0] WR_DATA,
    input  wire                  winc, wfull,
    input  wire [ADDR_WIDTH-1:0] waddr, raddr,
    input  wire                  wclk,
    output reg  [DATA_WIDTH-1:0] RD_DATA
);

reg [DATA_WIDTH-1:0] mem [MEM_DEPTH-1:0];
reg                  wclken;

always @(*) begin
    wclken = winc & (~wfull);
end

always @(posedge wclk) begin
    if(wclken)
    begin
        mem [waddr] <= WR_DATA;
    end
    RD_DATA <= mem [raddr];
end

    
endmodule