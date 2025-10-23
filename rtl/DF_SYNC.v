module DF_SYNC #(parameter BUS_WIDTH = 4) (
    input wire clk, rst,
    input wire [BUS_WIDTH-1:0] in_data,
    output reg [BUS_WIDTH-1:0] out_data
);

parameter NUM_STAGES = 2;

integer i, j, x;
reg     [NUM_STAGES-1:0] FF [BUS_WIDTH-1:0];

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        for(i=0;i<BUS_WIDTH;i=i+1)
        begin
            for(j=0;j<NUM_STAGES;j=j+1)
            begin
                FF[i][j] <= 'b0;
            end
        end
    end
    else
    begin
        for(i=0;i<BUS_WIDTH;i=i+1)
        begin   
            FF[i] <= {FF[i],in_data[i]};         
        end
    end
end

always @(*) begin
    for(x=0;x<BUS_WIDTH;x=x+1)
    begin
        out_data[x] = FF[x][NUM_STAGES-1];
    end
end
    
endmodule