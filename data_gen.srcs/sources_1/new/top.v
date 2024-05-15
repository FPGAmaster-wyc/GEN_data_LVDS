module top(
    //input   clk,            //≤‚ ‘
    input   clk_in_p,       //input clk 200M
    input   clk_in_n,
    //input   reset,

    output  clk_out_p,      //output clk 189M
    output  clk_out_n,

    output  sync_p,        
    output  sync_n,

    output  [1:0]   lvds_data_p,
    output  [1:0]   lvds_data_n,

    output  uart_tx_p,
    output  uart_tx_n,
    
    output flag_p,
    output flag_n,

    input   uart_rx_p,
    input   uart_rx_n
);

    
    IBUFDS uart_rx (.I(uart_rx_p),.IB(uart_rx_n),.O(rxd_in));

    //test
    //OBUFDS test  (.O(clk_in_p),      .OB(clk_in_n),      .I(clk)   );


   wire ila_clk;
   wire uart_clk;
   wire lvds_clk;
   wire flag_clk;
   wire locked;

    clk_wiz_0 PLL
   (
    // Clock out ports
    .clk_189M(lvds_clk),     // output clk_189M
    .clk_25(uart_clk),     // output clk_25
    .clk_100(ila_clk),     // output clk_100
    .clk_10(flag_clk),     // output clk_10
    // Status and control signals
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1_p(clk_in_p),    // input clk_in1_p
    .clk_in1_n(clk_in_n));    // input clk_in1_n

    wire rst = !locked;

    reg [15:0] flag_cnt;
    reg flag;

    OBUFDS flag_o  (.O(flag_p),      .OB(flag_n),      .I(flag_clk)   );


   
/*////////DATA GEN //////////*/
    parameter   SYNC_SOF = 7'b1110100;
    parameter   SYNC_DATA = 7'b1100100;
    parameter   SYNC_IDLE = 7'b1100000;
    parameter   SYNC_BLANK = 7'b0000000;

reg [13:0] data;
reg [7:0] sync_code;
wire [6:0] data1_code;
wire [6:0] data2_code;

wire txd_out;

reg [2:0] idx;
reg [13:0] pix_cnt;
reg [13:0] frm_cnt;
reg [13:0] line_cnt;

reg data1_r;
reg data2_r;
reg sync_r;

assign data1_code = data[6:0];
assign data2_code = data[13:7];

wire sof_flag = idx==6 && pix_cnt==1023 && line_cnt==639;
wire after_sof_flag = idx==6 && pix_cnt==0 && line_cnt==0;
wire sol_flag = (idx==6 && pix_cnt==1023 && line_cnt<511) || sof_flag;
wire eol_flag = idx==6 && pix_cnt==639 && line_cnt<512;
wire eof_flag = idx==6 && pix_cnt==639 && line_cnt==511;
wire after_sol_flag = idx==6 && pix_cnt==0 && line_cnt<512;

always @(posedge lvds_clk, posedge rst)
begin
    if(rst)
        idx <= 0;
    else if(idx==6)
        idx <= 0;
    else
        idx <= idx+1;
end

always @(posedge lvds_clk, posedge rst)
begin
    if(rst)
        pix_cnt <= 0;
    else if(idx==6)
        if(pix_cnt==1023)
            pix_cnt <= 0;
        else
            pix_cnt <= pix_cnt+1;
end

always @(posedge lvds_clk, posedge rst)
begin
    if(rst)
        line_cnt <= 0;
    else if(idx==6 && pix_cnt==1023)
        if(line_cnt == 639)
            line_cnt <= 0;
        else
            line_cnt <= line_cnt+1;
end

always @(posedge lvds_clk, posedge rst)
begin
    if(rst)
        frm_cnt <= 0;
    else if(idx==6 && pix_cnt==1023 && line_cnt==639)
        frm_cnt <= frm_cnt+1;
end

always @(posedge lvds_clk)
begin
    if(sof_flag)
        sync_code <= SYNC_SOF;
    else if(after_sof_flag || sol_flag)
        sync_code <= SYNC_DATA;
    else if(eof_flag)
        sync_code <= SYNC_BLANK;
    else if(eol_flag)
        sync_code <= SYNC_IDLE;
end

always @(posedge lvds_clk)
begin
    if(sof_flag)
        data <= frm_cnt;
    else if(sol_flag)
        data <= line_cnt+1;
    else if(after_sol_flag)
        data <= 1;
    else if(eol_flag)
        data <= 0;
    else if(idx==6 && pix_cnt<639 && line_cnt<512)
        data <= data+1;
end

always @(*)
begin
    case(idx)
        0: begin
            data1_r = data[6];
            data2_r = data[13];
            sync_r = sync_code[6];
        end
        1: begin
            data1_r = data[5];
            data2_r = data[12];
            sync_r = sync_code[5];
        end
        2: begin
            data1_r = data[4];
            data2_r = data[11];
            sync_r = sync_code[4];
        end
        3: begin
            data1_r = data[3];
            data2_r = data[10];
            sync_r = sync_code[3];
        end
        4: begin
            data1_r = data[2];
            data2_r = data[9];
            sync_r = sync_code[2];
        end
        5: begin
            data1_r = data[1];
            data2_r = data[8];
            sync_r = sync_code[1];
        end
        6: begin
            data1_r = data[0];
            data2_r = data[7];
            sync_r = sync_code[0];
        end
        default: begin
            data1_r = 'bx;
            data2_r = 'bx;
            sync_r = 'bx;
        end
    endcase
end


/*////////UART tran module begin //////////*/

  gen_uart_data UART(
	.clk_a(uart_clk),
	.rst_n(locked),
	.txd(txd_out)
);
/*////////UART tran module end //////////*/


    //Single to diff 
    OBUFDS lvdsdata1 (.O(lvds_data_p[0]), .OB(lvds_data_n[0]), .I(data1_r));
    OBUFDS lvdsdata2 (.O(lvds_data_p[1]), .OB(lvds_data_n[1]), .I(data2_r));
    OBUFDS lvdssync  (.O(sync_p),         .OB(sync_n),         .I(sync_r) );
    OBUFDS lvdsclk    (.O(clk_out_p),      .OB(clk_out_n),     .I(lvds_clk)  );
    OBUFDS uarttxd   (.O(uart_tx_p),      .OB(uart_tx_n),      .I(txd_out)   );


    ila_0 ILA (
	.clk(lvds_clk), // input wire clk
	.probe0({data1_r, data2_r, sync_r,  txd_out}) // input wire [3:0] probe0
);

endmodule