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
    input pcsrc,
    input alusrc,
    input regdst,
    input regwrite,
    input jump,
    input [2:0] alucontrol,
    output zero,
    output [31:0] pc,
    input  [31:0] instr,
    output [31:0] aluout, writedata,
    input  [31:0] readdata
    );
    
    wire [4:0] writereg;
    wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
    wire [31:0] signimm;
    wire [31:0] signimmsh;
    wire [31:0] srca, srcb;
    wire [31:0] result;
    
    // IF stage
    flopr #(32) pcreg(clk, reset, pcnext, pc);
    adder pcadd1(pc, 32'b100, pcplus4);
    mux2 #(32) pcbrmux(pcplus4, pcbranch, pcsrc, pcnextbr);
    mux2 #(32) pcmux(pcnextbr, {pcplus4[31:28], instr[25:0], 2'b00}, jump, pcnext);
    
    // ID stage
    regfile rf(clk, 
               regwrite, 
               instr[25:21], instr[20:16], 
               writereg, result,
               srca, writedata 
               );
    signext se(instr[15:0], signimm);
               
    // EX stage
    sl2 immsh(signimm, signimmsh);
    adder pcadd2(pcplus4, signimmsh, pcbranch);
    alu alu(srca, srcb, alucontrol, aluout, zero);
    mux2 #(32) srcbmux(writedata, signimm, alusrc, srcb);
    mux2 #(5) wrmux(instr[20:16], instr[15:11], regdst, writereg);
    
    // WB stage
    mux2 #(32) remux(aluout, readdata, memtoreg, result);    
endmodule
