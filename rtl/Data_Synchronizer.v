module DATA_SYNC #(parameter NUM_STAGES = 3, BUS_WIDTH = 8) (
    input wire [BUS_WIDTH-1:0] Unsync_bus,
    input wire                 bus_enable,
    input wire                 CLK, RST,
    output reg [BUS_WIDTH-1:0] sync_bus,
    output reg                 enable_pulse
);

reg [NUM_STAGES-1:0] multi_ff;
reg PG_ff;
reg muxsel;

always @(posedge CLK or negedge RST) begin
    if(!RST)
    begin
        multi_ff <= 'b0;
        sync_bus <= 'b0;
        PG_ff    <= 'b0;
        enable_pulse <= 'b0;
    end
    else
    begin
        multi_ff <= {multi_ff, bus_enable};
        PG_ff    <= multi_ff[NUM_STAGES-1];
        enable_pulse <= muxsel;
        if(muxsel)
        begin
            sync_bus <= Unsync_bus;
        end
    end
end

always @(*) begin
    muxsel = (~PG_ff) & (multi_ff[NUM_STAGES-1]);
end
    
endmodule