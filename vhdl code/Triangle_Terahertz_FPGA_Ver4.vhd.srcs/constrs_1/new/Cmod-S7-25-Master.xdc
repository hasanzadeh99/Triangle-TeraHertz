## Clock
set_property -dict { PACKAGE_PIN M9 IOSTANDARD LVCMOS33 } [get_ports clk_in]
create_clock -period 83.330 -name clk_in -waveform {0.000 41.660} -add [get_ports clk_in]

## Reset
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets reset_IBUF]
set_property -dict { PACKAGE_PIN D2 IOSTANDARD LVCMOS33 } [get_ports reset]

## Control Signals
set_property -dict { PACKAGE_PIN M4 IOSTANDARD LVCMOS33 } [get_ports pulse]
set_property -dict { PACKAGE_PIN M3 IOSTANDARD LVCMOS33 } [get_ports calculate_pulse]

## Input A[11:0]
set_property -dict { PACKAGE_PIN N2 IOSTANDARD LVCMOS33 } [get_ports {A[0]}]
set_property -dict { PACKAGE_PIN M2 IOSTANDARD LVCMOS33 } [get_ports {A[1]}]
set_property -dict { PACKAGE_PIN P3 IOSTANDARD LVCMOS33 } [get_ports {A[2]}]
set_property -dict { PACKAGE_PIN N3 IOSTANDARD LVCMOS33 } [get_ports {A[3]}]
set_property -dict { PACKAGE_PIN P1 IOSTANDARD LVCMOS33 } [get_ports {A[4]}]
set_property -dict { PACKAGE_PIN N1 IOSTANDARD LVCMOS33 } [get_ports {A[5]}]
set_property -dict { PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports {A[6]}]
set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports {A[7]}]
set_property -dict { PACKAGE_PIN N13 IOSTANDARD LVCMOS33 } [get_ports {A[8]}]
set_property -dict { PACKAGE_PIN N15 IOSTANDARD LVCMOS33 } [get_ports {A[9]}]
set_property -dict { PACKAGE_PIN N14 IOSTANDARD LVCMOS33 } [get_ports {A[10]}]
set_property -dict { PACKAGE_PIN M15 IOSTANDARD LVCMOS33 } [get_ports {A[11]}]

## Output dout_tdata[19:0]
set_property -dict { PACKAGE_PIN M14 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[0]}]
set_property -dict { PACKAGE_PIN L15 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[1]}]
set_property -dict { PACKAGE_PIN L14 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[2]}]
set_property -dict { PACKAGE_PIN K14 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[3]}]
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[4]}]
set_property -dict { PACKAGE_PIN L13 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[5]}]
set_property -dict { PACKAGE_PIN M13 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[6]}]
set_property -dict { PACKAGE_PIN J11 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[7]}]
set_property -dict { PACKAGE_PIN C5 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[8]}]
set_property -dict { PACKAGE_PIN A2 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[9]}]
set_property -dict { PACKAGE_PIN B2 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[10]}]
set_property -dict { PACKAGE_PIN B1 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[11]}]
set_property -dict { PACKAGE_PIN C1 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[12]}]
set_property -dict { PACKAGE_PIN B3 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[13]}]
set_property -dict { PACKAGE_PIN B4 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[14]}]
set_property -dict { PACKAGE_PIN A3 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[15]}]
set_property -dict { PACKAGE_PIN A4 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[16]}]
set_property -dict { PACKAGE_PIN J2 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[17]}]
set_property -dict { PACKAGE_PIN H2 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[18]}]
set_property -dict { PACKAGE_PIN H4 IOSTANDARD LVCMOS33 } [get_ports {dout_tdata[19]}]

## Data Ready Signal
set_property -dict { PACKAGE_PIN F3 IOSTANDARD LVCMOS33 } [get_ports data_ready]

## UART
set_property -dict { PACKAGE_PIN L12 IOSTANDARD LVCMOS33 } [get_ports uart_tx_pin]

## LEDs
set_property -dict { PACKAGE_PIN E2 IOSTANDARD LVCMOS33 } [get_ports led_0]
set_property -dict { PACKAGE_PIN K1 IOSTANDARD LVCMOS33 } [get_ports led_1]
set_property -dict { PACKAGE_PIN J1 IOSTANDARD LVCMOS33 } [get_ports led_2]
set_property -dict { PACKAGE_PIN E1 IOSTANDARD LVCMOS33 } [get_ports led_3]

## Configuration Settings
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]