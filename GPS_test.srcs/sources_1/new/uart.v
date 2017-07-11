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
//    input sys_clk_p,
//    input sys_clk_n,
                
    input Gtx,
    output Grx,
    output tx,
    input rx,
    
//    output D_SEL,
//    output SAFEBOOT_N,
    input TP
    );
    
/*    wire sys_clk_ibufg;
    IBUFGDS #(
        .DIFF_TERM    ("FALSE"),
        .IBUF_LOW_PWR ("FALSE")
    )
    u_ibufg_sys_clk(
    .I  (sys_clk_p),
    .IB (sys_clk_n),
    .O  (sys_clk_ibufg)
    );
*/
    
    assign tx = Gtx;
    assign Grx = rx;
endmodule
