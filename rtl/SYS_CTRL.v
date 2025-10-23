module SYS_CTRL (
    input wire [7:0] DATA,
    input wire sync_enaple,
    input wire fifo_full,
    input wire [7:0] Rd_D,
    input wire Rd_D_Vld,
    input wire clk, rst,

    input wire [7:0] ALU_OUT,
    input wire ALU_Vld,

    output reg ALU_nop_opr,
    output reg ALU_op_opr,
    output reg ALU_op_A, ALU_op_B,
    
    output reg [3:0] ALU_FUN,
    output reg ALU_EN,

    output reg Gate_En,

    output reg [7:0] WR_DATA,
    output reg WR_INC,
    output reg WrEn, RdEn,
    output reg [3:0] Addr,
    output reg [7:0] Wr_D
);

parameter  WIDTH = 5;

reg [WIDTH-1:0] IDLE              = 'b00001;
reg [WIDTH-1:0] RF_Wr_CMD         = 'b00010;
reg [WIDTH-1:0] RF_Rd_CMD         = 'b00100;
reg [WIDTH-1:0] ALU_OPR_W_OP_CMD  = 'b01000;
reg [WIDTH-1:0] ALU_OPR_W_NOP_CMD = 'b10000;

reg [WIDTH-1:0] current, next;

reg Wr_Flag;
reg Rd_Flag;
reg AO_Flag;
reg main_counter_clear_flag;
reg [3:0] main_counter;
reg [3:0] Addr_reg;
reg Addr_en;
reg WR_INC_reg;
reg WR_INC_Q;
reg Addr_en_reg_1;
reg Addr_en_reg_Q_1;
reg Addr_en_1;
reg Addr_en_reg_2;
reg Addr_en_reg_Q_2;
reg Addr_en_2;
reg ALU_op_A_reg;
reg ALU_op_A_Q;
reg ALU_op_B_reg;
reg ALU_op_B_Q;
reg ALU_EN_reg;
reg ALU_EN_Q;

           

//ALU_EN
always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        ALU_EN_Q <= 'b0;
    end
    else
    begin
        ALU_EN_Q <= ALU_EN_reg;
    end
end

always @(*) begin
    ALU_EN = (~ALU_EN_Q) & (ALU_EN_reg);
end

//A
always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        ALU_op_A_Q <= 'b0;
    end
    else
    begin
        ALU_op_A_Q <= ALU_op_A_reg;
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        ALU_op_A <= 'b0;
    end
    else
    begin
        ALU_op_A <= (~ALU_op_A_Q) & (ALU_op_A_reg);
    end
end

//B
always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        ALU_op_B_Q <= 'b0;
    end
    else
    begin
        ALU_op_B_Q <= ALU_op_B_reg;
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        ALU_op_B <= 'b0;
    end
    else
    begin
        ALU_op_B <= (~ALU_op_B_Q) & (ALU_op_B_reg);
    end
end


//WR_INC
always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        WR_INC_Q <= 'b0;
    end
    else 
    begin
        WR_INC_Q <= WR_INC_reg;
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        WR_INC <= 'b0;
    end
    else
    begin
        WR_INC = (~WR_INC_Q) & (WR_INC_reg);
    end
end

//Addr
always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        Addr_en_reg_Q_1 <= 'b0;
    end
    else 
    begin
        Addr_en_reg_Q_1 <= Addr_en_reg_1;
    end
end

always @(*) begin
    Addr_en_1 = (~Addr_en_reg_Q_1) & (Addr_en_reg_1);
end

//Addr
always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        Addr_en_reg_Q_2 <= 'b0;
    end
    else 
    begin
        Addr_en_reg_Q_2 <= Addr_en_reg_2;
    end
end

always @(*) begin
    Addr_en_2 = (~Addr_en_reg_Q_2) & (Addr_en_reg_2);
end

///////////////////////////////////
always @(*) begin
    Addr_en = Addr_en_1 | Addr_en_2;
end


always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        main_counter <= 'b0;
    end
    else if(sync_enaple)
    begin
        main_counter <= main_counter + 'b1;
    end
    else if(main_counter_clear_flag)
    begin
        main_counter = 'b0;
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        current <= IDLE;
    end
    else
    begin
        current <= next;
    end
