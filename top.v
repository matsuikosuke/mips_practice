`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/20 15:41:16
// Design Name: 
// Module Name: top
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
`include "mips.v"
`include "idmem.v"

module top(
    input clk, reset,
    output [31:0] writedata,
    output [31:0] address,
    output memwrite
    );
    
wire [31:0] readdata;

mips mips (clk, reset, address, memwrite,  writedata, readdata);

idmem idmem (clk, memwrite, address, writedata, readdata);

endmodule
