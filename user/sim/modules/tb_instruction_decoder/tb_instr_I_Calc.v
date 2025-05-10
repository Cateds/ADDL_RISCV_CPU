`timescale 1ns/1ps
`include "../../../inc/memory_select.v"
`include "../../../inc/memory_opcode.v"


`ifndef ALU_OPCODE_V
`define ALU_OPCODE_V

        // ALU 操作码常量定义
`define ALU_ADD   4'b0001  // 加法操作
`define ALU_SUB   4'b0010  // 减法操作
`define ALU_AND   4'b0100  // 逻辑与
`define ALU_OR    4'b0101  // 逻辑或
`define ALU_XOR   4'b0110  // 异或操作
`define ALU_SLL   4'b1000  // 逻辑左移
`define ALU_SRL   4'b1001  // 逻辑右移
`define ALU_SRA   4'b1010  // 算术右移
`define ALU_SLT   4'b1100  // 有符号比较，小于时置位
`define ALU_SLTU  4'b1101  // 无符号比较，小于时置位
`define ALU_NOP   4'b1111  // 无操作 (保留此定义，文档中未指定)

`define ALU_CMP_EQ  3'b000  // 比较操作，相等时置位
`define ALU_CMP_NE  3'b001  // 比较操作，不等时置位
`define ALU_CMP_LT  3'b100  // 比较操作，小于时置位
`define ALU_CMP_GE  3'b101  // 比较操作，大于等于时置位
`define ALU_CMP_LTU 3'b110  // 比较操作，无符号小于时置位
`define ALU_CMP_GEU 3'b111  // 比较操作，无符号大于等于时置位
`define ALU_CMP_NOP 3'b011  // 无操作 (保留此定义，文档中未指定)

`endif

module tb_instr_decoder_I_Calc;

    reg [31:0] instruction;
    wire [3:0] alu_op;
    wire [4:0] rd, rs1;
    wire [31:0] immediate;

    // 实例化待测模块
    instr_decoder_I_Calc uut (
        .instruction(instruction),
        .alu_op(alu_op),
        .rd(rd),
        .rs1(rs1),
        .immediate(immediate)
    );
    // Waveform dump
    initial begin
        $dumpfile("tb_instr_I_Calc.vcd");
        $dumpvars(0, tb_instr_decoder_I_Calc);
    end

    initial begin
        $display("Time\tInstruction\t\tALU_OP\tRD\tRS1\tImmediate");
        $monitor("%0dns\t%h\t%b\t%0d\t%0d\t%0d", $time, instruction, alu_op, rd, rs1, immediate);

        // 测试 ADDI (func3 = 000)
        instruction = 32'b000000000101_00001_000_00010_0010011; // addi x2, x1, 5
        #10;

        // 测试 SLTI (func3 = 010)
        instruction = 32'b000000000101_00001_010_00011_0010011; // slti x3, x1, 5
        #10;

        // 测试 SLTIU (func3 = 011)
        instruction = 32'b000000000101_00001_011_00100_0010011; // sltiu x4, x1, 5
        #10;

        // 测试 XORI (func3 = 100)
        instruction = 32'b000000000101_00001_100_00101_0010011; // xori x5, x1, 5
        #10;

        // 测试 ORI (func3 = 110)
        instruction = 32'b000000000101_00001_110_00110_0010011; // ori x6, x1, 5
        #10;

        // 测试 ANDI (func3 = 111)
        instruction = 32'b000000000101_00001_111_00111_0010011; // andi x7, x1, 5
        #10;

        // 测试 SLLI (func3 = 001, func7 = 0000000)
        instruction = 32'b0000000_00101_00001_001_01000_0010011; // slli x8, x1, 5
        #10;

        // 测试 SRLI (func3 = 101, func7 = 0000000)
        instruction = 32'b0000000_00101_00001_101_01001_0010011; // srli x9, x1, 5
        #10;

        // 测试 SRAI (func3 = 101, func7 = 0100000)
        instruction = 32'b0100000_00101_00001_101_01010_0010011; // srai x10, x1, 5
        #10;

        // 测试未知 func3 (例如001, 无对应定义)
        instruction = 32'b000000000101_00001_001_01011_0010011; // 未知 func3，应该输出 ALU_NOP
        #10;

        $finish;
    end

endmodule
