module FIFO_WR #(parameter PTR_WIDTH = 4, ADDR_WIDTH = 3) (
    input wire                   clk, rst,
    input wire                   winc,
    input wire  [PTR_WIDTH-1:0]  wq2_rptr,
    output reg                   wfull,
    output reg  [ADDR_WIDTH-1:0] waddr,
    output reg  [PTR_WIDTH-1:0]  wptr
);

reg [PTR_WIDTH-1:0] wptr_reg;
reg [PTR_WIDTH-1:0] wq2_rptr_reg;

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        wptr_reg <= 'b0;
    end
    else if ((winc == 'b1) && (wfull == 'b0))
    begin
        wptr_reg <= wptr_reg + 'b1;
    end
end

always @(*) begin
    waddr = wptr_reg[PTR_WIDTH-2:0];
end

always @(*) begin
    case(wptr_reg)
        'b0000 : wptr = 'b1100;
        'b0001 : wptr = 'b1101;
        'b0011 : wptr = 'b1111;
        'b0010 : wptr = 'b1110;
        'b0110 : wptr = 'b1010;
        'b0111 : wptr = 'b1011;
        'b0101 : wptr = 'b1001;
        'b0100 : wptr = 'b1000;

        'b1100 : wptr = 'b0000;
        'b1101 : wptr = 'b0001;
        'b1111 : wptr = 'b0011;
        'b1110 : wptr = 'b0010;
        'b1010 : wptr = 'b0110;
        'b1011 : wptr = 'b0111;
        'b1001 : wptr = 'b0101;
        'b1000 : wptr = 'b0100;
    endcase
end

always @(*) begin
    case(wq2_rptr)
        'b0000 : wq2_rptr_reg = 'b1100;
        'b0001 : wq2_rptr_reg = 'b1101;
        'b0011 : wq2_rptr_reg = 'b1111;
        'b0010 : wq2_rptr_reg = 'b1110;
        'b0110 : wq2_rptr_reg = 'b1010;
        'b0111 : wq2_rptr_reg = 'b1011;
        'b0101 : wq2_rptr_reg = 'b1001;
        'b0100 : wq2_rptr_reg = 'b1000;

        'b1100 : wq2_rptr_reg = 'b0000;
        'b1101 : wq2_rptr_reg = 'b0001;
        'b1111 : wq2_rptr_reg = 'b0011;
        'b1110 : wq2_rptr_reg = 'b0010;
        'b1010 : wq2_rptr_reg = 'b0110;
        'b1011 : wq2_rptr_reg = 'b0111;
        'b1001 : wq2_rptr_reg = 'b0101;
        'b1000 : wq2_rptr_reg = 'b0100;
    endcase
end
    
always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        wfull <= 'b0;    
    end
    else if ((wptr_reg[3] != wq2_rptr_reg[3]) && (wptr_reg[2:0] == wq2_rptr_reg[2:0]))
    begin
        wfull <= 'b1;
    end
    else
    begin
        wfull <= 'b0;
    end
end
    

endmodule