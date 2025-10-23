module parityCalc (
    input  wire [7:0] P_DATA,
    input  wire       Data_Valid,
    input  wire       PAR_TYP,
    input  wire       clk,rst,
    output reg        par_bit
);

reg par_bit_reg;
reg Data_Valid_Q;
reg Data_Valid_reg;
always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        Data_Valid_Q <= 'b0;
    end
    else 
    begin
        Data_Valid_Q <= Data_Valid;
    end
end

always @(*) begin
    Data_Valid_reg = (~Data_Valid_Q) & (Data_Valid);
end

always @(*) begin
    if(Data_Valid_reg)
    begin
        if(!PAR_TYP)
        begin
            par_bit_reg = ^(P_DATA);
        end
        else
        begin
            par_bit_reg = ~(^(P_DATA));
        end
    end
    else
    begin
        par_bit_reg = par_bit;
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        par_bit <= 0;
    end
    else 
    begin
        par_bit <= par_bit_reg;
    end
end


endmodule