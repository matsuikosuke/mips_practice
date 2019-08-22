`include "maindec.v"
`include "aludec.v"

module controller(
    input [5:0] op,
    input [5:0] funct,
    input zero,
    output memtoreg, memwrite,
    output pcsrc, alusrc,
    output regdst, regwrite,
    output jump,
    output [2:0] alucontrol
    );
    
wire [1:0] aluop;
wire branch;

maindec md (op, memtoreg, memwrite, branch,
            alusrc, regdst, regwrite, jump,
            aluop);
            
aludec ad (funct, aluop, alucontrol);

assign pcsrc = branch & zero;

endmodule