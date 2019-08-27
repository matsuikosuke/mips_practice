`include "controller.v"
`include "datapath.v"

module mips(
    input  clk, reset,
    output [31:0] pc,
    input [31:0] instr,
    output memwrite_mem,
    output [31:0] aluout, writedata,
    input [31:0] readdata
    );

// Control Lines WB
wire memtoreg_id; 
wire regwrite_id;
// Control Lines MEM
wire branch_id;
wire memwrite_id, memwrite_mem;
// Control Lines EX
wire [2:0] alucontrol_id;
wire alusrc_id;
wire regdst_id;
wire [31:0] instr_id;
   
controller c(
            // Data Path
            instr_id[31:26],
            instr_id[5:0],
            // Control Lines WB
            memtoreg_id,
            regwrite_id,
            // Control Lines MEM
            branch_id,
            memwrite_id,
            // Control Lines EX
            alucontrol_id,
            alusrc_id,
            regdst_id
            );

datapath dp(clk, reset, 
            // Control Lines WB
            memtoreg_id, 
            regwrite_id,            
            // Control Lines MEM
            branch_id,
            memwrite_id, 
            memwrite_mem,
            // Control Lines EX
            alucontrol_id,
            alusrc_id,
            regdst_id,
            // Data Path
            pc, instr, instr_id,
            aluout, writedata, readdata );
endmodule