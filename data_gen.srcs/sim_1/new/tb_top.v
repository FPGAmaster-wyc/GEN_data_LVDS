`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/11 16:35:25
// Design Name: 
// Module Name: tb_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_top;

    reg clk;
    reg reset;

    wire clk_out_p,clk_out_n;
    wire sync_p, sync_n;

    wire [1:0] lvds_data_p, lvds_data_n;

    wire uart_tx_p, uart_tx_n;
    wire uart_rx_p, uart_rx_n;

    top DUT(
    .clk(clk),
    //.reset(reset),

    .clk_out_p(clk_out_p),      //output clk 189M
    .clk_out_n(clk_out_n),

    .sync_p(sync_p),        
    .sync_n(sync_n),

    .lvds_data_p(lvds_data_p),
    .lvds_data_n(lvds_data_n),

    .uart_tx_p(uart_tx_p),
    .uart_tx_n(uart_tx_n), 

    .uart_rx_p(uart_rx_p),
    .uart_rx_n(uart_rx_n)
);

    

    initial begin
        clk = 1;
        reset <= 0;
        #200
        reset <= 1;

        #80
        @ (posedge clk)
        reset <= 0;

        #40000
        $stop;

    end

    always #2.5 clk <= ~clk;

endmodule
