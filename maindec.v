module maindec(
    input [5:0] op,
    output memtoreg,
    output memwrite,
    output branch,
    output alusrc,
    output regdst, 
    output regwrite,
    output [1:0] aluop
    );

reg [7:0] controls;

assign {regwrite, 
        regdst, alusrc, branch, memwrite, 
        memtoreg, aluop} = controls;

always @ (*)
    case(op)
        6'b000000: controls <= 8'b1_1000_010; //Rtype
        6'b100011: controls <= 8'b1_0100_100; //LW
        6'b101011: controls <= 8'b0_0101_000; //SW
        6'b000100: controls <= 8'b0_0010_001; //BEQ
        6'b001000: controls <= 8'b1_0100_000; //ADDI
        default: controls <= 8'bxxxx_xxxx;
    endcase
endmodule
