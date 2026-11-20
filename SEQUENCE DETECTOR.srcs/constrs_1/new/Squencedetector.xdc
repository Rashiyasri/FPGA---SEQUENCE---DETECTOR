## Nexys A7-100T clock: 100 MHz
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -name sys_clk -period 10.000 -waveform {0 5} [get_ports clk]

## Reset: center push button (BTNC)

set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports reset]

## Load pattern: up push button (BTNU)
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports lo

ad_pattern]

## Serial input: switch SW4
set_property -dict { PACKAGE_PIN R17 IOSTANDARD LVCMOS33 } [get_ports serial_in]

## Pattern input: switches SW0-SW3
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports {pattern_in[0]}]
set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 } [get_ports {pattern_in[1]}]
set_property -dict { PACKAGE_PIN M13 IOSTANDARD LVCMOS33 } [get_ports {pattern_in[2]}]
set_property -dict { PACKAGE_PIN R15 IOSTANDARD LVCMOS33 } [get_ports {pattern_in[3]}]

## Detection output: LED0
set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports detected]
