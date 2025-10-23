module RegFile #(parameter ADDR_WIDTH=4, MEM_DEPTH=16, MEM_WIDTH=8)(

    input  wire                   WrEn,
    input  wire                   RdEn,
    input  wire                   clk,
    input  wire                   rst,
    input  wire  [ADDR_WIDTH-1:0] address,
    input  wire  [MEM_WIDTH-1:0]  WrData,

    input  wire                   ALU_nop_opr,
    input  wire                   ALU_op_opr,
    input  wire                   ALU_op_A, ALU_op_B,

    output reg   [MEM_WIDTH-1:0]  RdData,
    output reg                    RdData_Valid,

    output reg   [MEM_WIDTH-1:0]  OP_A,
    output reg   [MEM_WIDTH-1:0]  OP_B,
    output wire   [MEM_WIDTH-1:0]  REG2,
    output wire   [MEM_WIDTH-1:0]  REG3
);

reg RdData_Valid_reg;
reg RdData_Valid_Q;

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        RdData_Valid_Q <= 'b0;
    end
    else
    begin
        RdData_Valid_Q <= RdData_Valid_reg;
    end
end

always @(*) begin
    RdData_Valid = (~RdData_Valid_Q) & (RdData_Valid_reg);
end


// 2D Array
reg [MEM_WIDTH-1:0] regs [MEM_DEPTH-1:0];        //  reg [15:0] memory [7:0];

reg [ADDR_WIDTH-1:0] OP_A_addr;
reg [ADDR_WIDTH-1:0] OP_B_addr;

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        OP_A_addr <= 'b0;
        OP_B_addr <= 'b1;
    end
    else if(ALU_op_A && ALU_op_opr)
    begin
        OP_A_addr <= address;
    end
    else if(ALU_op_B && ALU_op_opr)
    begin
        OP_B_addr <= address;
    end
end

always @(*) begin
    if(ALU_op_opr == 'b1)
    begin
        OP_A = regs[OP_A_addr];
        OP_B = regs[OP_B_addr];
    end
    else 
    begin
        OP_A = regs[0];
        OP_B = regs[1];
    end
end

always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        regs[0] <= 'b0;
        regs[1] <= 'b0;
        regs[2] <= 'b100000_01;
        regs[3] <= 'b0010_0000;
        regs[4] <= 'b0;
        regs[5] <= 'b0;
        regs[6] <= 'b0;
        regs[7] <= 'b0;
        regs[8] <= 'b0;
        regs[9] <= 'b0;
        regs[10] <= 'b0;
        regs[11] <= 'b0;
        regs[12] <= 'b0;
        regs[13] <= 'b0;
        regs[14] <= 'b0;
        regs[15] <= 'b0;

        RdData_Valid = 'b0;
        RdData = regs[15];
    end
    else
    begin
        if(WrEn && ~RdEn)
        begin
            regs[address] <= WrData;
        end
        else if(RdEn && ~WrEn)
        begin
            RdData <= regs[address];
            RdData_Valid_reg <= 'b1;
        end
        else
        begin
            RdData_Valid_reg <= 'b0;
        end
    end
end

//assign REG0 = reg[0];
//assign REG1 = reg[1];
assign REG2 = regs[2];
assign REG3 = regs[3];

endmodule