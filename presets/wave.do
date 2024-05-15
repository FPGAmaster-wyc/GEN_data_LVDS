onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group X /tb_top/DUT/clk
add wave -noupdate -group X /tb_top/DUT/clk_in_p
add wave -noupdate -group X /tb_top/DUT/clk_in_n
add wave -noupdate -group X /tb_top/DUT/clk_out_p
add wave -noupdate -group X /tb_top/DUT/clk_out_n
add wave -noupdate -group X /tb_top/DUT/sync_p
add wave -noupdate -group X /tb_top/DUT/sync_n
add wave -noupdate -group X /tb_top/DUT/lvds_data_p
add wave -noupdate -group X /tb_top/DUT/lvds_data_n
add wave -noupdate -group X /tb_top/DUT/uart_tx_p
add wave -noupdate -group X /tb_top/DUT/uart_tx_n
add wave -noupdate -group X /tb_top/DUT/flag_p
add wave -noupdate -group X /tb_top/DUT/flag_n
add wave -noupdate -group X /tb_top/DUT/uart_rx_p
add wave -noupdate -group X /tb_top/DUT/uart_rx_n
add wave -noupdate -group X /tb_top/DUT/rxd_in
add wave -noupdate -group X /tb_top/DUT/ila_clk
add wave -noupdate -group X /tb_top/DUT/flag_clk
add wave -noupdate -group X /tb_top/DUT/locked
add wave -noupdate -group X /tb_top/DUT/rst
add wave -noupdate -group X /tb_top/DUT/flag_cnt
add wave -noupdate -group X /tb_top/DUT/flag
add wave -noupdate -group X /tb_top/DUT/data
add wave -noupdate -group X /tb_top/DUT/sync_code
add wave -noupdate -group X /tb_top/DUT/data1_code
add wave -noupdate -group X /tb_top/DUT/data2_code
add wave -noupdate -group X /tb_top/DUT/idx
add wave -noupdate -group X /tb_top/DUT/pix_cnt
add wave -noupdate -group X /tb_top/DUT/frm_cnt
add wave -noupdate -group X /tb_top/DUT/line_cnt
add wave -noupdate -group X /tb_top/DUT/sof_flag
add wave -noupdate -group X /tb_top/DUT/after_sof_flag
add wave -noupdate -group X /tb_top/DUT/sol_flag
add wave -noupdate -group X /tb_top/DUT/eol_flag
add wave -noupdate -group X /tb_top/DUT/eof_flag
add wave -noupdate -group X /tb_top/DUT/after_sol_flag
add wave -noupdate -expand -group UART /tb_top/DUT/uart_clk
add wave -noupdate -expand -group UART /tb_top/DUT/UART/temp_data
add wave -noupdate -expand -group UART /tb_top/DUT/UART/tx_data
add wave -noupdate -expand -group UART /tb_top/DUT/UART/tx_valid
add wave -noupdate -expand -group UART /tb_top/DUT/UART/ready
add wave -noupdate -expand -group UART /tb_top/DUT/UART/TX/tx_en
add wave -noupdate -expand -group UART /tb_top/DUT/txd_out
add wave -noupdate -expand -group UART /tb_top/DUT/UART/c_state
add wave -noupdate -expand -group UART /tb_top/DUT/UART/n_state
add wave -noupdate -group VCAP /tb_top/DUT/lvds_clk
add wave -noupdate -group VCAP /tb_top/DUT/data1_r
add wave -noupdate -group VCAP /tb_top/DUT/data2_r
add wave -noupdate -group VCAP /tb_top/DUT/sync_r
add wave -noupdate -group VCAP /tb_top/DUT/sync_code
add wave -noupdate -group VCAP /tb_top/DUT/data1_code
add wave -noupdate -group VCAP /tb_top/DUT/data2_code
add wave -noupdate -expand -group TX /tb_top/DUT/UART/TX/i_reset
add wave -noupdate -expand -group TX /tb_top/DUT/UART/TX/i_clk
add wave -noupdate -expand -group TX /tb_top/DUT/UART/TX/i_data
add wave -noupdate -expand -group TX /tb_top/DUT/UART/TX/i_valid
add wave -noupdate -expand -group TX /tb_top/DUT/UART/TX/o_ready
add wave -noupdate -expand -group TX /tb_top/DUT/UART/TX/o_txd
add wave -noupdate -expand -group TX /tb_top/DUT/UART/TX/div_cnt
add wave -noupdate -expand -group TX /tb_top/DUT/UART/TX/tx_en
add wave -noupdate -expand -group TX /tb_top/DUT/UART/TX/stop_cnt
add wave -noupdate -expand -group TX /tb_top/DUT/UART/TX/temp_data
add wave -noupdate -expand -group TX /tb_top/DUT/UART/TX/tx_cnt
add wave -noupdate -expand -group TX /tb_top/DUT/UART/TX/check_data
add wave -noupdate -expand -group TX /tb_top/DUT/UART/TX/c_state
add wave -noupdate -expand -group TX /tb_top/DUT/UART/TX/n_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20253796 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {710364710 ps}
