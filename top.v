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
`include "imem.v"
`include "datamem.v"

module top(
    input clk, reset,
    output [31:0] writedata,
    output [31:0] dataadr,
    output memwrite
    );
    
wire [31:0] pc, instr, readdata;

mips mips (clk, reset, pc, instr, memwrite, dataadr, writedata, readdata);

imem imem (pc[7:2], instr);
datamem datamem (clk, memwrite, dataadr, writedata, readdata);

endmodule
