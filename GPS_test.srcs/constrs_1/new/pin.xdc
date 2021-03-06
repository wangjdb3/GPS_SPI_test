#####################  CLK  #########################
set_property PACKAGE_PIN R4 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_p]
set_property PACKAGE_PIN T4 [get_ports sys_clk_n]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_n]
set_property PACKAGE_PIN T6 [get_ports reset_n]
set_property IOSTANDARD LVCMOS15 [get_ports reset_n]

set_property PACKAGE_PIN B18 [get_ports {key_in[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_in[0]}]
set_property PACKAGE_PIN B17 [get_ports {key_in[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_in[1]}]
set_property PACKAGE_PIN A16 [get_ports {key_in[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_in[2]}]
set_property PACKAGE_PIN A15 [get_ports {key_in[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_in[3]}]

set_property PACKAGE_PIN C17 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN D17 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN V20 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN U20 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets key_IBUF[1]]
#####################  U-blox  #########################
set_property IOSTANDARD LVCMOS33 [get_ports TP]
set_property PACKAGE_PIN J20 [get_ports TP]
set_property IOSTANDARD LVCMOS33 [get_ports D_SEL]
set_property PACKAGE_PIN G15 [get_ports D_SEL]
set_property IOSTANDARD LVCMOS33 [get_ports SAFEBOOT_N]
set_property PACKAGE_PIN J19 [get_ports SAFEBOOT_N]

#####################  UART  #########################
set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN Y12 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]
set_property PACKAGE_PIN Y11 [get_ports tx]

#set_property IOSTANDARD LVCMOS33 [get_ports Grx]
#set_property PACKAGE_PIN H13 [get_ports Grx]
#set_property IOSTANDARD LVCMOS33 [get_ports Gtx]
#set_property PACKAGE_PIN J15 [get_ports Gtx]

#set_property IOSTANDARD LVCMOS33 [get_ports tx_s]
#set_property PACKAGE_PIN AB15 [get_ports tx_s]
#set_property IOSTANDARD LVCMOS33 [get_ports rx_s]
#set_property PACKAGE_PIN AA14 [get_ports rx_s]

#####################  SPI  #########################
set_property IOSTANDARD LVCMOS33 [get_ports sda_spi_cs_n]
set_property PACKAGE_PIN K13 [get_ports sda_spi_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports sda_spi_clk]
set_property PACKAGE_PIN J14 [get_ports sda_spi_clk]
set_property IOSTANDARD LVCMOS33 [get_ports tx_spi_miso]
set_property PACKAGE_PIN J15 [get_ports tx_spi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports rx_spi_mosi]
set_property PACKAGE_PIN H13 [get_ports rx_spi_mosi]

set_property IOSTANDARD LVCMOS33 [get_ports spi_cs_n_d]
set_property PACKAGE_PIN AB15 [get_ports spi_cs_n_d]
set_property IOSTANDARD LVCMOS33 [get_ports spi_clk_d]
set_property PACKAGE_PIN AA14 [get_ports spi_clk_d]
set_property IOSTANDARD LVCMOS33 [get_ports spi_miso_d]
set_property PACKAGE_PIN AB17 [get_ports spi_miso_d]
set_property IOSTANDARD LVCMOS33 [get_ports spi_mosi_d]
set_property PACKAGE_PIN AA16 [get_ports spi_mosi_d]


