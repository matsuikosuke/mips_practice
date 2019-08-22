module maindec(
    input [5:0] op,
    output memtoreg,
    output memwrite,
    output branch,
    output alusrc,
    output regdst, 
    output regwrite,
    output jump,
    output [1:0] aluop
    );

reg [8:0] controls;

assign {regwrite, 
        regdst, alusrc, branch, memwrite, 
        memtoreg, jump, aluop} = controls;

always @ (*)
    case(op)
        6'b000000: controls <= 9'b1_1000_0010; //Rtype
        6'b100011: controls <= 9'b1_0100_1000; //LW
        6'b101011: controls <= 9'b0_0101_0000; //SW
        6'b000100: controls <= 9'b0_0010_0001; //BEQ
        6'b001000: controls <= 9'b1_0100_0000; //ADDI
        6'b000010: controls <= 9'b0_0000_0100; //J
        default: controls <= 9'bx_xxxx_xxxx;
    endcase
endmodule
