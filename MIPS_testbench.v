`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/20 14:25:46
// Design Name: 
// Module Name: MIPS_testbench
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


`include "top.v"

module MIPS_testbench();

reg clk;
reg reset;

wire [31:0] writedata;
wire [31:0] dataadr;
wire memwrite;

top dut (clk, reset, writedata, dataadr, memwrite);

initial
  begin
    $dumpfile("MIPStest.vcd");
    $dumpvars(0, dut);

    $monitor("%h, %h, %h", dut.mips.address, dut.idmem.a, dut.idmem.wd);

    reset <= 1;
    #22;
    reset <= 0;
  end
  
 always
   begin
     clk <= 1;
     #5;
     clk <= 0;
     #5;
   end
   
always @ (negedge clk)
  begin
    if (memwrite) begin
      if(dataadr === 84 & writedata === 7) begin
        $display("simulation succeeded");
        $finish;
      end else if (dataadr !== 80) begin
        $display("simulation failed");
        $finish;
      end
    end
  end
endmodule
