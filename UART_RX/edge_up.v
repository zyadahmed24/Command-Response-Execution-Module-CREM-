module edge_bit_counter_up (
    input wire clk, rst,
    input wire enaple,
    input wire  [7:0] pre_out,
    output reg  [3:0] bit_cnt,
    output reg  [4:0] edge_cnt
);


always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        bit_cnt  <= 'b0;
        edge_cnt <= 'b0;
    end
    else if(enaple)
    begin
        edge_cnt <= edge_cnt + 'b1;
        if(edge_cnt == (pre_out - 'b1))
        begin
            bit_cnt <= bit_cnt + 'b1;
            edge_cnt <= 'b0;
        end
    end
    else
    begin
        bit_cnt  <= 'b0;
        edge_cnt <= 'b0;
    end
end

    
endmodule