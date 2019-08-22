`include "alu.v"

module testbench();
  reg [2:0]   alu_operation;
  reg [31:0]  input_data1;
  reg [31:0]  input_data2;
  wire [31:0] alu_result;
  wire zero;

  alu testalu(input_data1, input_data2, alu_operation, alu_result, zero);

  initial
    begin
      $dumpfile("alu_test.vcd");
      $dumpvars(0, testalu);

      $monitor("%b, %b", alu_result, zero);
      
      input_data1 = 3; input_data2 = 4; alu_operation = 3'b000; #10;//and
      input_data1 = 3; input_data2 = 3; alu_operation = 3'b010; #10;//add
      input_data1 = 5; input_data2 = 5; alu_operation = 3'b110; #10;//sub
      input_data1 = 3; input_data2 = 4; alu_operation = 3'b001; #10;//or
      input_data1 = 4; input_data2 = 3; alu_operation = 3'b111; #10;//SLT
      input_data1 = 3; input_data2 = 4; alu_operation = 3'b111; #10;//SLT
      input_data1 = 3; input_data2 = 3; alu_operation = 3'b011; #10;//(default)

      $finish;
    end
endmodule
