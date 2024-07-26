// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sun Apr  7 17:25:33 2024
// Host        : DESKTOP-IOGF5IK running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/Dropbox/Rodgel/Projects/1402/Triangle-TeraHertz/Triangle_Terahertz_FPGA_Ver2/Triangle_Terahertz_FPGA_Ver2.srcs/sources_1/ip/div_gen_0/div_gen_0_stub.v
// Design      : div_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s25csga225-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "div_gen_v5_1_15,Vivado 2019.1" *)
module div_gen_0(aclk, s_axis_divisor_tvalid, 
  s_axis_divisor_tready, s_axis_divisor_tdata, s_axis_dividend_tvalid, 
  s_axis_dividend_tready, s_axis_dividend_tdata, m_axis_dout_tvalid, m_axis_dout_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_divisor_tvalid,s_axis_divisor_tready,s_axis_divisor_tdata[55:0],s_axis_dividend_tvalid,s_axis_dividend_tready,s_axis_dividend_tdata[63:0],m_axis_dout_tvalid,m_axis_dout_tdata[71:0]" */;
  input aclk;
  input s_axis_divisor_tvalid;
  output s_axis_divisor_tready;
  input [55:0]s_axis_divisor_tdata;
  input s_axis_dividend_tvalid;
  output s_axis_dividend_tready;
  input [63:0]s_axis_dividend_tdata;
  output m_axis_dout_tvalid;
  output [71:0]m_axis_dout_tdata;
endmodule
