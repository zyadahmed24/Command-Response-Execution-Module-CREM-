module deserializer (
    input   wire sampled_bit,
    input   wire deser_en,
    input   wire clk, rst,
    output  reg  [7:0]P_DATA
);

reg [3:0] counter;

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        P_DATA <= 'b0;
    end
    else if(deser_en)
    begin
        P_DATA <= {P_DATA[6:0],sampled_bit};
    end
end

endmodule