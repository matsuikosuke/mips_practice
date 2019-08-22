`include "controller.v"
`include "datapath.v"

module mips(
    input  clk, reset,
    output [31:0] address,
    output memwrite,
    output [31:0] writedata,
    input [31:0] readdata
    );

wire [31:0] instr;
wire memtoreg; 
wire branch;
wire pcen;
wire [1:0] pcsrc;
wire alusrca;
wire [1:0] alusrcb;
wire regdst;
wire regwrite;
wire [2:0] alucontrol;
wire irwrite;
wire lord;
wire zero;
   
controller c(clk, reset, 
             instr[31:26],
             instr[5:0],
             zero,
             memtoreg, 
             memwrite, 
             pcen,
             pcsrc,
             alusrca, alusrcb, regdst, regwrite,
             alucontrol, irwrite, lord);

datapath dp(clk, reset, memtoreg, pcen, pcsrc,
            alusrca, alusrcb, regdst, regwrite,
            alucontrol, irwrite, lord,
            zero, instr,
            address, writedata, readdata );
   
endmodule