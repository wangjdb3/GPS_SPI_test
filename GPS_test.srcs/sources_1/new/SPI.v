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
    input wire[7:0] tdata,
    input wire start_sign,
    output reg Data_done
);
	parameter Nop = 12'b000000000001, Start = 12'b000000000010, Delay = 12'b000000000100, Stop = 12'b000000001000;
	parameter C1 = 12'b000000010000, C2 = 12'b000000100000, C3 = 12'b000001000000, C4 = 12'b000010000000;
	parameter C5 = 12'b000100000000, C6 = 12'b001000000000, C7 = 12'b010000000000, C8 = 12'b100000000000;
	reg[11:0] counter;
	reg[11:0] state;
	reg[17:0] counter2;
	
	always @( posedge clk_200M or negedge reset_n )
		if(!reset_n)
			begin
			state <= Nop;
			spi_cs_n <= 1'b1;
			spi_clk <= 1'b0;
			spi_mosi <= 1'b0;
			counter <= 12'd0;
			counter2 <= 18'd0;
			Data_done <= 1'b0;
			end
		else
			case (state)
			Nop:
				if (start_sign)
					begin
					spi_cs_n <= 1'b0;
					state <= Start;
					spi_clk <= 1'b0;
					end
			Start:
				case (counter)
				12'd2949:
					begin spi_mosi <= tdata[7]; counter <= counter + 12'd1;end
				12'd2999:
					begin
					state <= C1;
					spi_clk <= 1'b1;
					counter <= 12'd0;
					end
				default:
					begin counter <= counter + 12'd1; end
				endcase
			C1:
				case(counter)
				12'd49:
					begin
					spi_clk <= 1'b0;
					counter <= counter + 12'd1;
					counter2 <= counter2 + 18'd1;
					end
				12'd59:
					begin spi_mosi <= tdata[6]; counter <= counter + 12'd1;end
				12'd99:
					begin
					state <= C2;
					spi_clk <= 1'b1;
					counter <= 12'd0;
					counter2 <= counter2 + 18'd1;
					end
				default:
					begin counter <= counter + 12'd1; counter2 <= counter2 + 18'd1; end
				endcase
			C2:
				case(counter)
				12'd49:
					begin
					spi_clk <= 1'b0;
					counter <= counter + 12'd1;
					counter2 <= counter2 + 18'd1; 
					end
				12'd59:
					begin spi_mosi <= tdata[5]; counter <= counter + 12'd1;end
				12'd99:
					begin
					state <= C3;
					spi_clk <= 1'b1;
					counter <= 12'd0;
					counter2 <= counter2 + 18'd1; 
					end
				default:
					begin counter <= counter + 12'd1; counter2 <= counter2 + 18'd1; end
				endcase
			C3:
				case(counter)
				12'd49:
					begin
					spi_clk <= 1'b0;
					counter <= counter + 12'd1;
					counter2 <= counter2 + 18'd1;
					end
				12'd59:
					begin spi_mosi <= tdata[4]; counter <= counter + 12'd1;end
				12'd99:
					begin
					state <= C4;
					spi_clk <= 1'b1;
					counter <= 12'd0;
					counter2 <= counter2 + 12'd1;
					end
				default:
					begin counter <= counter + 12'd1; counter2 <= counter2 + 18'd1; end
				endcase
			C4:
				case(counter)
				12'd49:
					begin
					spi_clk <= 1'b0;
					counter <= counter + 12'd1;
					counter2 <= counter2 + 18'd1;
					end
				12'd59:
					begin spi_mosi <= tdata[3]; counter <= counter + 12'd1;end
				12'd99:
					begin
					state <= C5;
					spi_clk <= 1'b1;
					counter <= 12'd0;
					counter2 <= counter2 + 18'd1;
					end
				default:
					begin counter <= counter + 12'd1; counter2 <= counter2 + 18'd1; end
				endcase
			C5:
				case(counter)
				12'd49:
					begin
					spi_clk <= 1'b0;
					counter <= counter + 12'd1;
					counter2 <= counter2 + 18'd1;
					end
				12'd59:
					begin spi_mosi <= tdata[2]; counter <= counter + 12'd1;end
				12'd99:
					begin
					state <= C6;
					spi_clk <= 1'b1;
					counter <= 12'd0;
					counter2 <= counter2 + 18'd1;
					end
				default:
					begin counter <= counter + 12'd1; counter2 <= counter2 + 18'd1; end
				endcase
			C6:
				case(counter)
				12'd49:
					begin
					spi_clk <= 1'b0;
					counter <= counter + 12'd1;
					counter2 <= counter2 + 18'd1;
					end
				12'd59:
					begin spi_mosi <= tdata[1]; counter <= counter + 12'd1;end
				12'd99:
					begin
					state <= C7;
					spi_clk <= 1'b1;
					counter <= 12'd0;
					counter2 <= counter2 + 18'd1;
					end
				default:
					begin counter <= counter + 12'd1; counter2 <= counter2 + 18'd1; end
				endcase
			C7:
				case(counter)
				12'd49:
					begin
					spi_clk <= 1'b0;
					counter <= counter + 12'd1;
					counter2 <= counter2 + 18'd1; 
					end
				12'd59:
					begin spi_mosi <= tdata[0]; counter <= counter + 12'd1;end
				12'd99:
					begin
					state <= C8;
					spi_clk <= 1'b1;
					counter <= 12'd0;
					counter2 <= counter2 + 18'd1; 
					end
				default:
					begin counter <= counter + 12'd1; counter2 <= counter2 + 18'd1; end
				endcase
			C8:
				case(counter)
				12'd49:
					begin
					spi_clk <= 1'b0;
					counter <= counter + 12'd1;
					counter2 <= counter2 + 18'd1;
					Data_done <= 1'b1;
					end
				12'd50:
					begin Data_done <= 1'b0; counter <= counter + 12'd1; counter2 <= counter2 + 18'd1; end
				12'd59:
					begin
					if(counter2 > 18'd1508)
						spi_mosi <= tdata[7];
					counter <= counter + 12'd1;
					counter2 <= counter2 + 18'd1;
					end
				12'd99:
					begin
					counter <= 12'd0;
					if(counter2 < 18'd1599)
						begin state <= Delay; counter2 <= counter2 + 18'd1; end
					else if(!start_sign)
						begin spi_cs_n <= 1'b1; state <= Stop; counter2 <= 18'd0; end
					else
						begin spi_clk <= 1'b1; state <= C1; counter2 <= 18'd0; end
					end
				default:
					begin counter <= counter + 12'd1; counter2 <= counter2 + 18'd1; end
				endcase
			Delay:
				case(counter2)
				18'd1559:
					begin
					if(start_sign)
						spi_mosi <= tdata[7];
					counter2 <= counter2 + 18'd1; 
					end
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
			
	//assign D_SEL = 1'b0;
	
endmodule
