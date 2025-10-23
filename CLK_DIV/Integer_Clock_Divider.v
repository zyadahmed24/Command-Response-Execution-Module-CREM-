module ClkDiv (
    input   wire       i_ref_clk,
    input   wire       i_rst_n,
    input   wire       i_clk_en,
    input   wire [7:0] i_div_ratio,
    output  reg        o_div_clk
);

///////////// Declarations /////////////
reg  [7:0] counter;
reg        flag = 'b0;
reg  [7:0] half;
wire [7:0] half_reg;
reg        odd;
wire       CLK_DIV_EN;
reg        o_div_clk_reg;

///////////// Assignments /////////////
assign half_reg   = i_div_ratio>>1;
assign CLK_DIV_EN = i_clk_en && (i_div_ratio!='b0) && (i_div_ratio!='b1);

///////////// To out the refrence clock /////////////
always @(*) begin
    if(!CLK_DIV_EN)
    begin
        o_div_clk = i_ref_clk;
    end
    else
    begin
        o_div_clk = o_div_clk_reg;
    end
end

///////////// LOGIC /////////////
always @(posedge i_ref_clk or negedge i_rst_n) begin
    if(!i_rst_n)
    begin
        o_div_clk_reg <= 'b0;
        counter   <= 'b0;
        flag      <= 'b0;
        half      <= half_reg;      // To do not change the configs while running
        odd       <= i_div_ratio[0];// To do not change the configs while running
    end
    else if(CLK_DIV_EN)
    begin
        if( ((counter == half-'b1+odd)&&(!flag))  || ((counter == half-'b1)&&(flag)) )
        begin
            o_div_clk_reg <= ~o_div_clk_reg;
            flag      <= ~flag;
            counter   <= 'b0;
        end
        else
        begin
            counter   <= counter + 'b1;
        end
    end
    else
    begin
	half	<= half_reg;
	odd	<= i_div_ratio[0];
    end
end

endmodule
