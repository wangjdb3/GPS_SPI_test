`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/16 13:26:13
// Design Name: 
// Module Name: spi_controller
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


module spi_controller(
	input wire clk_200M,
	input wire reset_n,
	input wire Data_done,
	input wire[7:0] srdata,
	input wire flag_key,
	output reg start_sign,
	output reg LED,
	output reg[31:0] times,
	output reg[23:0] date,
	output reg[31:0] Latitude_reg,
	output reg[39:0] Longitude_reg,
	output reg[15:0] speed_reg,
	output reg[15:0] degree_reg,
	output reg GPS_reserve_done,
	input wire GPS_reserve_read,
	output reg BCD_start,
	output reg[39:0] BCDtemp,
	input wire[33:0] Bintemp,
	input wire Bin_done
);
	parameter Start = 14'h0001, UTCtime = 14'h0002, Data_status = 14'h0004, Latitude = 14'h0008, NorS = 14'h0010;
	parameter Longitude = 14'h0020, EorW = 14'h0040, Speed = 14'h0080, Degree = 14'h0100, UTCdate = 14'h0200;
	parameter MVDegree = 14'h0400, MVEorW = 14'h0800, Mode = 14'h1000, Checksum = 14'h2000;
	
	always @(posedge clk_200M or negedge reset_n)
		if(!reset_n)
			begin
			LED <= 1'b1;
			start_sign <= 1'b0;
			end
		else
			begin
			if ( flag_key )
				begin
				LED <= ~LED;
				start_sign <= ~start_sign;
				end
			end
	
	reg reserve_done;
	reg[13:0] states;
	reg[11:0] i;
			
	always @(posedge clk_200M or negedge reset_n)
		if(!reset_n)
			begin
			reserve_done <= 1'b0;
			states <= Start;
			times <= 32'd0;
			date <= 24'd0;
			BCDtemp <= 40'd0;
			Latitude_reg <= 32'd0;
			Longitude_reg <= 40'd0;
			speed_reg <= 16'd0;
			degree_reg <= 16'd0;
			BCD_start <= 1'b1;
			i <= 12'h001;
			end
		else if (Data_done)
			case (states)
			Start:
				case(i)
				12'h001:
					if(srdata == "$")
						i <= i << 1;
				12'h002:
					if(srdata == "G")
						i <= i << 1;
					else
						i <= 12'h001;
				12'h004:
					if(srdata == "P")
						i <= i << 1;
					else
						i <= 12'h001;
				12'h008:
					if(srdata == "R")
						i <= i << 1;
					else
						i <= 12'h001;
				12'h010:
					if(srdata == "M")
						i <= i << 1;
					else
						i <= 12'h001;
				12'h020:
					if(srdata == "C")
						i <= i << 1;
					else
						i <= 12'h001;
				12'h040:
					if(srdata == ",")
						begin i <= 12'h001; states <= UTCtime; end
					else
						i <= 12'h001;
				endcase
			UTCtime:
				case (i)
				12'h001:
					if(srdata == ",")
						begin i <= 12'h001; states <= Start; end
					else
						begin times[31:28] <= srdata[3:0]; i <= i << 1; end
				12'h002:
					begin times[27:24] <= srdata[3:0]; i <= i << 1; end
				12'h004:
					begin times[23:20] <= srdata[3:0]; i <= i << 1; end
				12'h008:
					begin times[19:16] <= srdata[3:0]; i <= i << 1; end
				12'h010:
					begin times[15:12] <= srdata[3:0]; i <= i << 1; end
				12'h020:
					begin times[11:8] <= srdata[3:0]; i <= i << 1; end
				12'h040:
					if(srdata == ".")
						i <= i << 1;
					else
						begin states <= Start; i <= 12'h001; end
				12'h080:
					begin times[7:4] <= srdata[3:0]; i <= i << 1; end
				12'h100:
					begin times[3:0] <= srdata[3:0]; i <= i << 1; end
				12'h200:
					if(srdata == ",")
						begin i <= 12'h001; states <= Data_status; end
					else
						begin i <= 12'h001; states <= Start; end
				endcase
			Data_status:
				case (i)
				12'h001:
					if(srdata == "A")
						i <= i << 1;
					else
						begin i <= 12'h001; states <= Start; end
				12'h002:
					begin i <= 12'h001; states <= Latitude; end
				endcase
			Latitude:
				case (i)
				12'h001:
					if(srdata == ",")
						begin i <= 12'h001; states <= Start; end
					else
						begin BCDtemp[39:36] <= 4'b0000; BCDtemp[35:32] <= srdata[3:0]; i <= i << 1; end
				12'h002:
					begin BCDtemp[31:28] <= srdata[3:0]; i <= i << 1; end
				12'h004:
					begin BCDtemp[27:24] <= srdata[3:0]; i <= i << 1; end
				12'h008:
					begin BCDtemp[23:20] <= srdata[3:0]; i <= i << 1; end
				12'h010:
					i <= i << 1;
				12'h020:
					begin BCDtemp[19:16] <= srdata[3:0]; i <= i << 1; end
				12'h040:
					begin BCDtemp[15:12] <= srdata[3:0]; i <= i << 1; end
				12'h080:
					begin BCDtemp[11:8] <= srdata[3:0]; i <= i << 1; end
				12'h100:
					begin BCDtemp[7:4] <= srdata[3:0]; i <= i << 1; end
				12'h200:
					begin BCDtemp[3:0] <= srdata[3:0]; BCD_start <= 1'b1; i <= i << 1; end
				12'h400:
					begin Latitude_reg <= Bintemp[31:0]; BCDtemp <= 40'd0; BCD_start <= 1'b0; i <= 12'h001; states <= NorS; end
				endcase
			NorS:
				case (i)
				12'h001:
					case(srdata)
					"N":
						begin Latitude_reg[31] <= 1'b1; i <= i << 1; end
					"S":
						begin Latitude_reg[31] <= 1'b0; i <= i << 1; end
					default:
						begin i <= 12'h001; states <= Start; end
					endcase
				12'h002:
					begin i <= 12'h001; states <= Longitude; end
				endcase
			Longitude:
				case (i)
				12'h001:
					if(srdata == ",")
						begin i <= 12'h001; states <= Start; end
					else
						begin BCDtemp[39:36] <= srdata[3:0]; i <= i << 1; end
				12'h002:
					begin BCDtemp[35:32] <= srdata[3:0]; i <= i << 1; end
				12'h004:
					begin BCDtemp[31:28] <= srdata[3:0]; i <= i << 1; end
				12'h008:
					begin BCDtemp[27:24] <= srdata[3:0]; i <= i << 1; end
				12'h010:
					begin BCDtemp[23:20] <= srdata[3:0]; i <= i << 1; end
				12'h020:
					i <= i << 1;
				12'h040:
					begin BCDtemp[19:16] <= srdata[3:0]; i <= i << 1; end
				12'h080:
					begin BCDtemp[15:12] <= srdata[3:0]; i <= i << 1; end
				12'h100:
					begin BCDtemp[11:8] <= srdata[3:0]; i <= i << 1; end
				12'h200:
					begin BCDtemp[7:4] <= srdata[3:0]; i <= i << 1; end
				12'h400:
					begin BCDtemp[3:0] <= srdata[3:0]; BCD_start <= 1'b1; i <= i << 1; end
				12'h800:
					begin Longitude_reg[33:0] <= Bintemp; BCDtemp <= 40'd0; BCD_start <= 1'b0; i <= 12'h001; states <= EorW; end
				endcase
			EorW:
				case (i)
				12'h001:
					case(srdata)
					"E":
						begin Longitude_reg[39] <= 1'b1; i <= i << 1; end
					"W":
						begin Longitude_reg[39] <= 1'b0; i <= i << 1; end
					default:
						begin i <= 12'h001; states <= Start; end
					endcase
				12'h002:
					begin i <= 12'h001; states <= Speed; end
				endcase
			Speed:
				case(i)
				12'h001:
					if(srdata == ",")
						begin i <= 12'h001; states <= Degree; end
					else
						begin BCDtemp[15:12] <= srdata[3:0]; i <= i << 1; end
				12'h002:
					if(srdata == ".")
						begin speed_reg[15:14] <= 2'b01; i <= i << 1; end
					else
						begin BCDtemp[11:8] <= srdata[3:0]; i <= i << 1; end
				12'h004:
					if(srdata == ".")
						begin speed_reg[15:14] <= 2'b10; i <= i << 1; end
					else if(speed_reg[15:14] != 2'b00)
						begin BCDtemp[11:8] <= srdata[3:0]; i <= i << 1; end
					else
						begin BCDtemp[7:4] <= srdata[3:0]; i <= i << 1; end
				12'h008:
					if(srdata == ".")
						begin speed_reg[15:14] <= 2'b11; i <= i << 1; end
					else
						begin BCDtemp[7:4] <= srdata[3:0]; i <= i << 1; end
				12'h010:
					begin BCDtemp[3:0] <= srdata[3:0]; BCD_start <= 1'b1; i <= i << 1; end
				12'h020:
					begin speed_reg[13:0] <= Bintemp[13:0]; BCDtemp <= 40'd0; BCD_start <= 1'b0; i <= 12'h001; states <= Degree; end
				endcase
			Degree:
				case(i)
				12'h001:
					if(srdata == ",")
						begin i <= 12'h001; states <= UTCdate; end
					else
						begin BCDtemp[15:12] <= srdata[3:0]; i <= i << 1; end
				12'h002:
					if(srdata == ".")
						begin degree_reg[15:14] <= 2'b01; i <= i << 1; end
					else
						begin BCDtemp[11:8] <= srdata[3:0]; i <= i << 1; end
				12'h004:
					if(srdata == ".")
						begin degree_reg[15:14] <= 2'b10; i <= i << 1; end
					else if(degree_reg[15:14] != 2'b00)
						begin BCDtemp[11:8] <= srdata[3:0]; i <= i << 1; end
					else
						begin BCDtemp[7:4] <= srdata[3:0]; i <= i << 1; end
				12'h008:
					if(srdata == ".")
						begin degree_reg[15:14] <= 2'b11; i <= i << 1; end
					else
						begin BCDtemp[7:4] <= srdata[3:0]; i <= i << 1; end
				12'h010:
					begin BCDtemp[3:0] <= srdata[3:0]; BCD_start <= 1'b1; i <= i << 1; end
				12'h020:
					begin degree_reg[13:0] <= Bintemp[13:0]; BCDtemp <= 40'd0; BCD_start <= 1'b0; i <= 12'h001; states <= UTCdate; end
				endcase
			UTCdate:
				case(i)
				12'h001:
					if(srdata == ",")
						begin i <= 12'h001; states <= MVDegree; end
					else
						begin date[23:20] <= srdata[3:0]; i <= i << 1; end
				12'h002:
					begin date[19:16] <= srdata[3:0]; i <= i << 1; end
				12'h004:
					begin date[15:12] <= srdata[3:0]; i <= i << 1; end
				12'h008:
					begin date[11:8] <= srdata[3:0]; i <= i << 1; end
				12'h010:
					begin date[7:4] <= srdata[3:0]; i <= i << 1; end
				12'h020:
					begin date[3:0] <= srdata[3:0]; i <= i << 1; end
				12'h040:
					begin i <= 12'h001; states <= MVDegree; reserve_done <= 1'b1; end
				endcase
			MVDegree:
				begin
				reserve_done <= 1'b0;
				if(srdata == ",")
					begin i <= 12'h001; states <= MVEorW; end
				end
			MVEorW:
				if(srdata == ",")
					begin i <= 12'h001; states <= Mode; end
			Mode:
				begin i <= 12'h001; states <= Mode; end
			Checksum:
				case(i)
				12'h001:
					i <= i << 1; 
				12'h020:
					i <= i << 1; 
				12'h040:
					begin i <= 12'h001; states <= Start; end
				endcase
			endcase
			
	reg[1:0] j;
	always @( posedge clk_200M or negedge reset_n)
		if(!reset_n)
			begin
			GPS_reserve_done <= 1'b0;
			j <= 2'd0;
			end
		else
			case (j)
			2'd0:
				if(reserve_done)
					begin GPS_reserve_done <= 1'b1; j <= 2'd1; end
			2'd1:
				if(GPS_reserve_read && !reserve_done)
					begin GPS_reserve_done <= 1'b0; j <= 2'd0; end
				else if(GPS_reserve_read && reserve_done)
					begin GPS_reserve_done <= 1'b0; j <= 2'd2; end
			2'd2:
				if(!reserve_done)
					begin j <= 2'd0; end
			default:
				begin j <= 2'd0; end
			endcase
			
endmodule
