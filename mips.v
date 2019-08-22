`include "controller.v"
`include "datapath.v"

module mips(
    input  clk, reset,
    output [31:0] pc,
    input [31:0] instr,
    output memwrite,
    output [31:0] aluout, writedata,
    input [31:0] readdata
    );

wire memtoreg; 
wire branch;
wire alusrc;
wire regdst;
wire regwrite;
wire jump;
wire [2:0] alucontrol;
wire zero;
wire pcsrc;
   
controller c(instr[31:26],
             instr[5:0],
             zero,
             memtoreg, 
             memwrite, 
             pcsrc,
             alusrc, regdst, regwrite, jump,
             alucontrol);

datapath dp(clk, reset, memtoreg, pcsrc,
            alusrc, regdst, regwrite, jump,
            alucontrol, 
            zero, pc, instr, 
            aluout, writedata, readdata );
   
endmodule