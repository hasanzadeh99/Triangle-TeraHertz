## This file is a general .xdc for the Cmod S7-25 Rev. B
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# 12 MHz System Clock
set_property -dict {PACKAGE_PIN M9 IOSTANDARD LVCMOS33} [get_ports clk_in]
#create_clock -period 83.330 -name sys_clk_pin -waveform {0.000 41.660} -add [get_ports clk_in]
create_clock -period 83.330 -name clk_in -waveform {0.000 41.660} -add [get_ports clk_in]



set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets reset_IBUF]


## Push Buttons
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports reset]
#set_property -dict { PACKAGE_PIN D1    IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]; #IO_L6N_T0_VREF_34 Sch=btn[1]

## RGB LEDs
#set_property -dict { PACKAGE_PIN F1    IOSTANDARD LVCMOS33 } [get_ports { led0_b }]; #IO_L10N_T1_34 Sch=led0_b
#set_property -dict { PACKAGE_PIN D3    IOSTANDARD LVCMOS33 } [get_ports { led0_g }]; #IO_L9N_T1_DQS_34 Sch=led0_g
#set_property -dict { PACKAGE_PIN F2    IOSTANDARD LVCMOS33 } [get_ports { led0_r }]; #IO_L10P_T1_34 Sch=led0_r

## 4 LEDs
#set_property -dict { PACKAGE_PIN E2    IOSTANDARD LVCMOS33 } [get_ports { led[0] }]; #IO_L8P_T1_34 Sch=led[1]
#set_property -dict { PACKAGE_PIN K1    IOSTANDARD LVCMOS33 } [get_ports { led[1] }]; #IO_L16P_T2_34 Sch=led[2]
#set_property -dict { PACKAGE_PIN J1    IOSTANDARD LVCMOS33 } [get_ports { led[2] }]; #IO_L16N_T2_34 Sch=led[3]
#set_property -dict { PACKAGE_PIN E1    IOSTANDARD LVCMOS33 } [get_ports { led[3] }]; #IO_L8N_T1_34 Sch=led[4]


#set_property -dict { PACKAGE_PIN E2    IOSTANDARD LVCMOS33 } [get_ports { dout_tvalid }]; #IO_L8P_T1_34 Sch=led[1]
#set_property -dict { PACKAGE_PIN K1    IOSTANDARD LVCMOS33 } [get_ports { dout_tvalid }]; #IO_L16P_T2_34 Sch=led[2]
#set_property -dict { PACKAGE_PIN J1    IOSTANDARD LVCMOS33 } [get_ports { dout_tvalid }]; #IO_L16N_T2_34 Sch=led[3]
#set_property -dict { PACKAGE_PIN E1    IOSTANDARD LVCMOS33 } [get_ports { dout_tvalid }]; #IO_L8N_T1_34 Sch=led[4]


set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports led_0]
set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVCMOS33} [get_ports led_1]
set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS33} [get_ports led_2]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports led_3]


## Pmod Header JA
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[17]}]
#IO_L14P_T2_SRCC_34 Sch=ja[1]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[18]}]
#IO_L14N_T2_SRCC_34 Sch=ja[2]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[19]}]
#IO_L13P_T2_MRCC_34 Sch=ja[3]
set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS33} [get_ports data_ready]
#IO_L11N_T1_SRCC_34 Sch=ja[4]
#set_property -dict { PACKAGE_PIN H3    IOSTANDARD LVCMOS33 } [get_ports { ja[4] }]; #IO_L13N_T2_MRCC_34 Sch=ja[7]
#set_property -dict { PACKAGE_PIN H1    IOSTANDARD LVCMOS33 } [get_ports { ja[5] }]; #IO_L12P_T1_MRCC_34 Sch=ja[8]
#set_property -dict { PACKAGE_PIN G1    IOSTANDARD LVCMOS33 } [get_ports { ja[6] }]; #IO_L12N_T1_MRCC_34 Sch=ja[9]
#set_property -dict { PACKAGE_PIN F4    IOSTANDARD LVCMOS33 } [get_ports { ja[7] }]; #IO_L11P_T1_SRCC_34 Sch=ja[10]

