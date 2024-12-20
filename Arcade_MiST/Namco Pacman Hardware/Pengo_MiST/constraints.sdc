set sysclk ${topmodule}pll|altpll_component|auto_generated|pll1|clk[2]

create_generated_clock -name sdramclk -source ${topmodule}pll|altpll_component|auto_generated|pll1|clk[3] $RAM_CLK

# SDRAM delays
set_input_delay -clock [get_clocks sdramclk] -max 6.4 [get_ports $RAM_IN]
set_input_delay -clock [get_clocks sdramclk] -min 3.2 [get_ports $RAM_IN]

set_output_delay -clock [get_clocks sdramclk] -max 1.5 [get_ports $RAM_OUT]
set_output_delay -clock [get_clocks sdramclk] -min -0.8 [get_ports $RAM_OUT]

set_multicycle_path -from [get_clocks sdramclk] -to [get_clocks $sysclk] -setup 2


set_clock_groups -asynchronous -group spiclk -group [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[0]]
set_clock_groups -asynchronous -group spiclk -group [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[1]]
set_clock_groups -asynchronous -group spiclk -group [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[2]]

set_false_path -to ${VGA_OUT}

set_false_path -to ${FALSE_OUT}
set_false_path -from ${FALSE_IN}
set_false_path -from [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[2]] -to [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[0]]
