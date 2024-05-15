set_property PACKAGE_PIN F16 [get_ports uart_tx_p]
set_property PACKAGE_PIN F13 [get_ports uart_rx_p]
set_property PACKAGE_PIN E13 [get_ports sync_p]
set_property PACKAGE_PIN E22 [get_ports clk_out_p]
set_property PACKAGE_PIN F19 [get_ports {lvds_data_p[0]}]
set_property PACKAGE_PIN D14 [get_ports {lvds_data_p[1]}]
set_property PACKAGE_PIN T5 [get_ports clk_in_p]
set_property IOSTANDARD LVDS_25 [get_ports {lvds_data_p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {lvds_data_n[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {lvds_data_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {lvds_data_n[0]}]
set_property IOSTANDARD LVDS_25 [get_ports clk_in_p]
set_property IOSTANDARD LVDS_25 [get_ports clk_in_n]
set_property IOSTANDARD LVDS_25 [get_ports clk_out_p]
set_property IOSTANDARD LVDS_25 [get_ports clk_out_n]
set_property IOSTANDARD LVDS_25 [get_ports sync_p]
set_property IOSTANDARD LVDS_25 [get_ports sync_n]
set_property IOSTANDARD LVDS_25 [get_ports uart_rx_p]
set_property IOSTANDARD LVDS_25 [get_ports uart_rx_n]
set_property IOSTANDARD LVDS_25 [get_ports uart_tx_p]
set_property IOSTANDARD LVDS_25 [get_ports uart_tx_n]

set_property PACKAGE_PIN H13 [get_ports flag_p]
set_property IOSTANDARD LVDS_25 [get_ports flag_p]

set_false_path -from [get_pins UART/TX/o_txd_reg/C] -to [get_pins {ILA/inst/ila_core_inst/shifted_data_in_reg[7][0]_srl8/D}]
set_false_path -from [get_pins UART/TX/o_txd_reg/C] -to [get_pins {ILA/inst/ila_core_inst/u_trig/U_TM/N_DDR_MODE.G_NMU[0].U_M/allx_typeA_match_detection.ltlib_v1_0_0_allx_typeA_inst/probeDelay1_reg[0]/D}]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets lvds_clk]




