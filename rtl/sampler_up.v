module sampler_up (
    input wire RX_IN,
    input wire dat_samp_en,
    input wire clk, rst,
    input wire [4:0] edge_cnt,
    input wire [7:0] prescale,
    output reg sampled_bit,
    output reg [7:0] pre_out,
    output reg [7:0] pre4
);

reg [7:0] pre1;
reg [7:0] pre2;
reg [7:0] pre3;


reg [2:0] zero_counter;
reg [2:0] ones_counter;
reg [2:0] zero_reg;
reg [2:0] ones_reg;

always @(*) begin
    pre_out = prescale;
end

always @(*) begin
    pre1 = (prescale>>1)-'b10;
    pre2 = (prescale>>1)-'b1;
    pre3 = (prescale>>1);
    pre4 = (prescale>>1)+'b1;
end


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
        if(edge_cnt == pre1 || edge_cnt == pre2|| edge_cnt == pre3)
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
    if(edge_cnt >= pre4)
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