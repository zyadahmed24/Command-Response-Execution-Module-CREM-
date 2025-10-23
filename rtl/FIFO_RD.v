module FIFO_RD #(parameter PTR_WIDTH = 4, ADDR_WIDTH = 3) (
    input wire                   clk, rst,
    input wire                   rinc,
    input wire  [PTR_WIDTH-1:0]  rq2_wptr,
    output reg                   rempty,
    output reg  [ADDR_WIDTH-1:0] raddr,
    output reg  [PTR_WIDTH-1:0]  rptr
);



reg [PTR_WIDTH-1:0] rptr_reg;
//reg [PTR_WIDTH-1:0] rq2_wptr_reg;

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        rptr_reg <= 'h0;
    end
    else if (rinc == 'b1)
    begin
        rptr_reg <= rptr_reg + 'b1;
    end
end


always @(*) begin
    raddr = rptr_reg[PTR_WIDTH-2:0];
end

always @(*) begin
    case(rptr_reg)
        'b0000 : rptr = 'b1100;
        'b0001 : rptr = 'b1101;
        'b0011 : rptr = 'b1111;
        'b0010 : rptr = 'b1110;
        'b0110 : rptr = 'b1010;
        'b0111 : rptr = 'b1011;
        'b0101 : rptr = 'b1001;
        'b0100 : rptr = 'b1000;

        'b1100 : rptr = 'b0000;
        'b1101 : rptr = 'b0001;
        'b1111 : rptr = 'b0011;
        'b1110 : rptr = 'b0010;
        'b1010 : rptr = 'b0110;
        'b1011 : rptr = 'b0111;
        'b1001 : rptr = 'b0101;
        'b1000 : rptr = 'b0100;
    endcase
end

// always @(*) begin
//     case(rq2_wptr)
//         'b0000 : rq2_wptr_reg = 'b1100;
//         'b0001 : rq2_wptr_reg = 'b1101;
//         'b0011 : rq2_wptr_reg = 'b1111;
//         'b0010 : rq2_wptr_reg = 'b1110;
//         'b0110 : rq2_wptr_reg = 'b1010;
//         'b0111 : rq2_wptr_reg = 'b1011;
//         'b0101 : rq2_wptr_reg = 'b1001;
//         'b0100 : rq2_wptr_reg = 'b1000;

//         'b1100 : rq2_wptr_reg = 'b0000;
//         'b1101 : rq2_wptr_reg = 'b0001;
//         'b1111 : rq2_wptr_reg = 'b0011;
//         'b1110 : rq2_wptr_reg = 'b0010;
//         'b1010 : rq2_wptr_reg = 'b0110;
//         'b1011 : rq2_wptr_reg = 'b0111;
//         'b1001 : rq2_wptr_reg = 'b0101;
//         'b1000 : rq2_wptr_reg = 'b0100;
//     endcase
// end

reg flag, flag2;

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        flag  <= 'b0;
    end
    else
    begin
        flag  <= 'b1;
    end
end

always @(posedge clk) begin
    begin
        flag2  <= flag;
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        rempty <= 'b1;    
    end
    else if (flag2 == 'b1)  
    begin
        if(rptr == rq2_wptr)
        begin
            rempty <= 'b1;
        end
        else
        begin
            rempty <= 'b0;
        end
    end
end

    

endmodule