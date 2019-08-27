`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/06 19:48:01
// Design Name: 
// Module Name: datapath
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
`include "flopr.v"
`include "add.v"
`include "sl2.v"
`include "mux2.v"
`include "mux3.v"
`include "regfile.v"
`include "signext.v"
`include "alu.v"
`include "pipeline_reg.v"
`include "hazard_unit.v"

module datapath(
    input clk, reset,
    // Control Lines WB
    input memtoreg_id,
    input regwrite_id,
    // Control Lines MEM
    input branch_id,
    input memwrite_id,
    output memwrite_mem,
    // Control Lines EX
    input [2:0] alucontrol_id,
    input alusrc_id,
    input regdst_id,
    // Data Path
    output [31:0] pc,
    input  [31:0] instr,
    output [31:0] instr_id,
    output [31:0] aluout_mem, writedata_mem,
    input  [31:0] readdata_mem
    );
    
    wire [31:0] pcplus4_if, pcplus4_id, pcplus4_ex;
    wire [31:0] pcbranch_ex, pcbranch_mem;
    wire [31:0] signimm_id, signimm_ex;
    wire [31:0] signimmsh;
    wire [31:0] aluout_ex, aluout_mem, aluout_wb;
    wire [31:0] srca_id, pre_srca_ex, srca_ex, pre_srcb, srcb;
    wire [31:0] writedata_id, writedata_ex, writedata_mem;
    wire [4:0] rse_id, rte_id, rde_id, rse_ex, rte_ex, rde_ex;
    wire [31:0] instr_id;
    wire zero_ex, zero_mem;
    wire [4:0] writereg_ex, writereg_mem, writereg_wb;
    wire [31:0] readdata_mem, readdata_wb;
    wire [2:0] alucontrol_id, alucontrol_ex;    
    wire [31:0] pcnext;
    wire [31:0] result;
    wire regdst_id, regdst_ex;
    wire alusrc_id, alusrc_ex;
    wire memwrite_id, memwrite_ex, memwrite_mem;
    wire [1:0] forward_a, forward_b;
    
    // Hazard Unit
    hazard_unit hazard_check(
        regwrite_wb, regwrite_mem, writereg_mem, writereg_wb, 
        rse_ex, rte_ex, forward_a, forward_b
    );
    
    // IF stage
    flopr #(32) pcreg(clk, reset, pcnext, pc);
    adder pcadd1(pc, 32'b100, pcplus4_if);
    mux2 #(32) pcbrmux(pcplus4_if, pcbranch_mem, pcsrc, pcnext);
    if_id_reg if_id_pipeline(clk, reset, pcplus4_if, instr, pcplus4_id, instr_id);
    
    // ID stage
    regfile rf(clk,
               regwrite_wb, 
               instr_id[25:21], instr_id[20:16], 
               writereg_wb, result,
               srca_id, writedata_id 
               );
    signext se(instr_id[15:0], signimm_id);
    assign rse_id = instr_id[25:21];
    assign rte_id = instr_id[20:16];
    assign rde_id = instr_id[15:11];
    id_ex_reg id_ex_pipeline(clk, 
            pcplus4_id, pcplus4_ex, 
            srca_id, pre_srca_ex, 
            writedata_id, writedata_ex, 
            rse_id, rte_id, rde_id, rse_ex, rte_ex, rde_ex, 
            signimm_id, signimm_ex,
            // Control Lines WB
            memtoreg_id,
            regwrite_id,
            memtoreg_ex,
            regwrite_ex,
            // Control Lines MEM
            branch_id,
            memwrite_id,
            branch_ex,
            memwrite_ex,
            // Control Lines EX
            alucontrol_id,
            alusrc_id,
            regdst_id,
            alucontrol_ex,
            alusrc_ex,
            regdst_ex);
              
               
    // EX stage
    sl2 immsh(signimm_ex, signimmsh);
    adder pcadd2(pcplus4_ex, signimmsh, pcbranch_ex);
    alu alu(srca_ex, srcb, alucontrol_ex, aluout_ex, zero_ex);
    mux2 #(32) srcbmux(writedata_ex, signimm_ex, alusrc_ex, pre_srcb);
    mux2 #(5) wrmux(rte_ex, rde_ex, regdst_ex, writereg_ex);    
    mux3 #(32) mux_forward_a(pre_srca_ex, result, aluout_mem, forward_a, srca_ex);
    mux3 #(32) mux_forward_b(pre_srcb, result, aluout_mem, forward_b, srcb);
    ex_mem_reg ex_mem_pipeline(clk, 
            zero_ex, zero_mem,
            aluout_ex, aluout_mem,
            writedata_ex, writedata_mem,
            writereg_ex, writereg_mem,
            pcbranch_ex, pcbranch_mem,
            // Control Lines WB
            memtoreg_ex,
            regwrite_ex,
            memtoreg_mem,
            regwrite_mem,
            // Control Lines MEM
            branch_ex,
            memwrite_ex,
            branch_mem,
            memwrite_mem); 
    
    // MEM stage
    assign pcsrc = branch_mem & zero_mem;
    mem_wb_reg mem_wb_pipeline(clk, 
            aluout_mem, aluout_wb,
            readdata_mem, readdata_wb,
            writereg_mem, writereg_wb,
            // Control Lines WB
            memtoreg_mem,
            regwrite_mem,
            memtoreg_wb,
            regwrite_wb);
    
    // WB stage
    mux2 #(32) remux(aluout_wb, readdata_wb, memtoreg_wb, result);   
endmodule