## USB UART
## Note: Port names are from the perspoctive of the FPGA.
set_property -dict { PACKAGE_PIN L12   IOSTANDARD LVCMOS33 } [get_ports { uart_tx }]; #IO_L6N_T0_D08_VREF_14 Sch=uart_rxd_out
#set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { uart_rx }]; #IO_L5N_T0_D07_14 Sch=uart_txd_in

## Analog Inputs on PIO Pins 32 and 33
#set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVCMOS33 } [get_ports { vaux5_p }]; #IO_L12P_T1_MRCC_AD5P_15 Sch=ain_p[32]
#set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVCMOS33 } [get_ports { vaux5_n }]; #IO_L12N_T1_MRCC_AD5N_15 Sch=ain_n[32]
#set_property -dict { PACKAGE_PIN A11   IOSTANDARD LVCMOS33 } [get_ports { vaux12_p }]; #IO_L11P_T1_SRCC_AD12P_15 Sch=ain_p[33]
#set_property -dict { PACKAGE_PIN A12   IOSTANDARD LVCMOS33 } [get_ports { vaux12_n }]; #IO_L11N_T1_SRCC_AD12N_15 Sch=ain_n[33]

## Dedicated Digital I/O on the PIO Headers
#set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports ?]
set_property -dict {PACKAGE_PIN M4 IOSTANDARD LVCMOS33} [get_ports pulse]
#2
set_property -dict {PACKAGE_PIN M3 IOSTANDARD LVCMOS33} [get_ports calculate_pulse]
#3
set_property -dict {PACKAGE_PIN N2 IOSTANDARD LVCMOS33} [get_ports {A[0]}]
#4
set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports {A[1]}]
#5
set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVCMOS33} [get_ports {A[2]}]
#6
set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS33} [get_ports {A[3]}]
#7
set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports {A[4]}]
#8
set_property -dict {PACKAGE_PIN N1 IOSTANDARD LVCMOS33} [get_ports {A[5]}]
#9
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {A[6]}]
#16
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports {A[7]}]
#17
set_property -dict {PACKAGE_PIN N13 IOSTANDARD LVCMOS33} [get_ports {A[8]}]
#18
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS33} [get_ports {A[9]}]
#19
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports {A[10]}]
#20
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports {A[11]}]
#21
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[0]}]
#//22
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[1]}]
#//23
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[2]}]
#//26
set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[3]}]
#//27
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[4]}]
#//28
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[5]}]
#//29
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[6]}]
#//30
set_property -dict {PACKAGE_PIN J11 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[7]}]
#//31
set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[8]}]
#//40
set_property -dict {PACKAGE_PIN A2 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[9]}]
#//41
set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[10]}]
#//42
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[11]}]
#//43
set_property -dict {PACKAGE_PIN C1 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[12]}]
#//44
set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[13]}]
#//45
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[14]}]
#//46
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[15]}]
#//47
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {dout_tdata[16]}]
#//48

## Quad SPI Flash
## Note: QSPI clock can only be accessed through the STARTUPE2 primitive
#set_property -dict { PACKAGE_PIN L11   IOSTANDARD LVCMOS33 } [get_ports { qspi_cs }]; #IO_L6P_T0_FCS_B_14 Sch=qspi_cs
#set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[0] }]; #IO_L1P_T0_D00_MOSI_14 Sch=qspi_dq[0]
#set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[1] }]; #IO_L1N_T0_D01_DIN_14 Sch=qspi_dq[1]
#set_property -dict { PACKAGE_PIN J12   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[2] }]; #IO_L2P_T0_D02_14 Sch=qspi_dq[2]
#set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[3] }]; #IO_L2N_T0_D03_14 Sch=qspi_dq[3]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]


