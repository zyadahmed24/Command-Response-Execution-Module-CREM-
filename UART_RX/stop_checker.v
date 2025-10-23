module stp_chk (
    input  wire stp_chk_en,
    input  wire sampled_bit,
    output reg  stp_err
);

always @(*) begin
    if(stp_chk_en == 'b1 && sampled_bit == 'b1)
    begin
        stp_err = 'b0;
    end
    else if(stp_chk_en == 'b1 && sampled_bit == 'b0)
    begin
        stp_err = 'b1;
    end
    else
    begin
        stp_err = 'b0;
    end
end
    
endmodule