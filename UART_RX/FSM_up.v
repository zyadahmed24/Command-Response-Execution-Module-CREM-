module fsm_up (
    input  wire       RX_IN,
    input  wire       PAR_EN,
    input  wire [4:0] edge_cnt,
    input  wire [3:0] bit_cnt,
    input  wire       par_err,
    input  wire       strt_glith,
    input  wire       stp_err,
    input  wire       clk, rst,
    input  wire [7:0] pre4,

    output reg        dat_samp_en,
    output reg        enaple,
    output reg        deser_en,
    output reg        par_chk_en,
    output reg        strt_chk_en,
    output reg        stp_chk_en,
    output reg        data_valid
);


reg [5:0] IDLE   = 'b000001;
reg [5:0] START  = 'b000010;
reg [5:0] DATA   = 'b000100;
reg [5:0] PARITY = 'b001000;
reg [5:0] STOP   = 'b010000;
reg [5:0] OUTPUT = 'b100000;

reg [5:0] current;
reg [5:0] next;

reg       data_valid_reg;

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        current    <= IDLE;
        data_valid <= 'b0;
    end
    else
    begin
        current <= next;
        data_valid <= data_valid_reg;
    end
end


always @(*) begin
    case(current)
        IDLE : begin
            if(RX_IN == 'b0)
            begin
                next = START;
            end
            else
            begin
                next = IDLE;
            end
        end

        START : begin
            if(bit_cnt == 'b0)
            begin
                if(strt_glith == 'b1)
                begin
                    next = IDLE;
                end
                else
                begin
                    next = START;
                end
            end
            else
            begin
                next = DATA;
            end
        end

        DATA : begin
            if(bit_cnt >= 'd1 && bit_cnt <= 'd8)
            begin
                next = DATA;
            end
            else
            begin
                if(!PAR_EN)
                begin
                    next = STOP;
                end
                else
                begin
                    next = PARITY;
                end
            end
        end

        PARITY : begin
            if(bit_cnt == 'd9)
            begin
                if(par_err)
                begin
                    next = IDLE;
                end
                else
                begin
                    next = PARITY;
                end
            end
            else
            begin
                next = STOP;
            end
        end

        STOP : begin
            if((PAR_EN == 'b0 && bit_cnt == 'd9) || (PAR_EN == 'b1 && bit_cnt == 'd10))
            begin
                next = IDLE;
            end
            else
            begin
                next = STOP;
            end
        end

	default : begin
	    next = IDLE;
	end

    endcase
end


always @(*) begin
    dat_samp_en     = 'b0;
    enaple          = 'b0;
    deser_en        = 'b0;
    par_chk_en      = 'b0;
    strt_chk_en     = 'b0;
    stp_chk_en      = 'b0;
    data_valid_reg  = 'b0;

    case(current)
        IDLE : begin
            dat_samp_en     = 'b0;
            enaple          = 'b0;
            deser_en        = 'b0;
            par_chk_en      = 'b0;
            strt_chk_en     = 'b0;
            stp_chk_en      = 'b0;
            data_valid_reg  = 'b0;
        end

        START : begin
            dat_samp_en = 'b1;
            enaple      = 'b1;
            if(edge_cnt == pre4)
            begin
                strt_chk_en = 'b1;
            end
            else
            begin
                strt_chk_en = 'b0;
            end
        end

        DATA : begin
            dat_samp_en = 'b1;
            enaple      = 'b1;
            if(edge_cnt == pre4)
            begin
                deser_en = 'b1;
            end
            else
            begin
                deser_en = 'b0;
            end
        end

        PARITY : begin
            dat_samp_en = 'b1;
            enaple      = 'b1;
            if(edge_cnt == pre4)
            begin
                par_chk_en = 'b1;
            end
            else
            begin
                par_chk_en = 'b0;
            end
        end

        STOP : begin
            dat_samp_en = 'b1;
            enaple      = 'b1;
            if(edge_cnt == pre4)
            begin
                stp_chk_en = 'b1;
            end
            else
            begin
                stp_chk_en = 'b0;
            end

            if(stp_err)
            begin
                data_valid_reg = 'b0;
            end
            else
            begin
                data_valid_reg = 'b1;
            end
        end

    endcase
end

    
endmodule
