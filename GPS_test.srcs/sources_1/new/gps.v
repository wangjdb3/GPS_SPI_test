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
	
	reg select1, select2;
	wire spi_cs_n, spi_clk, spi_mosi;
	wire Gtx, Grx;
	wire start_sign;
	wire[7:0] tdata;
	reg[7:0] add;
	wire Data_done;
	
	reg [23:0] count;
	reg [3:0] key_scan;
	always @(posedge clk_200M or negedge reset_n)     //检测时钟的上升沿和复位的下降沿
		if(!reset_n)                //复位信号低有效
			count <= 24'd0;        //计数器清0
		else
			begin
			if(count ==24'd3_999_999)   //20ms扫描一次按键,20ms计数(200M/50-1=3_999_999)
				begin
				count <= 24'b0;     //计数器计到20ms，计数器清零
				key_scan <= key_in; //采样按键输入电平
				end
			else
				count <= count + 24'b1; //计数器加1
			end
	reg [3:0] key_scan_r;
	always @(posedge clk_200M)
		key_scan_r <= key_scan;       
			    
	wire [3:0] flag_key = key_scan_r[3:0] & (~key_scan[3:0]);  //当检测到按键有下降沿变化时，代表该按键被按下，按键有效
		
	always @(posedge clk_200M or negedge reset_n)
		if(!reset_n)
			begin
			LED <= 4'b1111;
			select1 <= 1'b0;
			select2 <= 1'b0;
			end
		else
			begin
			if ( flag_key[0] )
				begin
				LED[0] <= ~LED[0];
				select1 <= ~select1;
				end
				else
			if ( flag_key[1] )
				begin
				LED[1] <= ~LED[1];
				select2 <= ~select2;
				end
			if ( flag_key[2] )
				begin 
				end
			if ( flag_key[3] )
				begin 
				end
			end

	SPI SPI_0(
		.clk_200M(clk_200M),
		.reset_n(reset_n),
		.spi_cs_n(spi_cs_n),
		.spi_clk(spi_clk),
		.spi_miso(tx_spi_miso),
		.spi_mosi(spi_mosi),
		.TP(TP),
		.tdata(tdata),
		.start_sign(start_sign),
		.Data_done(Data_done)
	);
	
	uart uart_0(
		.Gtx(tx_spi_miso),
		.Grx(Grx),
		.tx(tx),
		.rx(rx),
		.TP(TP)
	);
	
	dist_mem_gen_0 rom_0 (
	  .a(add),      // input wire [7 : 0] a
	  .spo(tdata)  // output wire [7 : 0] spo
	);
	
	always @( posedge clk_200M or negedge reset_n)
		if (!reset_n)
			begin
			add <= 8'd0;
			end
		else if(Data_done  && add < 100)
			add <= add + 8'd1;
	
	assign sda_spi_cs_n = select1 ? spi_cs_n : 1'b1;
	assign sda_spi_clk = select1 ? spi_clk : 1'bz;
	assign rx_spi_mosi = select1 ? spi_mosi : Grx;
	assign D_SEL = select2 ? 1'b0 : 1'b1;
	assign start_sign = select1 ? 1'b1 : 1'b0;
	
	assign spi_cs_n_d = sda_spi_cs_n;
	assign spi_clk_d = sda_spi_clk;
	assign spi_miso_d = tx_spi_miso;
	assign spi_mosi_d = rx_spi_mosi;
	
	assign SAFEBOOT_N = 1'b1;
	
endmodule
