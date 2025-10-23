module mux_rx_clk_div (
    input wire [7:0] in_data,
    output reg [3:0] out_data
);

always @(*) begin
    case(in_data)
        'd32 : out_data = 'b1;
        'd16 : out_data = 'b10;
        'd8  : out_data = 'b100;
        'd4  : out_data = 'b1000;
    endcase
end
    
endmodule