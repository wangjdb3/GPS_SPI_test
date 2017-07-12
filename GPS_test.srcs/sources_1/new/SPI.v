`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/05 22:23:52
// Design Name: 
// Module Name: SPI
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


module SPI(
	input wire clk_200M,
	input wire reset_n,
	output reg spi_cs_n,
	output reg spi_clk,
	input wire spi_miso,
	output reg spi_mosi,
	input wire TP,
	input wire[7:0] stdata,
	output reg[7:0] srdata,
	input wire start_sign,
	input wire urx_done,
	input wire fifo_ur_empty,
	output reg fifo_ur_re,
	output reg fifo_ut_we,
	output reg Data_done
);
	parameter Nop = 12'b000000000001, Start = 12'b000000000010, Delay = 12'b000000000100, Stop = 12'b000000001000;
	parameter C1 = 12'b000000010000, C2 = 12'b000000100000, C3 = 12'b000001000000, C4 = 12'b000010000000;
	parameter C5 = 12'b000100000000, C6 = 12'b001000000000, C7 = 12'b010000000000, C8 = 12'b100000000000;
	reg[11:0] counter;
	reg[11:0] state;
	reg[17:0] counter2;
	reg[7:0] stdata_tmp;
	reg[7:0] srdata_tmp;
	
	reg send_data_sign, send_data_sign2;
	
	always @( posedge clk_200M or negedge reset_n )
		if(!reset_n)
			send_data_sign <= 1'b0;
		else if(urx_done)
			send_data_sign <= 1'b1;
		else if(fifo_ur_empty)
			send_data_sign <= 1'b0;
		else
			send_data_sign <= send_data_sign;
			
	
	always @( posedge clk_200M or negedge reset_n )
		if(!reset_n)
			begin
			state <= Nop;
			spi_cs_n <= 1'b1;
			spi_clk <= 1'b0;
			spi_mosi <= 1'b0;
			stdata_tmp <= 8'hff;
			srdata_tmp <= 8'h00;
			send_data_sign2 <= 1'b0;
			counter <= 7'd0;
			counter2 <= 18'd0;
			//FF_counter <= 3'd0;
			fifo_ur_re <= 1'b0;
			fifo_ut_we <= 1'b0;
			Data_done <= 1'b0;
			end
		else
			case (state)
			Nop:
				if (start_sign)
					begin spi_cs_n <= 1'b0; state <= Start; spi_clk <= 1'b0; end
			Start:
				case (counter2)
				18'd0:
					begin
					if(send_data_sign)
						fifo_ur_re <= 1'b1;
					counter2 <= counter2 + 18'd1;
					end
				18'd1:
					begin 
					if(fifo_ur_re)
						begin fifo_ur_re <= 1'b0; send_data_sign2 <= 1'b1; end
					counter2 <= counter2 + 18'd1;
					end
				18'd2:
					begin
					if(send_data_sign2)
						begin stdata_tmp <= stdata; send_data_sign2 <= 1'b0; end
					else
						stdata_tmp <= 8'hff;
					counter2 <= counter2 + 18'd1;
					end
				18'd2949:
					begin spi_mosi <= stdata_tmp[7]; counter2 <= counter2 + 18'd1; end
				18'd2999:
					begin state <= C1; spi_clk <= 1'b1; counter2 <= 18'd0; end
				default:
					begin counter2 <= counter2 + 12'd1; end
				endcase
			C1:
				case(counter)
				7'd24:
					begin srdata_tmp[7] <= spi_miso; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd49:
					begin spi_clk <= 1'b0; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd59:
					begin spi_mosi <= stdata_tmp[6]; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd99:
					begin state <= C2; spi_clk <= 1'b1; counter <= 7'd0; counter2 <= counter2 + 18'd1; end
				default:
					begin counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				endcase
			C2:
				case(counter)
				7'd24:
					begin srdata_tmp[6] <= spi_miso; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd49:
					begin spi_clk <= 1'b0; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd59:
					begin spi_mosi <= stdata_tmp[5]; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd99:
					begin state <= C3; spi_clk <= 1'b1; counter <= 7'd0; counter2 <= counter2 + 18'd1; end
				default:
					begin counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				endcase
			C3:
				case(counter)
				7'd24:
					begin srdata_tmp[5] <= spi_miso; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd49:
					begin spi_clk <= 1'b0; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd59:
					begin spi_mosi <= stdata_tmp[4]; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd99:
					begin state <= C4; spi_clk <= 1'b1; counter <= 7'd0; counter2 <= counter2 + 18'd1; end
				default:
					begin counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				endcase
			C4:
				case(counter)
				7'd24:
					begin srdata_tmp[4] <= spi_miso; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd49:
					begin spi_clk <= 1'b0; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd59:
					begin spi_mosi <= stdata_tmp[3]; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1;end
				7'd99:
					begin state <= C5; spi_clk <= 1'b1; counter <= 7'd0; counter2 <= counter2 + 18'd1; end
				default:
					begin counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				endcase
			C5:
				case(counter)
				7'd24:
					begin srdata_tmp[3] <= spi_miso; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd49:
					begin spi_clk <= 1'b0; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd59:
					begin spi_mosi <= stdata_tmp[2]; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd99:
					begin state <= C6; spi_clk <= 1'b1; counter <= 7'd0; counter2 <= counter2 + 18'd1; end
				default:
					begin counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				endcase
			C6:
				case(counter)
				7'd24:
					begin srdata_tmp[2] <= spi_miso; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd49:
					begin spi_clk <= 1'b0; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd59:
					begin spi_mosi <= stdata_tmp[1]; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd99:
					begin state <= C7; spi_clk <= 1'b1; counter <= 7'd0; counter2 <= counter2 + 18'd1; end
				default:
					begin counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				endcase
			C7:
				case(counter)
				7'd24:
					begin srdata_tmp[1] <= spi_miso; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd49:
					begin spi_clk <= 1'b0; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd59:
					begin spi_mosi <= stdata_tmp[0]; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd99:
					begin state <= C8; spi_clk <= 1'b1; counter <= 7'd0; counter2 <= counter2 + 18'd1; end
				default:
					begin counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				endcase
			C8:
				case(counter)
				7'd24:
					begin srdata_tmp[0] <= spi_miso; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd25:
					begin
					if(srdata_tmp != 8'hff)
						begin fifo_ut_we <= 1'b1; srdata <=srdata_tmp; end
					counter <= counter + 7'd1;
					counter2 <= counter2 + 18'd1;
					end
				7'd26:
					begin fifo_ut_we <= 1'b0; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1;end
				7'd49:
					begin spi_clk <= 1'b0; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; Data_done <= 1'b1; end
				7'd50:
					begin Data_done <= 1'b0; counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				7'd59:
					begin
					if(counter2 > 18'd1508)
						spi_mosi <= stdata_tmp[7];
					counter <= counter + 7'd1;
					counter2 <= counter2 + 18'd1;
					end
				7'd99:
					begin
					counter <= 7'd0;
					if(counter2 < 18'd1599)
						begin state <= Delay; counter2 <= counter2 + 18'd1; end
					else if(!start_sign)
						begin spi_cs_n <= 1'b1; state <= Stop; counter2 <= 18'd0; end
					else
						begin spi_clk <= 1'b1; state <= C1; counter2 <= 18'd0; end
					end
				default:
					begin counter <= counter + 7'd1; counter2 <= counter2 + 18'd1; end
				endcase
			Delay:
				case(counter2)
				18'd1556:
					begin
					if(send_data_sign)
						begin fifo_ur_re <= 1'b1; end
					counter2 <= counter2 + 18'd1; 
					end
				18'd1557:
					begin
					if(fifo_ur_re)
						begin fifo_ur_re <= 1'b0; send_data_sign2 <= 1'b1; end
					counter2 <= counter2 + 18'd1;
					end
				18'd1558:
					begin
					if(send_data_sign2)
						begin stdata_tmp <= stdata; send_data_sign2 <= 1'b0; end
					else
						stdata_tmp <= 8'hff;
					counter2 <= counter2 + 18'd1;
					end
				18'd1559:
					begin spi_mosi <= stdata_tmp[7]; counter2 <= counter2 + 18'd1; end
				18'd1599:
					if(start_sign)
						begin spi_clk <= 1'b1; state <= C1; counter2 <= 18'd0; end
					else
						begin spi_cs_n <= 1'b1; state <= Stop; counter2 <= 18'd0; end
				default:
					counter2 <= counter2 + 18'd1;
				endcase
			Stop:
				case(counter2)
				18'd199999:
					begin state <= Nop; counter2 <= 18'd0; end
				default:
					counter2 <= counter2 + 18'd1;
				endcase
			endcase
	
endmodule
