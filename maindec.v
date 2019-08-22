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

reg [14:0] controls;
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


assign {memtoreg, regdst, lord, pcsrc, alusrca, alusrcb,
        irwrite, memwrite, pcwrite, branch, regwrite,
        aluop} = controls;

always @ (posedge clk, posedge reset)
    if (reset) state <= S0;
    else state <= next_state;
    

always @ (*)
    case (state)
        S0:
            next_state = S1;
            controls = 15'b00000001_10100_00;
        S1:
            if(op = 6'b100011) //LW
                next_state = S2;
            else(op = 6'b101011) //SW
                next_state = S2;
            else(op = 6'b000000) //Rtype
                next_state = S6;
            else(op = 6'b000100) //BEQ
                next_state = S8;
            else(op = 6'b001000) //ADDI
                next_state = S9;
            else(op = 6'b000010) //J
                next_state = S11;
            else
                next_state = S1;
            controls = 15'b00000011_00000_00;
        S2:
            if(op = 6'b100011) //LW
                next_state = S3;
            else(op = 6'b101011) //SW
                next_state = S5;
            else
                next_state = S2;
            controls = 15'b00000110_00000_00;
        S3:
            next_state = S4;
            controls = 15'b00100000_00000_00;
        S4:
            next_state = S0;
            controls = 15'b10000000_00001_00;
        S5:
            next_state = S0;
            controls = 15'b00100000_01000_00;
        S6:
            next_state = S7;
            controls = 15'b00000100_00000_10;
        S7:
            next_state = S0;
            controls = 15'b01000000_00001_00;
        S8:
            next_state = S0;
            controls = 15'b00001100_00010_01;
        S9:
            next_state = S10;
            controls = 15'b00000110_00000_00;
        S10:
            next_state = S0;
            controls = 15'b00000000_00001_00;
        S11:
            next_state = S0;
            controls = 15'b00010000_00100_00;
        default: controls = 15'bxxxxxxxx_xxxxx_xx;
    endcase
endmodule
