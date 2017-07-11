create_clock -name clk_200M -period 5 [get_ports sys_clk_p]
#create_generated_clock -name clk_2M [get_pins spi_clk_reg/Q] -source [get_ports sys_clk_p] -divide_by 100