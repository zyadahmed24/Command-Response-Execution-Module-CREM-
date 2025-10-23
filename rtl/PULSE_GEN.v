module pulse_gen (
    input wire clk, rst,
    input wire in_bit,
    output reg out_bit
);

reg in_bit_Q;

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        in_bit_Q <= 'b0;
    end
    else
    begin
        in_bit_Q <= in_bit;
    end
end

always @(*) begin
    out_bit = (~in_bit_Q) & (in_bit);
end
    
endmodule