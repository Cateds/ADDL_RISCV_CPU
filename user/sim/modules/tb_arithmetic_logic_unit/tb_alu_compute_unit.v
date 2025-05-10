`timescale 1ns/1ps
`ifndef ALU_OPCODE_V
`define ALU_OPCODE_V
        // ALU opcode definitions
`define ALU_ADD   4'b0001
`define ALU_SUB   4'b0010
`define ALU_AND   4'b0100
`define ALU_OR    4'b0101
`define ALU_XOR   4'b0110
`define ALU_SLL   4'b1000
`define ALU_SRL   4'b1001
`define ALU_SRA   4'b1010
`define ALU_SLT   4'b1100
`define ALU_SLTU  4'b1101
`define ALU_NOP   4'b1111
`endif

module tb_alu_compute_unit;

    // Inputs
    reg [31:0] alu_data_1;
    reg [31:0] alu_data_2;
    reg [3:0] alu_op;

    // Output
    wire [31:0] alu_result;

    // Instantiate DUT
    alu_compute_unit uut (
        .alu_data_1(alu_data_1),
        .alu_data_2(alu_data_2),
        .alu_op(alu_op),
        .alu_result(alu_result)
    );

    // Waveform dump
    initial begin
        $dumpfile("tb_alu_compute_unit.vcd");
        $dumpvars(0, tb_alu_compute_unit);
    end

    // Main test sequence
    initial begin
        // Initialize all inputs
        alu_data_1 = 32'd0;
        alu_data_2 = 32'd0;
        alu_op = `ALU_NOP;
        #20; // Initial delay
        
        // Phase 1: Test all operations with fixed data
        alu_data_1 = 32'd25;
        alu_data_2 = 32'd7;
        #10;
        
        alu_op = `ALU_ADD; #20;
        $display("Time %0t: OP=ADD, A=25, B=7 => Result=%d", $time, alu_result);
        
        alu_op = `ALU_SUB; #20;
        $display("Time %0t: OP=SUB, A=25, B=7 => Result=%d", $time, alu_result);
        
        alu_op = `ALU_AND; #20;
        $display("Time %0t: OP=AND, A=25, B=7 => Result=%d", $time, alu_result);
        
        alu_op = `ALU_OR; #20;
        $display("Time %0t: OP=OR, A=25, B=7 => Result=%d", $time, alu_result);
        
        alu_op = `ALU_XOR; #20;
        $display("Time %0t: OP=XOR, A=25, B=7 => Result=%d", $time, alu_result);
        
        alu_op = `ALU_SLL; #20;
        $display("Time %0t: OP=SLL, A=25, B=7 => Result=%d", $time, alu_result);
        
        alu_op = `ALU_SRL; #20;
        $display("Time %0t: OP=SRL, A=25, B=7 => Result=%d", $time, alu_result);
        
        alu_op = `ALU_SRA; #20;
        $display("Time %0t: OP=SRA, A=25, B=7 => Result=%d", $time, alu_result);
        
        alu_op = `ALU_SLT; #20;
        $display("Time %0t: OP=SLT, A=25, B=7 => Result=%d", $time, alu_result);
        
        alu_op = `ALU_SLTU; #20;
        $display("Time %0t: OP=SLTU, A=25, B=7 => Result=%d", $time, alu_result);
        
        // Phase 2: Vary data1 while holding operation and data2
        alu_op = `ALU_ADD;
        #10;
        
        alu_data_1 = 32'd100; #20;
        $display("Time %0t: OP=ADD, A=100, B=7 => Result=%d", $time, alu_result);
        
        alu_data_1 = 32'hFFFF_FFFF; #20;
        $display("Time %0t: OP=ADD, A=FFFF_FFFF, B=7 => Result=%h", $time, alu_result);
        
        alu_data_1 = -32'd50; #20;
        $display("Time %0t: OP=ADD, A=-50, B=7 => Result=%d", $time, alu_result);
        
        // Phase 3: Vary data2 while holding operation and data1
        alu_data_1 = 32'd50;
        #10;
        
        alu_data_2 = 32'd0; #20;
        $display("Time %0t: OP=ADD, A=50, B=0 => Result=%d", $time, alu_result);
        
        alu_data_2 = 32'd50; #20;
        $display("Time %0t: OP=ADD, A=50, B=50 => Result=%d", $time, alu_result);
        
        alu_data_2 = -32'd25; #20;
        $display("Time %0t: OP=ADD, A=50, B=-25 => Result=%d", $time, alu_result);
        
        // Phase 4: Test edge cases for each operation
        alu_op = `ALU_SUB; #10;
        alu_data_1 = 32'h7FFF_FFFF; alu_data_2 = 32'h8000_0000; #20;
        $display("Time %0t: OP=SUB, A=7FFF_FFFF, B=8000_0000 => Result=%h", $time, alu_result);
        
        alu_op = `ALU_AND; #10;
        alu_data_1 = 32'h1234_5678; alu_data_2 = 32'h8765_4321; #20;
        $display("Time %0t: OP=AND, A=1234_5678, B=8765_4321 => Result=%h", $time, alu_result);
        
        alu_op = `ALU_SRA; #10;
        alu_data_1 = 32'h8000_0000; alu_data_2 = 32'd4; #20;
        $display("Time %0t: OP=SRA, A=8000_0000, B=4 => Result=%h", $time, alu_result);
        
        alu_op = `ALU_SLT; #10;
        alu_data_1 = 32'h8000_0000; alu_data_2 = 32'd0; #20;
        $display("Time %0t: OP=SLT, A=8000_0000, B=0 => Result=%d", $time, alu_result);
        
        // Phase 5: Random tests with staggered changes
        alu_op = `ALU_ADD; #10;
        alu_data_1 = $random; alu_data_2 = $random; #20;
        $display("Time %0t: OP=ADD, A=%h, B=%h => Result=%h", $time, alu_data_1, alu_data_2, alu_result);
        
        alu_op = `ALU_XOR; #10;
        alu_data_1 = $random; #20;
        $display("Time %0t: OP=XOR, A=%h, B=%h => Result=%h", $time, alu_data_1, alu_data_2, alu_result);
        
        alu_data_2 = $random; #10;
        alu_op = `ALU_OR; #20;
        $display("Time %0t: OP=OR, A=%h, B=%h => Result=%h", $time, alu_data_1, alu_data_2, alu_result);
        
        $finish;
    end

endmodule