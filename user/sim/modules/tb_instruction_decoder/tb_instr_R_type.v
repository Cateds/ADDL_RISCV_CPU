`timescale 1ns/1ps
`include "../../../inc/alu_opcode.v"

module instr_decoder_R_tb();
    // Test signals
    reg [31:0] instruction;
    wire [3:0] alu_op;
    wire [4:0] rd, rs1, rs2;

    // Instantiate DUT
    instr_decoder_R dut(
        .instruction(instruction),
        .alu_op(alu_op),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2)
    );

    // For waveform generation
    initial begin
        $dumpfile("instr_decoder_R_tb.vcd");
        $dumpvars(0, instr_decoder_R_tb);
        
        // Test ADD: func3=000, func7=0000000
        instruction = 32'b00000000000100010000000110110011;  // add x3, x2, x1
        #10;
        $display("ADD test - Expected ALU_op: %b, Got: %b", `ALU_ADD, alu_op);
        $display("Registers - rd: %d, rs1: %d, rs2: %d", rd, rs1, rs2);

        // Test SUB: func3=000, func7=0100000
        instruction = 32'b01000000000100010000000110110011;  // sub x3, x2, x1
        #10;
        $display("SUB test - Expected ALU_op: %b, Got: %b", `ALU_SUB, alu_op);
        
        // Test SLL: func3=001
        instruction = 32'b00000000000100010001000110110011;  // sll x3, x2, x1
        #10;
        $display("SLL test - Expected ALU_op: %b, Got: %b", `ALU_SLL, alu_op);
        
        // Test XOR: func3=100
        instruction = 32'b00000000000100010100000110110011;  // xor x3, x2, x1
        #10;
        $display("XOR test - Expected ALU_op: %b, Got: %b", `ALU_XOR, alu_op);
        
        // Test SRL: func3=101, func7=0000000
        instruction = 32'b00000000000100010101000110110011;  // srl x3, x2, x1
        #10;
        $display("SRL test - Expected ALU_op: %b, Got: %b", `ALU_SRL, alu_op);
        
        // Test SRA: func3=101, func7=0100000
        instruction = 32'b01000000000100010101000110110011;  // sra x3, x2, x1
        #10;
        $display("SRA test - Expected ALU_op: %b, Got: %b", `ALU_SRA, alu_op);
        
        // Test OR: func3=110
        instruction = 32'b00000000000100010110000110110011;  // or x3, x2, x1
        #10;
        $display("OR test - Expected ALU_op: %b, Got: %b", `ALU_OR, alu_op);
        
        // Test AND: func3=111
        instruction = 32'b00000000000100010111000110110011;  // and x3, x2, x1
        #10;
        $display("AND test - Expected ALU_op: %b, Got: %b", `ALU_AND, alu_op);

        #10 $finish;
    end
endmodule