# Clock signal (12 MHz)
set_property -dict {PACKAGE_PIN M9 IOSTANDARD LVCMOS33} [get_ports clk_in]
create_clock -period 83.330 -name clk_in -waveform {0.000 41.660} -add [get_ports clk_in]

# Reset button
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports reset]

# LED for status
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports led_0]

# UART TX pin
set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVCMOS33} [get_ports uart_tx]

# General configuration
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]