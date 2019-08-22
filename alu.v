`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/06 16:34:35
// Design Name: 
// Module Name: alu
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


module alu(
    input [31:0] a,b,
    input [2:0] f,
    output [31:0] y,
    output zero
);

wire [31:0] not_b;
wire [31:0] bb;
wire [31:0] s;
reg [31:0] out;

assign not_b = ~b;
assign bb = f[2]? not_b: b;
assign s = f[2]? a-b: a+b;

always @(*)
    begin
        case(f[1:0])
        2'b00: //  Logical AND 
           out = a & bb;
        2'b01: //  Logical OR
           out = a | bb;   
        2'b10: // Addition or Subtraction
           out = s ; 
        2'b11: // SLT
           out = {31'b0, s[31]};
        default: out = 32'b0; 
        endcase
    end

assign y = out;
assign zero = (out == 32'b0);

endmodule
