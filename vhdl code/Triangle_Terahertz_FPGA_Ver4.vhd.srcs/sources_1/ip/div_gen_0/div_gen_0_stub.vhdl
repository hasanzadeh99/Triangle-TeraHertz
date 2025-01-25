-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Mon Sep 16 07:27:47 2024
-- Host        : DESKTOP-IOGF5IK running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               D:/Dropbox/Rodgel/Projects/1402/Triangle-TeraHertz/Triangle_Terahertz_FPGA_Ver4/Triangle_Terahertz_FPGA_Ver4.vhd/Triangle_Terahertz_FPGA_Ver4.vhd.srcs/sources_1/ip/div_gen_0/div_gen_0_stub.vhdl
-- Design      : div_gen_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7s25csga225-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div_gen_0 is
  Port ( 
    aclk : in STD_LOGIC;
    s_axis_divisor_tvalid : in STD_LOGIC;
    s_axis_divisor_tready : out STD_LOGIC;
    s_axis_divisor_tdata : in STD_LOGIC_VECTOR ( 55 downto 0 );
    s_axis_dividend_tvalid : in STD_LOGIC;
    s_axis_dividend_tready : out STD_LOGIC;
    s_axis_dividend_tdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    m_axis_dout_tvalid : out STD_LOGIC;
    m_axis_dout_tdata : out STD_LOGIC_VECTOR ( 71 downto 0 )
  );

end div_gen_0;

architecture stub of div_gen_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "aclk,s_axis_divisor_tvalid,s_axis_divisor_tready,s_axis_divisor_tdata[55:0],s_axis_dividend_tvalid,s_axis_dividend_tready,s_axis_dividend_tdata[63:0],m_axis_dout_tvalid,m_axis_dout_tdata[71:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "div_gen_v5_1_15,Vivado 2019.1";
begin
end;
