`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/06 19:48:01
// Design Name: 
// Module Name: datapath
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
`include "flopr.v"
`include "add.v"
`include "sl2.v"
`include "mux2.v"
`include "regfile.v"
`include "signext.v"
`include "alu.v"

module datapath(
    input clk, reset,
    input memtoreg,
    input pcen,
    input [1:0] pcsrc,
    input alusrca,
    input [1:0] alusrcb,
    input regdst,
    input regwrite,
    input [2:0] alucontrol,
    input irwrite,
    input lord,
    output zero,
    output [31:0] pc,
    output [31:0] address, writedata,
    input  [31:0] readdata
    );
    
    wire  [31:0] instr,
    wire [4:0] writereg;
    wire [31:0] pcnext, pcnextbr, pcplus4;
    wire [31:0] signimm;
    wire [31:0] signimmsh;
    wire [31:0] rf_rd1, pre_srca, srca, srcb;
    wire [31:0] result;
    wire [31:0] alu_result;
    wire [31:0] aluout;
    wire [31:0] data;
    
    //PC
    flopenr #(32) pcreg(clk, reset, pcen, pcnext, pc);
    sl2 immsh(signimm, signimmsh);
    mux3 #(32) pcmux(alu_result, aluout, {pc[31:28], instr[25:0], 2'b00}, pcsrc, pcnext);
    flopenr #(32) instr_reg(clk, reset, irwrite, readdata, instr);
    flopr #(32) data_reg(clk, reset, readdata, data);
        
    //Register
    regfile rf(clk, 
               regwrite, 
               instr[25:21], instr[20:16], 
               writereg, data, 
               rf_rd1, writedata 
               );               
    flopr #(32) a_reg(clk, reset, rf_rd1, pre_srca);    
    mux2 #(5) wrmux(instr[20:16], instr[15:11], regdst, writereg);
    mux2 #(32) remux(aluout, data, memtoreg, result);
    signext se(instr[15:0], signimm);
    
    //ALU
    mux2 #(32) srcamux(pc, pre_srca, alusrca, srca);
    mux4 #(32) srcbmux(writedata, 32'h4, signimm, signimmsh, alusrcb, srcb);
    alu alu(srca, srcb, alucontrol, alu_result, zero);
    flopr #(32) alu_reg(clk, reset, alu_result, aluout);    
    mux2 #(32) alu_mux(pc, aluout, lord, address);
    
    
endmodule
