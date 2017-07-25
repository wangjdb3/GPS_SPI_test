`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/20 16:30:54
// Design Name: 
// Module Name: spi
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


module spi(
	input wire clk,
	input wire reset_n,
	input wire flag_key,
	output wire LED,
	output wire spi_cs_n,			///////////
	output wire spi_clk,			//	SPI
	input wire spi_miso,			//
	output wire spi_mosi,			///////////
	output wire[31:0] GPS_time,		///////////
	output wire[23:0] GPS_date,		//
	output wire[31:0] GPS_Latitude,	//
	output wire[39:0] GPS_Longitude,//  GPS_Data
	output wire[15:0] GPS_speed,	//
	output wire[15:0] GPS_degree,	////////////
	output wire GPS_reserve_done,
	input wire GPS_reserve_read	
);
wire start_sign;
wire[7:0] srdata;
wire Data_done;
wire BCD_start, Bin_done;
wire[39:0] BCDtemp;
wire[33:0] Bintemp;

spi_controller spi_controller(
	.clk_200M(clk),
	.reset_n(reset_n),
	.Data_done(Data_done),
	.srdata(srdata),//8
	.flag_key(flag_key),
	.start_sign(start_sign),
	.LED(LED),
	.times(GPS_time),//32
	.date(GPS_date),//24
	.Latitude_reg(GPS_Latitude),//32
	.Longitude_reg(GPS_Longitude),//40
	.speed_reg(GPS_speed),//16
	.degree_reg(GPS_degree),//16
	.GPS_reserve_done(GPS_reserve_done),
	.GPS_reserve_read(GPS_reserve_read),
	.BCD_start(BCD_start),
	.BCDtemp(BCDtemp),//40
	.Bintemp(Bintemp),//34
	.Bin_done(Bin_done)
);

spi_interface spi_interface(
	.clk_200M(clk),
	.reset_n(reset_n),
	.spi_cs_n(spi_cs_n),
	.spi_clk(spi_clk),
	.spi_miso(spi_miso),
	.spi_mosi(spi_mosi),
	.srdata(srdata),//8
	.start_sign(start_sign),
	.Data_done(Data_done)
);

BCD_to_Bin BCD_to_Bin(
	.clk(clk),
	.reset_n(reset_n),
	.start(BCD_start),
	.BCD(BCDtemp),
	.Bin(Bintemp),
	.Done(Bin_done)
);
endmodule
