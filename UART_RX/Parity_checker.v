module par_chk (
    input  wire par_chk_en,
    input  wire sampled_bit,
    input  wire [7:0] P_DATA,
    input  wire PAR_TYP,
    output reg  par_err
);

reg       par_right_reg;

    
always @(*) begin
    if(!PAR_TYP)
    begin
        par_right_reg = ^(P_DATA);
    end
    else
    begin
        par_right_reg = ~(^(P_DATA));
    end        
end

always @(*) begin
    if(par_chk_en == 'b1 && sampled_bit == par_right_reg)
    begin
        par_err = 'b0;
    end
    else if(par_chk_en == 'b1 && sampled_bit != par_right_reg)
    begin
        par_err = 'b1;
    end
    else
    begin
        par_err = 'b0;
    end
end

endmodule