end

always @(*) begin
    case(current)
        IDLE : begin
            if(sync_enaple == 'b1 && DATA == 'hAA)
            begin
                next = RF_Wr_CMD;
            end
            else if(sync_enaple == 'b1 && DATA == 'hBB)
            begin
                next = RF_Rd_CMD;
            end
            else if(sync_enaple == 'b1 && DATA == 'hCC)
            begin
                next = ALU_OPR_W_OP_CMD;
            end
            else if(sync_enaple == 'b1 && DATA == 'hDD)
            begin
                next = ALU_OPR_W_NOP_CMD;
            end
            else
            begin
                next = IDLE;
            end
        end

        RF_Wr_CMD : begin
            if(Wr_Flag == 'b1)
            begin
                next = RF_Wr_CMD;
            end
            else
            begin
                next = IDLE;
            end
        end

        RF_Rd_CMD : begin
            if(Rd_Flag == 'b1)
            begin
                next = RF_Rd_CMD;
            end
            else
            begin
                next = IDLE;
            end
        end

        ALU_OPR_W_OP_CMD : begin
            if(AO_Flag == 'b1)
            begin
                next = ALU_OPR_W_OP_CMD;
            end
            else
            begin
                next = IDLE;
            end
        end

        ALU_OPR_W_NOP_CMD : begin
            if(AO_Flag == 'b1)
            begin
                next = ALU_OPR_W_NOP_CMD;
            end
            else
            begin
                next = IDLE;
            end
        end
    endcase
end

always @(*) begin
    case(current)
        IDLE : begin
            WR_INC_reg  = 'b0;
            WrEn    = 'b0;
            RdEn    = 'b0;
            Addr_reg    = 'b0;
            Addr_en_reg_1 = 'b0;
            Addr_en_reg_2 = 'b0;
            Wr_D    = 'b0;
            Wr_Flag = 'b0;
            Rd_Flag = 'b0;
            AO_Flag = 'b0;
            ALU_nop_opr = 'b0;
            ALU_op_opr  = 'b0;
            ALU_op_A_reg = 'b0;
            ALU_op_B_reg = 'b0;
            ALU_FUN = 'b0;
            ALU_EN_reg = 'b0;
            Gate_En = 'b0;
            main_counter_clear_flag = 'b1;
        end

        RF_Wr_CMD : begin
            WR_INC_reg  = 'b0;
            WrEn    = 'b0;
            RdEn    = 'b0;
            Addr_reg    = 'b0;
            Addr_en_reg_1 = 'b0;
            Addr_en_reg_2 = 'b0;
            Wr_D    = 'b0;
            Wr_Flag = 'b1;
            Rd_Flag = 'b0;
            AO_Flag = 'b0;
            ALU_nop_opr = 'b0;
            ALU_op_opr  = 'b0;
            ALU_op_A_reg = 'b0;
            ALU_op_B_reg = 'b0;
            ALU_FUN = 'b0;
            ALU_EN_reg = 'b0;
            Gate_En = 'b0;
            main_counter_clear_flag = 'b0;
            if(main_counter == 'b10)
            begin
                WR_INC_reg  = 'b0;
                WrEn    = 'b0;
                RdEn    = 'b0;
                Addr_reg    = DATA;
                Addr_en_reg_1 = 'b1;
                Addr_en_reg_2 = 'b0;
                Wr_D    = 'b0;
                Wr_Flag = 'b1;
                Rd_Flag = 'b0;
                AO_Flag = 'b0;
                ALU_nop_opr = 'b0;
                ALU_op_opr  = 'b0;
                ALU_op_A_reg = 'b0;
                ALU_op_B_reg = 'b0;
                ALU_FUN = 'b0;
                ALU_EN_reg = 'b0;
                Gate_En = 'b0;
                main_counter_clear_flag = 'b0;
            end
            else if(main_counter == 'b11)
            begin
                WR_INC_reg  = 'b0;
                WrEn    = 'b1;
                RdEn    = 'b0;
                Addr_reg    = 'b0;
                Addr_en_reg_1 = 'b0;
                Addr_en_reg_2 = 'b0;
                Wr_D    = DATA;
                Wr_Flag = 'b0;
                Rd_Flag = 'b0;
                AO_Flag = 'b0;
                ALU_nop_opr = 'b0;
                ALU_op_opr  = 'b0;
                ALU_op_A_reg = 'b0;
                ALU_op_B_reg = 'b0;
                ALU_FUN = 'b0;
                ALU_EN_reg = 'b0;
                Gate_En = 'b0;
                main_counter_clear_flag = 'b1;
            end
            else
            begin
                WR_INC_reg  = 'b0;
                WrEn    = 'b0;
                RdEn    = 'b0;
                Addr_reg    = 'b0;
                Addr_en_reg_1 = 'b0;
                Addr_en_reg_2 = 'b0;
                Wr_D    = 'b0;
                Wr_Flag = 'b1;
                Rd_Flag = 'b0;
                AO_Flag = 'b0;
                ALU_nop_opr = 'b0;
                ALU_op_opr  = 'b0;
                ALU_op_A_reg = 'b0;
                ALU_op_B_reg = 'b0;
                ALU_FUN = 'b0;
                ALU_EN_reg = 'b0;
                Gate_En = 'b0;
                main_counter_clear_flag = 'b0;
            end
        end

        RF_Rd_CMD : begin
            WR_INC_reg  = 'b0;
            WrEn    = 'b0;
            RdEn    = 'b0;
            Addr_reg    = 'b0;
            Addr_en_reg_1 = 'b0;
            Addr_en_reg_2 = 'b0;
            Wr_D    = 'b0;
            Wr_Flag = 'b0;
            Rd_Flag = 'b1;
            AO_Flag = 'b0;
            ALU_nop_opr = 'b0;
            ALU_op_opr  = 'b0;
            ALU_op_A_reg = 'b0;
            ALU_op_B_reg = 'b0;
            ALU_FUN = 'b0;
            ALU_EN_reg = 'b0;
            Gate_En = 'b0;
            main_counter_clear_flag = 'b0;
            if(main_counter == 'b01)
            begin
                WR_INC_reg  = 'b0;
                WrEn    = 'b0;
                RdEn    = 'b0;
                Addr_reg    = 'b0;
                Addr_en_reg_1 = 'b0;
                Addr_en_reg_2 = 'b0;
                Wr_D    = 'b0;
                Wr_Flag = 'b0;
                Rd_Flag = 'b1;
                AO_Flag = 'b0;
                ALU_nop_opr = 'b0;
                ALU_op_opr  = 'b0;
                ALU_op_A_reg = 'b0;
                ALU_op_B_reg = 'b0;
                ALU_FUN = 'b0;
                ALU_EN_reg = 'b0;
                Gate_En = 'b0;
                main_counter_clear_flag = 'b0;
            end
            else if(main_counter == 'b10)
            begin
                WR_INC_reg  = 'b0;
                WrEn    = 'b0;
                Addr_reg    = DATA;
                Addr_en_reg_1 = 'b1;
                Addr_en_reg_2 = 'b0;
                RdEn    = 'b1;
                Wr_D    = 'b0;
                Wr_Flag = 'b0;
                Rd_Flag = 'b1;
                AO_Flag = 'b0;
                ALU_nop_opr = 'b0;
                ALU_op_opr  = 'b0;
                ALU_op_A_reg = 'b0;
                ALU_op_B_reg = 'b0;
                ALU_FUN = 'b0;
                ALU_EN_reg = 'b0;
                Gate_En = 'b0;
                main_counter_clear_flag = 'b1;
            end
            else
            begin
                WR_INC_reg  = 'b1;
                WrEn    = 'b0;
                RdEn    = 'b0;
                Addr_reg    = 'b0;
                Addr_en_reg_1 = 'b0;
                Addr_en_reg_2 = 'b0;
                Wr_D    = 'b0;
                Wr_Flag = 'b0;
                Rd_Flag = 'b0;
                AO_Flag = 'b0;
                ALU_nop_opr = 'b0;
                ALU_op_opr  = 'b0;
                ALU_op_A_reg = 'b0;
                ALU_op_B_reg = 'b0;
                ALU_FUN = 'b0;
                ALU_EN_reg = 'b0;
                Gate_En = 'b0;
                main_counter_clear_flag = 'b0;
            end
        end

        ALU_OPR_W_OP_CMD : begin
            WR_INC_reg  = 'b0;
            WrEn    = 'b0;
            RdEn    = 'b0;
            Addr_reg    = 'b0;
            Addr_en_reg_1 = 'b0;
            Addr_en_reg_2 = 'b0;
            Wr_D    = 'b0;
            Wr_Flag = 'b0;
            Rd_Flag = 'b0;
            AO_Flag = 'b1;
            ALU_nop_opr = 'b0;
            ALU_op_opr  = 'b1;
            ALU_op_A_reg = 'b0;
            ALU_op_B_reg = 'b0;
            ALU_FUN = 'b0;
            ALU_EN_reg = 'b0;
            Gate_En = 'b1;
            main_counter_clear_flag = 'b0;
            if(main_counter == 'b01)
            begin
                WR_INC_reg  = 'b0;
                WrEn    = 'b0;
                RdEn    = 'b0;
                Addr_reg    = 'b0;
                Addr_en_reg_1 = 'b0;
                Addr_en_reg_2 = 'b0;
                Wr_D    = 'b0;
                Wr_Flag = 'b0;
                Rd_Flag = 'b0;
                AO_Flag = 'b1;
                ALU_nop_opr = 'b0;
                ALU_op_opr  = 'b1;
                ALU_op_A_reg = 'b0;
                ALU_op_B_reg = 'b0;
                ALU_FUN = 'b0;
                ALU_EN_reg = 'b0;
                Gate_En = 'b1;
                main_counter_clear_flag = 'b0;
            end
            else if(main_counter == 'b10)
            begin
                WR_INC_reg  = 'b0;
                WrEn    = 'b0;
                RdEn    = 'b0;
                Addr_reg    = DATA;
                Addr_en_reg_1 = 'b1;
                Addr_en_reg_2 = 'b0;
                Wr_D    = 'b0;
                Wr_Flag = 'b0;
                Rd_Flag = 'b0;
                AO_Flag = 'b1;
                ALU_nop_opr = 'b0;
                ALU_op_opr  = 'b1;
                ALU_op_A_reg = 'b1;
                ALU_op_B_reg = 'b0;
                ALU_FUN = 'b0;
                ALU_EN_reg = 'b0;
                Gate_En = 'b1;
                main_counter_clear_flag = 'b0;
            end
            else if(main_counter == 'b11)
            begin
                WR_INC_reg  = 'b0;
                WrEn    = 'b0;
                RdEn    = 'b0;
                Addr_reg    = DATA;
                Addr_en_reg_1 = 'b0;
                Addr_en_reg_2 = 'b1;
                Wr_D    = 'b0;
                Wr_Flag = 'b0;
                Rd_Flag = 'b0;
                AO_Flag = 'b1;
                ALU_nop_opr = 'b0;
                ALU_op_opr  = 'b1;
                ALU_op_A_reg = 'b0;
                ALU_op_B_reg = 'b1;
                ALU_FUN = 'b0;
                ALU_EN_reg = 'b0;
                Gate_En = 'b1;
                main_counter_clear_flag = 'b0;
            end
            else if(main_counter == 'b100)
            begin
                WR_INC_reg  = 'b0;
                WrEn    = 'b0;
                RdEn    = 'b0;
                Addr_reg    = 'b0;
                Addr_en_reg_1 = 'b0;
                Addr_en_reg_2 = 'b0;
                Wr_D    = 'b0;
                Wr_Flag = 'b0;
                Rd_Flag = 'b0;
                AO_Flag = 'b1;
                ALU_nop_opr = 'b0;
                ALU_op_opr  = 'b1;
                ALU_op_A_reg = 'b0;
                ALU_op_B_reg = 'b0;
                ALU_FUN = DATA;
                ALU_EN_reg = 'b1;
                Gate_En = 'b1;
                main_counter_clear_flag = 'b1;
            end
            else
            begin
                WR_INC_reg  = 'b1;
                WrEn    = 'b0;
                RdEn    = 'b0;
                Addr_reg    = 'b0;
                Addr_en_reg_1 = 'b0;
                Addr_en_reg_2 = 'b0;
                Wr_D    = 'b0;
                Wr_Flag = 'b0;
                Rd_Flag = 'b0;
                AO_Flag = 'b0;
                ALU_nop_opr = 'b0;
                ALU_op_opr  = 'b0;
                ALU_op_A_reg = 'b0;
                ALU_op_B_reg = 'b0;
                ALU_FUN = 'b0;
                ALU_EN_reg = 'b0;
                Gate_En = 'b0;
                main_counter_clear_flag = 'b0;
            end
        end

        ALU_OPR_W_NOP_CMD : begin
            WR_INC_reg  = 'b0;
            WrEn    = 'b0;
            RdEn    = 'b0;
            Addr_reg    = 'b0;
            Addr_en_reg_1 = 'b0;
            Addr_en_reg_2 = 'b0;
            Wr_D    = 'b0;
            Wr_Flag = 'b0;
            Rd_Flag = 'b0;
            AO_Flag = 'b1;
            ALU_nop_opr = 'b1;
            ALU_op_opr  = 'b0;
            ALU_op_A_reg = 'b0;
            ALU_op_B_reg = 'b0;
            ALU_FUN = 'b0;
            ALU_EN_reg = 'b0;
            Gate_En = 'b1;
            main_counter_clear_flag = 'b0;
            if(main_counter == 'b01)
            begin
                WR_INC_reg  = 'b0;
                WrEn    = 'b0;
                RdEn    = 'b0;
                Addr_reg    = 'b0;
                Addr_en_reg_1 = 'b0;
                Addr_en_reg_2 = 'b0;
                Wr_D    = 'b0;
                Wr_Flag = 'b0;
                Rd_Flag = 'b0;
                AO_Flag = 'b1;
                ALU_nop_opr = 'b1;
                ALU_op_opr  = 'b0;
                ALU_op_A_reg = 'b0;
                ALU_op_B_reg = 'b0;
                ALU_FUN = 'b0;
                ALU_EN_reg = 'b0;
                Gate_En = 'b1;
                main_counter_clear_flag = 'b0;
            end
            else if(main_counter == 'b10)
            begin
                WR_INC_reg  = 'b0;
                WrEn    = 'b0;
                Addr_reg    = 'b0;
                Addr_en_reg_1 = 'b0;
                Addr_en_reg_2 = 'b0;
                RdEn    = 'b0;
                Wr_D    = 'b0;
                Wr_Flag = 'b0;
                Rd_Flag = 'b0;
                AO_Flag = 'b1;
                ALU_nop_opr = 'b1;
                ALU_op_opr  = 'b0;
                ALU_op_A_reg = 'b0;
                ALU_op_B_reg = 'b0;
                ALU_FUN = DATA;
                ALU_EN_reg = 'b1;
                Gate_En = 'b1;
                main_counter_clear_flag = 'b1;
            end
            else
            begin
                WR_INC_reg  = 'b1;
                WrEn    = 'b0;
                RdEn    = 'b0;
                Addr_reg    = 'b0;
                Addr_en_reg_1 = 'b0;
                Addr_en_reg_2 = 'b0;
                Wr_D    = 'b0;
                Wr_Flag = 'b0;
                Rd_Flag = 'b0;
                AO_Flag = 'b0;
                ALU_nop_opr = 'b0;
                ALU_op_opr  = 'b0;
                ALU_op_A_reg = 'b0;
                ALU_op_B_reg = 'b0;
                ALU_FUN = 'b0;
                ALU_EN_reg = 'b0;
                Gate_En = 'b1;
                main_counter_clear_flag = 'b0;
            end
        end


    endcase
end


always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        Addr <= 'b0;
    end
    else if(Addr_en)
    begin
        Addr <= Addr_reg;
    end
end

// always @(*) begin
//     WR_DATA = Rd_D;
// end

reg ALU_Vld_reg;
reg ALU_Vld_Q;

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        ALU_Vld_Q <= 'b0;
    end
    else
    begin
        ALU_Vld_Q <= ALU_Vld;
    end
end

always @(*) begin
    ALU_Vld_reg = (~ALU_Vld_Q) & (ALU_Vld);
end


always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        WR_DATA <= 'b0;
    end
    else if(ALU_Vld_reg)
    begin
        WR_DATA <= ALU_OUT;
    end
    else if(Rd_D_Vld)
    begin
        WR_DATA <= Rd_D;
    end    
end

endmodule