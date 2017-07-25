`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/06 15:19:19
// Design Name: 
// Module Name: gps
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module gps(
	input wire sys_clk_p,
    input wire sys_clk_n,
    input wire reset_n,
    input wire[3:0] key_in,
    output reg[3:0] LED,
    output wire tx,
    input wire rx,
    output wire sda_spi_cs_n,
    output wire sda_spi_clk,
    input wire tx_spi_miso,
    output wire rx_spi_mosi,
    input wire TP,
    output wire D_SEL,
    output wire SAFEBOOT_N,
    output wire GPS_reserve_done,
    input wire GPS_reserve_read,
    //debug
	output wire spi_cs_n_d,
	output wire spi_clk_d,
	output wire spi_miso_d,
	output wire spi_mosi_d
);
	wire clk_200M;
IBUFGDS #(
	.DIFF_TERM    ("FALSE"),
	.IBUF_LOW_PWR ("FALSE")
)
u_ibufg_sys_clk(
	.I  (sys_clk_p),		//差分时钟的正端输入，需要和顶层模块的端口直接连接
	.IB (sys_clk_n),		// 差分时钟的负端输入，需要和顶层模块的端口直接连接
	.O  (clk_200M)			//时钟缓冲输出
);
	
	wire[3:0] flag_key;
	wire urx_done, Data_done;
	
key_process key_process(
	.clk_200M(clk_200M),
	.reset_n(reset_n),
	.key_in(key_in),
	.flag_key(flag_key)
);

	wire[31:0] GPS_time;
	wire[23:0] GPS_date;
	wire[31:0] GPS_Latitude;
	wire[39:0] GPS_Longitude;
	wire[15:0] GPS_speed;
	wire[15:0] GPS_degree;

spi(
	.clk(clk_200M),
	.reset_n(reset_n),
	.flag_key(flag_key[0]),
	.LED(LED[0]),
	.spi_cs_n(sda_spi_cs_n),			///////////
	.spi_clk(sda_spi_clk),			//	SPI
	.spi_miso(tx_spi_miso),			//
	.spi_mosi(rx_spi_mosi),			///////////
	.GPS_time(GPS_time),		///////////
	.GPS_date(GPS_date),		//
	.GPS_Latitude(GPS_Latitude),	//
	.GPS_Longitude(GPS_Longitude),//  GPS_Data
	.GPS_speed(GPS_speed),	//
	.GPS_degree(GPS_degree),	////////////
	.GPS_reserve_done(GPS_reserve_done),
	.GPS_reserve_read(GPS_reserve_read)
);
	
	assign spi_cs_n_d = sda_spi_cs_n;
	assign spi_clk_d = sda_spi_clk;
	assign spi_miso_d = tx_spi_miso;
	assign spi_mosi_d = rx_spi_mosi;
	
	assign SAFEBOOT_N = 1'b1;
	assign D_SEL = 1'b0;
	
endmodule
