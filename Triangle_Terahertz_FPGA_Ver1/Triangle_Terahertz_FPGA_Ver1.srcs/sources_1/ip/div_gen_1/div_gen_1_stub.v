// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Mon Mar 13 22:33:30 2023
// Host        : DESKTOP-8AHMAU3 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               E:/Other/Dropbox/Rodgel/Projects/Triangle-TeraHertz/Triangle_Terahertz_FPGA_Ver1/Triangle_Terahertz_FPGA_Ver1.srcs/sources_1/ip/div_gen_1/div_gen_1_stub.v
// Design      : div_gen_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s50csga324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "div_gen_v5_1_15,Vivado 2019.1" *)
module div_gen_1(aclk, s_axis_divisor_tvalid, 
  s_axis_divisor_tdata, s_axis_dividend_tvalid, s_axis_dividend_tdata, 
  m_axis_dout_tvalid, m_axis_dout_tuser, m_axis_dout_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_divisor_tvalid,s_axis_divisor_tdata[39:0],s_axis_dividend_tvalid,s_axis_dividend_tdata[55:0],m_axis_dout_tvalid,m_axis_dout_tuser[0:0],m_axis_dout_tdata[95:0]" */;
  input aclk;
  input s_axis_divisor_tvalid;
  input [39:0]s_axis_divisor_tdata;
  input s_axis_dividend_tvalid;
  input [55:0]s_axis_dividend_tdata;
  output m_axis_dout_tvalid;
  output [0:0]m_axis_dout_tuser;
  output [95:0]m_axis_dout_tdata;
endmodule