`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/06 20:26:03
// Design Name: 
// Module Name: mux2
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

module mux4 # (parameter WIDTH = 8)(
    input [WIDTH-1:0] d0, d1, d2, d3,
    input [1:0] s,
    output [WIDTH-1:0] y
    );
    
    assign y = s[1]? (s[0]? d3: d2): (s[0]? d1: d0); 
endmodule
