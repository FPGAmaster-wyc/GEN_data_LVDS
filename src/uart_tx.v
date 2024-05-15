/*

����ģ�壺
uart_tx #(
	.CHECK_BIT ("None"	)	,       //��None����У��  ��Odd����У��  ��Even��żУ��
	.BPS       (115200	)	,       //ϵͳ������ 
	.CLK       (25_000_000)	,   	//ϵͳʱ��Ƶ�� hz 
	.DATA_BIT  (8		)	,       //����λ��6��7��8��
	.STOP_BIT  (1       )   		//ֹͣλ (1��2��3... ����)
) TX (
	.i_reset(!rst_n),				//����Ч
	.i_clk(clk_a),
	.i_data(tx_data),               //tx_data [7:0]
	.i_valid(tx_valid),
	.o_ready(ready),
	.o_txd(txd)
);

//��У����λͬ��
// assign check_data = ~^temp_data; 
//żУ����λ���
// assign check_data = ^temp_data; 

*/

module uart_tx #(
	parameter CHECK_BIT = "None",       //��None����У��  ��Odd����У��  ��Even��żУ��
	parameter BPS       = 115200,       //ϵͳ������ 
	parameter CLK       = 25_000_000,   //ϵͳʱ��Ƶ�� hz 
	parameter DATA_BIT  = 8,            //����λ��6��7��8��
	parameter STOP_BIT  = 1             //ֹͣλ (1��2��3... ����)
)(
	input	i_reset,
	input	i_clk,
	input	[DATA_BIT-1:0] i_data,
	input	i_valid,
	output	reg o_ready,
	output  reg o_txd
);

    //get uart clk reg
    localparam	BPS_CNT	=	(CLK) / BPS,            //���㲨���ʼ���ֵ
			    BPS_WD	=	log2(BPS_CNT),          //�����ʼ���ֵ��λ��
                STOP_WD =   log2(STOP_BIT+1);       //��ֹͣλ��λ��

    reg     [BPS_WD-1:0] div_cnt;                   //�����ʼ�����
    wire    tx_en;                                  //�������źţ���һ��en����һ�����ݣ�

    reg [STOP_WD-1:0]stop_cnt;                      //ֹͣλ������
    reg [DATA_BIT-1:0] temp_data;                   //��������
    reg [7:0] tx_cnt;                               //bit����

    reg check_data;                                 //��żУ��λֵ

    reg [3:0] c_state, n_state;
    parameter   IDLE    = 0,
                STATE   = 1,
                DATA    = 2,
                CHECK   = 3,
                STOP    = 4;

///////////////////* ʱ�Ӳ����ʼ��� *//////////////////////////////
    assign tx_en = (div_cnt == BPS_CNT - 1);
    always @(posedge i_clk, posedge i_reset) begin
        if (i_reset)
            div_cnt <= 'b0;
        else if (tx_en)
            div_cnt <= 'b0;
        else 
            div_cnt <= div_cnt + 1;     
    end

///////////////////* FSM *3 *//////////////////////////////
    always @(posedge i_clk, posedge i_reset) begin
        if (i_reset)
            c_state <= 0;
        else
            c_state <= n_state;
    end

    always @(*) begin
        case (c_state)
            IDLE    :   begin
                            if (tx_en && i_valid)
                                n_state = STATE;
                            else
                                n_state = IDLE;
            end  

            STATE   :   begin
                            if (tx_en)
                                n_state = DATA; 
                            else
                                n_state = STATE;
            end

            DATA    :   begin
                            if (tx_en && tx_cnt >= DATA_BIT && CHECK_BIT == "None")
                                n_state = STOP;
                            else if (tx_en && tx_cnt >= DATA_BIT)
                                n_state = CHECK;
                            else
                                n_state = DATA;
            end 

            CHECK   :   begin
                            if (tx_en)
                                n_state = STOP;
                            else
                                n_state = CHECK;
            end

            STOP    :   begin
                            if (tx_en && stop_cnt == 1)
                                n_state = IDLE;
                            else
                                n_state = STOP;
            end
            
            default :   n_state = 0;

        endcase
    end

    always @(posedge i_clk, posedge i_reset) begin
        if (i_reset)
            begin
                o_txd <= 1;
                o_ready <= 0;
                stop_cnt <= STOP_BIT + 1;
                temp_data <= 0;
                tx_cnt <= 0;
            end
        else
            case (n_state)
                IDLE    :   begin
                                o_txd <= 1;
                                o_ready <= 0; 
                                stop_cnt <= STOP_BIT + 1;
                end

                STATE   :   begin
                                o_txd <= 0;     
                                check_data <= (CHECK_BIT == "Odd") ? ~^temp_data : ^temp_data;                           
                                if (c_state == IDLE)            //��֤o_readyֻ����һ��ʱ������
                                    begin
                                        o_ready <= 1; 
                                        temp_data <= i_data;
                                    end                                    
                                else
                                    o_ready <= 0;                                    
                end

                DATA    :   begin                                
                                if (tx_en)
                                    begin
                                        o_txd <= temp_data[0];
                                        temp_data <= temp_data >> 1;
                                        tx_cnt <= tx_cnt + 1;    
                                    end                                    
                end

                CHECK   :   begin                                
                                o_txd <= check_data;
                end

                STOP    :   begin
                                if (tx_en)
                                    begin 
                                        o_txd <= 1;
                                        stop_cnt <= stop_cnt - 1;
                                        tx_cnt <= 0;
                                    end 
                end
                default : ;
            endcase
    end

///////////////////*get_data_width*//////////////////////////////
    function integer log2(input integer v);
    begin
        log2 = 0;
        while (v >> log2) 
            log2 = log2 + 1;
    end
    endfunction

endmodule
    