`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/05 15:39:34
// Design Name: 
// Module Name: uart
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


module uart(
	input wire clk_200M,
	input wire reset_n,
    output reg tx,
    input wire rx,
    output reg rx_done,
	input wire[7:0] Tdata,
	output reg[7:0] Rdata,
	output reg fifor_we,
	input wire fifot_empty,
	output reg fifot_re
);
	reg[14:0] Rcounter;
	reg[14:0] Tcounter;
	reg[11:0] Rstatus;
	reg[11:0] Tstatus;
	reg rxbuf, rxfall;
	
	parameter Nop = 12'h001, Start = 12'h002, S1 = 12'h004, S2 = 12'h008, S3 = 12'h010, S4 = 12'h020, 
				S5 = 12'h040, S6 = 12'h080, S7 = 12'h100, S8 = 12'h200, Stop = 12'h400, Rwait_start = 12'h800;
	
	always @( posedge clk_200M or negedge reset_n)
		if(!reset_n)
			begin
			rxbuf <= 1'b0;
			rxfall <= 1'b0;
			Rcounter <= 15'd0;
			Rstatus <= Nop;
			Rdata <= 8'h00;
			rx_done <= 1'b0;
			fifor_we <= 1'b0;
			end
		else
			case (Rstatus)
			Nop:
				begin
				rx_done <= 1'b0;
				rxbuf <= rx;
				rxfall <= rxbuf & (~rx);
				if (rxfall)
					Rstatus <= Start;
				end
			Start:
				case (Rcounter)
				15'd20830:
					begin Rstatus <= S1; Rcounter <= 15'd0; end
				default:
					Rcounter <= Rcounter + 15'd1;
				endcase
			S1:
				case (Rcounter)
				15'd10000:
					begin Rdata[0] <= rx; Rcounter <= Rcounter + 15'd1; end
				15'd20832:
					begin Rstatus <= S2; Rcounter <= 15'd0; end
				default:
					Rcounter <= Rcounter + 15'd1;
				endcase
			S2:
				case (Rcounter)
				15'd10000:
					begin Rdata[1] <= rx; Rcounter <= Rcounter + 15'd1; end
				15'd20832:
					begin Rstatus <= S3; Rcounter <= 15'd0; end
				default:
					Rcounter <= Rcounter + 15'd1;
				endcase
			S3:
				case (Rcounter)
				15'd10000:
					begin Rdata[2] <= rx; Rcounter <= Rcounter + 15'd1; end
				15'd20832:
					begin Rstatus <= S4; Rcounter <= 15'd0; end
				default:
					Rcounter <= Rcounter + 15'd1;
				endcase
			S4:
				case (Rcounter)
				15'd10000:
					begin Rdata[3] <= rx; Rcounter <= Rcounter + 15'd1; end
				15'd20832:
					begin Rstatus <= S5; Rcounter <= 15'd0; end
				default:
					Rcounter <= Rcounter + 15'd1;
				endcase
			S5:
				case (Rcounter)
				15'd10000:
					begin Rdata[4] <= rx; Rcounter <= Rcounter + 15'd1; end
				15'd20832:
					begin Rstatus <= S6; Rcounter <= 15'd0; end
				default:
					Rcounter <= Rcounter + 15'd1;
				endcase
			S6:
				case (Rcounter)
				15'd10000:
					begin Rdata[5] <= rx; Rcounter <= Rcounter + 15'd1; end
				15'd20832:
					begin Rstatus <= S7; Rcounter <= 15'd0; end
				default:
					Rcounter <= Rcounter + 15'd1;
				endcase
			S7:
				case (Rcounter)
				15'd10000:
					begin Rdata[6] <= rx; Rcounter <= Rcounter + 15'd1; end
				15'd20832:
					begin Rstatus <= S8; Rcounter <= 15'd0; end
				default:
					Rcounter <= Rcounter + 15'd1;
				endcase
			S8:
				case (Rcounter)
				15'd10000:
					begin Rdata[7] <= rx; fifor_we <= 1'b1; Rcounter <= Rcounter + 15'd1; end
				15'd10001:
					begin fifor_we <= 1'b0; Rcounter <= Rcounter + 15'd1; end
				15'd20832:
					begin Rstatus <= Stop; Rcounter <= 15'd0; end
				default:
					Rcounter <= Rcounter + 15'd1;
				endcase
			Stop:
				case (Rcounter)
				15'd19999:
					begin Rstatus <= Rwait_start; Rcounter <= Rcounter + 15'd1; end
				default:
					Rcounter <= Rcounter + 15'd1;
				endcase
			Rwait_start:
				case (Rcounter)
				15'd25999:
					begin Rstatus <= Nop; rx_done <= 1'b1; Rcounter <= 15'd0; end
				default:
					begin
					rxbuf <= rx;
					rxfall <= rxbuf & (~rx);
					if (rxfall)
						begin Rstatus <= Start; Rcounter <= 15'd0; end
					else
						Rcounter <= Rcounter + 15'd1;
					end
				endcase
			endcase
	
	always @( posedge clk_200M or negedge reset_n)
		if(!reset_n)
			begin
			tx <= 1'b1;
			fifot_re <= 1'b0;
			Tstatus <= Nop;
			Tcounter <= 15'd0;
			end
		else
			case (Tstatus)
			Nop:
				if(!fifot_empty)
					begin fifot_re <= 1'b1; Tstatus <= Start; end
			Start:
				case(Tcounter)
				15'd0:
					begin tx <= 1'b0; fifot_re <= 1'b0; Tcounter <= Tcounter + 15'd1; end
				15'd20832:
					begin Tstatus <= S1; Tcounter <= 15'd0; end
				default:
					Tcounter <= Tcounter + 15'd1;
				endcase
			S1:
				case(Tcounter)
				15'd0:
					begin tx <= Tdata[0]; Tcounter <= Tcounter + 15'd1; end
				15'd20832:
					begin Tstatus <= S2; Tcounter <= 15'd0; end
				default:
					Tcounter <= Tcounter + 15'd1;
				endcase
			S2:
				case(Tcounter)
				15'd0:
					begin tx <= Tdata[1]; Tcounter <= Tcounter + 15'd1; end
				15'd20832:
					begin Tstatus <= S3; Tcounter <= 15'd0; end
				default:
					Tcounter <= Tcounter + 15'd1;
				endcase
			S3:
				case(Tcounter)
				15'd0:
					begin tx <= Tdata[2]; Tcounter <= Tcounter + 15'd1; end
				15'd20832:
					begin Tstatus <= S4; Tcounter <= 15'd0; end
				default:
					Tcounter <= Tcounter + 15'd1;
				endcase
			S4:
				case(Tcounter)
				15'd0:
					begin tx <= Tdata[3]; Tcounter <= Tcounter + 15'd1; end
				15'd20832:
					begin Tstatus <= S5; Tcounter <= 15'd0; end
				default:
					Tcounter <= Tcounter + 15'd1;
				endcase
			S5:
				case(Tcounter)
				15'd0:
					begin tx <= Tdata[4]; Tcounter <= Tcounter + 15'd1; end
				15'd20832:
					begin Tstatus <= S6; Tcounter <= 15'd0; end
				default:
					Tcounter <= Tcounter + 15'd1;
				endcase
			S6:
				case(Tcounter)
				15'd0:
					begin tx <= Tdata[5]; Tcounter <= Tcounter + 15'd1; end
				15'd20832:
					begin Tstatus <= S7; Tcounter <= 15'd0; end
				default:
					Tcounter <= Tcounter + 15'd1;
				endcase
			S7:
				case(Tcounter)
				15'd0:
					begin tx <= Tdata[6]; Tcounter <= Tcounter + 15'd1; end
				15'd20832:
					begin Tstatus <= S8; Tcounter <= 15'd0; end
				default:
					Tcounter <= Tcounter + 15'd1;
				endcase
			S8:
				case(Tcounter)
				15'd0:
					begin tx <= Tdata[7]; Tcounter <= Tcounter + 15'd1; end
				15'd20832:
					begin Tstatus <= Stop; Tcounter <= 15'd0; end
				default:
					Tcounter <= Tcounter + 15'd1;
				endcase
			Stop:
				case(Tcounter)
				15'd0:
					begin tx <= 1'b1; Tcounter <= Tcounter + 15'd1; end
				15'd20836:
					begin 
					Tcounter <= 15'd0;
					if(!fifot_empty)
						begin fifot_re <= 1'b1; Tstatus <= Start; end
					else
						Tstatus <= Nop; 
					end
				default:
					Tcounter <= Tcounter + 15'd1;
				endcase
			endcase
	
endmodule