#set_property PACKAGE_PIN E2 [get_ports LED]
#set_property IOSTANDARD LVCMOS33 [get_ports LED]

#create_clock -period 83.330 -name Clock -waveform {0.000 41.665} [get_ports clk]

# Set properties for the clk_in port
#set_property -dict {PACKAGE_PIN M9 IOSTANDARD LVCMOS33} [get_ports clk_in]

# Define the clock with a 100 ns period (10 MHz) and 50% duty cycle
#create_clock -add -name sys_clk_pin -period 16.67 -waveform {0 8.335} [get_ports { clk_in }];


#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets clk_out]


#set_property MARK_DEBUG false [get_nets {read_index[9]}]

#create_debug_core u_ila_0 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
#set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
#set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
#set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
#set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
#set_property port_width 1 [get_debug_ports u_ila_0/clk]
#connect_debug_port u_ila_0/clk [get_nets [list clock_gen/inst/clk_out]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
#set_property port_width 12 [get_debug_ports u_ila_0/probe0]
#connect_debug_port u_ila_0/probe0 [get_nets [list {p_1_in[0]} {p_1_in[1]} {p_1_in[2]} {p_1_in[3]} {p_1_in[4]} {p_1_in[5]} {p_1_in[6]} {p_1_in[7]} {p_1_in[8]} {p_1_in[9]} {p_1_in[10]} {p_1_in[11]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
#set_property port_width 11 [get_debug_ports u_ila_0/probe1]
#connect_debug_port u_ila_0/probe1 [get_nets [list {read_index[0]} {read_index[1]} {read_index[2]} {read_index[3]} {read_index[4]} {read_index[5]} {read_index[6]} {read_index[7]} {read_index[8]} {read_index[9]} {read_index[10]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
#set_property port_width 20 [get_debug_ports u_ila_0/probe2]
#connect_debug_port u_ila_0/probe2 [get_nets [list {dout_tdata_OBUF[0]} {dout_tdata_OBUF[1]} {dout_tdata_OBUF[2]} {dout_tdata_OBUF[3]} {dout_tdata_OBUF[4]} {dout_tdata_OBUF[5]} {dout_tdata_OBUF[6]} {dout_tdata_OBUF[7]} {dout_tdata_OBUF[8]} {dout_tdata_OBUF[9]} {dout_tdata_OBUF[10]} {dout_tdata_OBUF[11]} {dout_tdata_OBUF[12]} {dout_tdata_OBUF[13]} {dout_tdata_OBUF[14]} {dout_tdata_OBUF[15]} {dout_tdata_OBUF[16]} {dout_tdata_OBUF[17]} {dout_tdata_OBUF[18]} {dout_tdata_OBUF[19]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
#set_property port_width 11 [get_debug_ports u_ila_0/probe3]
#connect_debug_port u_ila_0/probe3 [get_nets [list {pulse_counter[0]} {pulse_counter[1]} {pulse_counter[2]} {pulse_counter[3]} {pulse_counter[4]} {pulse_counter[5]} {pulse_counter[6]} {pulse_counter[7]} {pulse_counter[8]} {pulse_counter[9]} {pulse_counter[10]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
#set_property port_width 12 [get_debug_ports u_ila_0/probe4]
#connect_debug_port u_ila_0/probe4 [get_nets [list {last_A[0]} {last_A[1]} {last_A[2]} {last_A[3]} {last_A[4]} {last_A[5]} {last_A[6]} {last_A[7]} {last_A[8]} {last_A[9]} {last_A[10]} {last_A[11]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
#set_property port_width 1 [get_debug_ports u_ila_0/probe5]
#connect_debug_port u_ila_0/probe5 [get_nets [list capture_done]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
#set_property port_width 1 [get_debug_ports u_ila_0/probe6]
#connect_debug_port u_ila_0/probe6 [get_nets [list data_ready_i]]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets clk_out]
