module hazard_unit(
    input regwrite_wb,
    input regwrite_mem,
    input memtoreg_ex,
    input [4:0] writereg_mem,
    input [4:0] writereg_wb,
    input [4:0] rse_id, rte_id,
    input [4:0] rse_ex, rte_ex,
    output [1:0] forward_a,
    output [1:0] forward_b,
    output stall_if, stall_id, flash_ex
    );

assign forward_a = func_forward_a(regwrite_wb, regwrite_mem, writereg_mem, writereg_wb, rse_ex);
assign forward_b = func_forward_b(regwrite_wb, regwrite_mem, writereg_mem, writereg_wb, rte_ex);

function [1:0] func_forward_a;
    input regwrite_wb;
    input regwrite_mem;
    input [4:0] writereg_mem;
    input [4:0] writereg_wb;
    input [4:0] rse_ex;
    
    if((rse_ex != 0) & (rse_ex == writereg_mem) & regwrite_mem) begin
        func_forward_a = 2'b10;
    end else if((rse_ex != 0) & (rse_ex == writereg_wb) & regwrite_wb) begin
        func_forward_a = 2'b01;
    end else  begin
        func_forward_a = 2'b00;
    end 
endfunction

function [1:0] func_forward_b;
    input regwrite_wb;
    input regwrite_mem;
    input [4:0] writereg_mem;
    input [4:0] writereg_wb;
    input [4:0] rte_ex;
    
    if((rte_ex != 0) & (rte_ex == writereg_mem) & regwrite_mem) begin
        func_forward_b = 2'b10;
    end else if((rte_ex != 0) & (rte_ex == writereg_wb) & regwrite_wb) begin
        func_forward_b = 2'b01;
    end else begin
        func_forward_b = 2'b00;
    end 
endfunction

assign stall_if = ~lwstall(memtoreg_ex, rse_id, rte_id, rte_ex);
assign stall_id = ~lwstall(memtoreg_ex, rse_id, rte_id, rte_ex);
assign flash_ex = lwstall(memtoreg_ex, rse_id, rte_id, rte_ex);

function lwstall;
    input memtoreg_ex;
    input [4:0] rse_id;
    input [4:0] rte_id;
    input [4:0] rte_ex;

    if(( (rse_id == rte_ex) | (rte_id == rte_ex) ) & memtoreg_ex) begin
        lwstall = 1'b1;
    end else begin
        lwstall = 1'b0;
    end
endfunction
endmodule