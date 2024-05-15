-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Wed Mar 27 16:09:19 2024
-- Host        : DESKTOP-I9U844P running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               E:/my_work/Horizon_lvds/HSS4/data_gen/data_gen.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.vhdl
-- Design      : clk_wiz_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tfgg484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_wiz_0 is
  Port ( 
    clk_189M : out STD_LOGIC;
    clk_25 : out STD_LOGIC;
    clk_100 : out STD_LOGIC;
    clk_10 : out STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1_p : in STD_LOGIC;
    clk_in1_n : in STD_LOGIC
  );

end clk_wiz_0;

architecture stub of clk_wiz_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_189M,clk_25,clk_100,clk_10,locked,clk_in1_p,clk_in1_n";
begin
end;
