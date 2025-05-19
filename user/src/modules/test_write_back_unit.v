`timescale 1ns/1ps
`include "../../inc/registers_writeback.v"

module write_back_unit_tb();
    // Test signals
    reg [1:0] wb_sel;
    reg [31:0] alu_result;
    reg [31:0] immediate;
    reg [31:0] mem_data;
    reg [31:0] pc_next;
    wire [31:0] write_data;
    
    // Instantiate DUT
    write_back_unit dut(
        .wb_sel(wb_sel),
        .alu_result(alu_result),
        .immediate(immediate),
        .mem_data(mem_data),
        .pc_next(pc_next),
        .write_data(write_data)
    );
    
    // For waveform generation
    initial begin
        $dumpfile("write_back_unit_tb.vcd");
        $dumpvars(0, write_back_unit_tb);
        
        // Initialize inputs
        wb_sel = 2'b0;
        alu_result = 32'h0;
        immediate = 32'h0;
        mem_data = 32'h0;
        pc_next = 32'h0;
        #10;
        
        // Test case 1: ALU Result
        wb_sel = `REG_WB_ALU_OUT;
        alu_result = 32'hA5A5A5A5;
        #10;
        $display("Test ALU_OUT: Expected: %h, Got: %h", alu_result, write_data);
        
        // Test case 2: Immediate Data
        wb_sel = `REG_WB_IMM_DAT;
        immediate = 32'h12345678;
        #10;
        $display("Test IMM_DAT: Expected: %h, Got: %h", immediate, write_data);
        
        // Test case 3: Memory Data
        wb_sel = `REG_WB_MEM_DAT;
        mem_data = 32'hBBBBBBBB;
        #10;
        $display("Test MEM_DAT: Expected: %h, Got: %h", mem_data, write_data);
        
        // Test case 4: PC Next
        wb_sel = `REG_WB_PC_NEXT;
        pc_next = 32'h00001000;
        #10;
        $display("Test PC_NEXT: Expected: %h, Got: %h", pc_next, write_data);
        
        // Test case 5: Default case
        wb_sel = 2'b11; // Invalid value
        #10;
        $display("Test DEFAULT: Expected: %h, Got: %h", 32'h0, write_data);
        
        #10 $finish;
    end
endmodule