`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/20 15:45:31
// Design Name: 
// Module Name: imem
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


module imem(
    input [5:0] a,
    output [31:0] rd
    );
    
reg [31:0] RAM[63:0];

initial
  begin
    $readmemh("memfile_pipeline1.mem", RAM);
  end
    
  assign rd = RAM[a];
endmodule
