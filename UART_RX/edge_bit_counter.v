module edge_bit_counter (
    input wire clk, rst,
    input wire enaple,
    output reg  [3:0] bit_cnt,
    output reg  [3:0] edge_cnt
);

reg [7:0] counter;

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        counter <= 'b0;
    end
    else if(enaple)
    begin
        counter <= counter + 'b1;
    end
    else
    begin
        counter <= 'b0;
    end
end

always @(*) begin
    bit_cnt  = counter[7:4];
    edge_cnt = counter[3:0];
end
    
endmodule