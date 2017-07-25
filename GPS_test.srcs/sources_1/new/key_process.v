`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/15 21:19:05
// Design Name: 
// Module Name: key_process
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


module key_process(
	input wire clk_200M,
	input wire reset_n,
	input wire[3:0] key_in,
	output wire[3:0] flag_key
);
	reg [23:0] count;
	reg [3:0] key_scan;
	reg [3:0] key_scan_r;
	
	always @(posedge clk_200M or negedge reset_n)     //���ʱ�ӵ������غ͸�λ���½���
		if(!reset_n)                //��λ�źŵ���Ч
			begin
			count <= 24'd0;        //��������0
			key_scan <= 4'b1111;
			end
		else
			begin
			if(count ==24'd3_999_999)   //20msɨ��һ�ΰ���,20ms����(200M/50-1=3_999_999)
				begin
				count <= 24'b0;     //�������Ƶ�20ms������������
				key_scan <= key_in; //�������������ƽ
				end
			else
				count <= count + 24'b1; //��������1
			end

	always @(posedge clk_200M or negedge reset_n)
		if(!reset_n)
			key_scan_r <= 4'b1111;
		else
			key_scan_r <= key_scan;       
			    
	assign flag_key = key_scan_r[3:0] & (~key_scan[3:0]);  //����⵽�������½��ر仯ʱ������ð��������£�������Ч
endmodule
