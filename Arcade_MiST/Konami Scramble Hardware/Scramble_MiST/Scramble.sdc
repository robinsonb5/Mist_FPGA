## Generated SDC file "vectrex_MiST.out.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"

## DATE    "Sun Jun 24 12:53:00 2018"

##
## DEVICE  "EP3C25E144C8"
##

set_time_format -unit ns -decimal_places 3

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty

# tsu/th constraints

# tco constraints

# tpd constraints

#**************************************************************
# Time Information
#**************************************************************

set sysclk ${topmodule}pll|altpll_component|auto_generated|pll1|clk[0]
create_generated_clock -name sdramclk -source [get_pins ${topmodule}pll|altpll_component|auto_generated|pll1|clk[2]] [get_ports ${RAM_CLK}]

# SDRAM delays
set_input_delay -clock [get_clocks sdramclk] -max 6.4 [get_ports ${RAM_IN}]
set_input_delay -clock [get_clocks sdramclk] -min 3.2 [get_ports ${RAM_IN}]

set_output_delay -clock [get_clocks sdramclk] -max 1.5 [get_ports ${RAM_OUT}]
set_output_delay -clock [get_clocks sdramclk] -min -0.8 [get_ports ${RAM_OUT}]


#**************************************************************
# Set Clock Groups
#**************************************************************
set_clock_groups -asynchronous -group [get_clocks {spiclk}] -group [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[*]]

#**************************************************************
# Set False Path
#**************************************************************

set_false_path -to ${FALSE_OUT}
set_false_path -from ${FALSE_IN}


#**************************************************************
# Set Multicycle Path
#**************************************************************
set_multicycle_path -from [get_clocks sdramclk] -to [get_clocks $sysclk] -setup -end 2
set_multicycle_path -to {VGA_*[*]} -setup 2
set_multicycle_path -to {VGA_*[*]} -hold 1

#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

