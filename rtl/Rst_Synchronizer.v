module RST_SYNC #(parameter NUM_STAGES = 2) (
    input  wire                 CLK,
    input  wire                 RST,
    output reg                  SYNC_RST
);

reg     [NUM_STAGES-1:0] FF;

always @(posedge CLK or negedge RST) begin
    if(!RST)
    begin
        FF <= 'b0;
    end
    else
    begin
        FF = {FF, 1'b1};
    end
end

always @(*) begin
    SYNC_RST = FF[NUM_STAGES-1];
end
    
endmodule