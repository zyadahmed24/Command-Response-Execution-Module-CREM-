module sampler (
    input wire RX_IN,
    input wire dat_samp_en,
    input wire clk, rst,
    input wire [3:0] edge_cnt,
    output reg sampled_bit
);

reg [2:0] zero_counter;
reg [2:0] ones_counter;
reg [2:0] zero_reg;
reg [2:0] ones_reg;

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        zero_counter <= 'b0;
        ones_counter <= 'b0;
    end
    else
    begin
        zero_counter <= zero_reg;
        ones_counter <= ones_reg;
    end
end

always @(*) begin
    if(dat_samp_en == 'b1)
    begin
        if(edge_cnt == 'd6 || edge_cnt == 'd7|| edge_cnt == 'd8)
            if(RX_IN == 'b1)
                begin
                    ones_reg = ones_counter + 'b1;
                    zero_reg = zero_counter + 'b0;
                end
            else
                begin
                    ones_reg = ones_counter + 'b0;
                    zero_reg = zero_counter + 'b1;
                end
        else
        begin
            ones_reg = 'b0;
            zero_reg = 'b0;
        end
    end
    else
    begin
        ones_reg = 'b0;
        zero_reg = 'b0;
    end
end

always @(*) begin
    if(edge_cnt >= 9)
    begin
        if(ones_counter > zero_counter)
        begin
            sampled_bit = 'b1;
        end
        else
        begin
            sampled_bit = 'b0;
        end
    end
    else
    begin
        sampled_bit = 'b0;
    end
end
    
endmodule