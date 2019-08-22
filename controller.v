`include "maindec.v"
`include "aludec.v"

module controller(
	input clk,
	input reset,
    input [5:0] op,
    input [5:0] funct,
    input zero,
    output memtoreg, memwrite,
    output pcen, 
    output [1:0] pcsrc, 
    output alusrca,
    output [1:0] alusrcb,
    output regdst, regwrite,
    output [2:0] alucontrol,
    output irwrite,
    output lord,
    );
    
wire [1:0] aluop;
wire branch;
wire pcwrite;

maindec md (clk, reset, op, memtoreg, memwrite, branch, pcwrite, pcsrc,
            alusrca, alusrcb, regdst, regwrite, irwrite, lord,
            aluop);
            
aludec ad (funct, aluop, alucontrol);

assign pcen = (branch & zero) | pcwrite;

endmodule