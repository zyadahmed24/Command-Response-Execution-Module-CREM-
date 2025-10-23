module strt_chk (
    input  wire strt_chk_en,
    input  wire sampled_bit,
    output reg  strt_glith
);

always @(*) begin
    if(strt_chk_en)
    begin
        if(sampled_bit == 'b0)
        begin
            strt_glith = 'b0;
        end
        else
        begin
            strt_glith = 'b1;
        end
    end
    else
    begin
        strt_glith = 'b0;
    end
end

endmodule