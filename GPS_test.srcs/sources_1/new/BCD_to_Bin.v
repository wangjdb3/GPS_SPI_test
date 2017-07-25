`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/17 13:59:41
// Design Name: 
// Module Name: BCD_to_Bin
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


module BCD_to_Bin(
	input wire clk,
	input wire reset_n,
	input wire start,
	input wire [39:0] BCD,
	output reg [33:0] Bin,
	output reg Done
);
	reg [33:0] Bintemp;
	reg [39:0] BCDtemp;
	wire [39:0] BCDtemp2;
	reg [5:0] cnt;
	always @(posedge clk or negedge reset_n)
		if(!reset_n)
			begin
			Bintemp <= 30'd0;
			BCDtemp <= 32'd0;
			cnt <= 6'd0;
			Bin <= 32'd0;
			Done <= 1'b0;
			end
		else
			case(cnt)
			6'd0:
				begin
				Done <= 1'b0;
				if(start)
					begin BCDtemp <= BCD; Bintemp <= 30'd0; cnt <= cnt + 1'b1; end
				end
			6'd1:
				begin BCDtemp <= BCDtemp >> 1; Bintemp <= {BCDtemp[0], Bintemp[33:1]}; cnt <= cnt + 1'b1; end
			6'd35:
				begin Bin <= Bintemp; cnt <= 6'd0; Done <= 1'b1; end
			default:
				begin BCDtemp <= BCDtemp2 >> 1; Bintemp <= {BCDtemp2[0], Bintemp[33:1]}; cnt <= cnt + 1'b1; end
			endcase
	
	assign BCDtemp2[3:0] = BCDtemp[3:0] > 4'd7 ? BCDtemp[3:0] - 4'd3 : BCDtemp[3:0];
	assign BCDtemp2[7:4] = BCDtemp[7:4] > 4'd7 ? BCDtemp[7:4] - 4'd3 : BCDtemp[7:4];
	assign BCDtemp2[11:8] = BCDtemp[11:8] > 4'd7 ? BCDtemp[11:8] - 4'd3 : BCDtemp[11:8];
	assign BCDtemp2[15:12] = BCDtemp[15:12] > 4'd7 ? BCDtemp[15:12] - 4'd3 : BCDtemp[15:12];
	assign BCDtemp2[19:16] = BCDtemp[19:16] > 4'd7 ? BCDtemp[19:16] - 4'd3 : BCDtemp[19:16];
	assign BCDtemp2[23:20] = BCDtemp[23:20] > 4'd7 ? BCDtemp[23:20] - 4'd3 : BCDtemp[23:20];
	assign BCDtemp2[27:24] = BCDtemp[27:24] > 4'd7 ? BCDtemp[27:24] - 4'd3 : BCDtemp[27:24];
	assign BCDtemp2[31:28] = BCDtemp[31:28] > 4'd7 ? BCDtemp[31:28] - 4'd3 : BCDtemp[31:28];
	assign BCDtemp2[35:32] = BCDtemp[35:32] > 4'd7 ? BCDtemp[35:32] - 4'd3 : BCDtemp[35:32];
	assign BCDtemp2[39:36] = BCDtemp[39:36] > 4'd7 ? BCDtemp[39:36] - 4'd3 : BCDtemp[39:36];
endmodule
