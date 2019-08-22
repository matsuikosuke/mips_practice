module maindec(
    input [5:0] op,
    output memtoreg,
    output memwrite,
    output branch,
    output pcwrite,
    output [1:0] pcsrc, 
    output alusrca,
    output [1:0] alusrcb,
    output regdst, 
    output regwrite,
    output irwrite,
    output lord,
    output [1:0] aluop
    );

reg [15:0] controls;
reg [10:0] state, next_state;

parameter S0 =  11'b000_0000_0000;
parameter S1 =  11'b000_0000_0001;
parameter S2 =  11'b000_0000_0010;
parameter S3 =  11'b000_0000_0100;
parameter S4 =  11'b000_0000_1000;
parameter S5 =  11'b000_0001_0000;
parameter S6 =  11'b000_0010_0000;
parameter S7 =  11'b000_0100_0000;
parameter S8 =  11'b000_1000_0000;
parameter S9 =  11'b001_0000_0000;
parameter S10 = 11'b010_0000_0000;
parameter S11 = 11'b100_0000_0000;

always @ (posedge clk, posedge reset)
    if (reset) state <= S0;
    else state <= next_state;

assign {regwrite, 
        regdst, alusrca, alusrcb, branch, pcwrite, pcsrc, memwrite, 
        memtoreg, irwrite, lord, aluop} = controls;

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
