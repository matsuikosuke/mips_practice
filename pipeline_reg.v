module if_id_reg(
    input  clk,
    input  reset,
    input  stall_id, 
    input [31:0] in_pcplus4,
    input [31:0] in_inst,
    output reg [31:0] out_pcplus4,
    output reg [31:0] out_inst
    ); 

always @ (posedge clk, posedge reset)
    if(reset)
        begin
            out_pcplus4 <= 0;
            out_inst <= 0;
        end
    else if(stall_id)
        begin
            out_pcplus4 <= in_pcplus4;
            out_inst <= in_inst;
        end
endmodule


module id_ex_reg(
    input  clk,
    input  flash_ex,
    input [31:0]  in_pcplus4,
    output reg [31:0]out_pcplus4,
    input [31:0] in_srca,
    output reg [31:0] out_srca,
    input [31:0] in_writedata,
    output reg [31:0] out_writedata,
    input [4:0] in_rse, in_rte, in_rde,
    output reg [4:0] out_rse, out_rte, out_rde,
    input [31:0]in_signimm,
    output reg [31:0] out_signimm,
    // Control Lines WB
    input in_memtoreg,
    input in_regwrite,
    output reg out_memtoreg,
    output reg out_regwrite,
    // Control Lines MEM
    input in_branch,
    input in_memwrite,
    output reg out_branch,
    output reg out_memwrite,
    // Control Lines EX
    input [2:0] in_alucontrol,
    input in_alusrc,
    input in_regdst,
    output reg [2:0] out_alucontrol,
    output reg out_alusrc,
    output reg out_regdst
    );

initial
begin
    out_pcplus4 = 32'b0;
    out_srca = 32'b0;
    out_writedata = 32'b0;
    out_rse = 5'b0; 
    out_rte = 5'b0; 
    out_rde = 5'b0;
    out_signimm = 32'b0;
    out_memtoreg = 1'b0;
    out_regwrite = 1'b0;
    out_branch = 1'b0;
    out_memwrite = 1'b0;
    out_alucontrol = 3'b0;
    out_alusrc = 1'b1;
    out_regdst = 1'b0;
end

always @ (posedge clk)
if(flash_ex)
    begin
        out_pcplus4 <= 32'b0;
        out_srca <= 32'b0;
        out_writedata <= 32'b0;
        out_rse <= 5'b0;
        out_rte <= 5'b0;
        out_rde <= 5'b0;
        out_signimm <= 32'b0;
        out_memtoreg <= 1'b0;
        out_regwrite <= 1'b0;
        out_branch <= 1'b0;
        out_memwrite <= 1'b0;
        out_alucontrol <= 3'b0;
        out_alusrc <= 1'b1;
        out_regdst <= 1'b0;
    end
else
    begin
        out_pcplus4 <= in_pcplus4;
        out_srca <= in_srca;
        out_writedata <= in_writedata;
        out_rse <= in_rse;
        out_rte <= in_rte;
        out_rde <= in_rde;
        out_signimm <= in_signimm;
        // Control Lines WB
        out_memtoreg <= in_memtoreg;
        out_regwrite <= in_regwrite;
        // Control Lines MEM
        out_branch <= in_branch;
        out_memwrite <= in_memwrite;
        // Control Lines EX
        out_alucontrol <= in_alucontrol;
        out_alusrc <= in_alusrc;
        out_regdst <= in_regdst;
    end
endmodule


module ex_mem_reg(
    input  clk,
    input in_zero,
    output reg out_zero,
    input [31:0] in_aluout,
    output reg [31:0] out_aluout,
    input [31:0] in_writedata,
    output reg [31:0] out_writedata,
    input [4:0] in_writereg,
    output reg [4:0] out_writereg,
    input [31:0] in_pcbranch,
    output reg [31:0] out_pcbranch,
    // Control Lines WB
    input in_memtoreg,
    input in_regwrite,
    output reg out_memtoreg,
    output reg out_regwrite,
    // Control Lines MEM
    input in_branch,
    input in_memwrite,
    output reg out_branch,
    output reg out_memwrite
    );

initial
begin
    out_zero = 1'b0;
    out_aluout = 32'b0;
    out_writedata = 32'b0;
    out_writereg = 5'b0;
    out_pcbranch = 32'b0;    
    out_memtoreg = 1'b0;
    out_regwrite = 1'b0;
    out_branch = 1'b0;
    out_memwrite = 1'b0;
end

always @ (posedge clk)
begin
    out_zero <= in_zero;
    out_aluout <= in_aluout;
    out_writedata <= in_writedata;
    out_writereg <= in_writereg;
    out_pcbranch <= in_pcbranch;
    // Control Lines WB
    out_memtoreg <= in_memtoreg;
    out_regwrite <= in_regwrite;
    // Control Lines MEM
    out_branch <= in_branch;
    out_memwrite <= in_memwrite;
end
endmodule


module mem_wb_reg(
    input  clk,
    input [31:0] in_aluout,
    output reg [31:0] out_aluout,
    input [31:0] in_readdata,
    output reg [31:0] out_readdata,
    input [4:0] in_writereg,
    output reg [4:0] out_writereg,
    // Control Lines WB
    input in_memtoreg,
    input in_regwrite,
    output reg out_memtoreg,
    output reg out_regwrite
    );

initial
begin
    out_aluout = 32'b0;
    out_readdata = 32'b0;
    out_writereg = 5'b0;
    out_memtoreg = 1'b0;
    out_regwrite = 1'b0;
end

always @ (posedge clk)
begin
    out_aluout <= in_aluout;
    out_readdata <= in_readdata;
    out_writereg <= in_writereg;
    // Control Lines WB
    out_memtoreg <= in_memtoreg;
    out_regwrite <= in_regwrite;
end
endmodule
