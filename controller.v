`include "maindec.v"
`include "aludec.v"

module controller(
    // Data Path
    input [5:0] op,
    input [5:0] funct,
    // Control Lines WB
    output memtoreg, 
    output regwrite,    
    // Control Lines MEM
    output branch,
    output memwrite,
    // Control Lines EX
    output [2:0] alucontrol,
    output alusrc,
    output regdst
    );
    
wire [1:0] aluop;
wire branch;

maindec md (op, memtoreg, memwrite, branch,
            alusrc, regdst, regwrite,
            aluop);
            
aludec ad (funct, aluop, alucontrol);

endmodule