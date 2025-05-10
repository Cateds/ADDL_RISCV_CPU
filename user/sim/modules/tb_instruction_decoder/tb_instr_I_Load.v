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
module tb_instr_decoder_I_Load;

    // 输入
    reg [31:0] instruction;

    // 输出
    wire [3:0] alu_op;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [31:0] immediate;
    wire [1:0] mem_op;
    wire [2:0] mem_sel;

    // DUT 实例化
    instr_decoder_I_Load uut (
        .instruction(instruction),
        .alu_op(alu_op),
        .rd(rd),
        .rs1(rs1),
        .immediate(immediate),
        .mem_sel(mem_sel),
        .mem_op(mem_op)
    );
    // Waveform dump
    initial begin
        $dumpfile("tb_instr_I_Load.vcd");
        $dumpvars(0, tb_instr_decoder_I_Load);
    end
    // 测试过程
    initial begin
        $display("Starting tb_instr_decoder_I_Load...");
        $dumpfile("tb_instr_decoder_I_Load.vcd");
        $dumpvars(0, tb_instr_decoder_I_Load);

        // 测试 LB (func3 = 000)
        instruction = 32'b000000000100_00001_000_00010_0000011; // LB x2, 4(x1)
        #10;
        $display("LB -> mem_sel = %b, alu_op = %b", mem_sel, alu_op);

        // 测试 LH (func3 = 001)
        instruction = 32'b000000000100_00001_001_00011_0000011; // LH x3, 4(x1)
        #10;
        $display("LH -> mem_sel = %b", mem_sel);

        // 测试 LW (func3 = 010)
        instruction = 32'b000000000100_00001_010_00100_0000011; // LW x4, 4(x1)
        #10;
        $display("LW -> mem_sel = %b", mem_sel);

        // 测试 LBU (func3 = 100)
        instruction = 32'b000000000100_00001_100_00101_0000011; // LBU x5, 4(x1)
        #10;
        $display("LBU -> mem_sel = %b", mem_sel);

        // 测试 LHU (func3 = 101)
        instruction = 32'b000000000100_00001_101_00110_0000011; // LHU x6, 4(x1)
        #10;
        $display("LHU -> mem_sel = %b", mem_sel);

        // 测试非法 func3
        instruction = 32'b000000000100_00001_111_00111_0000011; // unknown
        #10;
        $display("Unknown -> mem_sel = %b", mem_sel);

        $finish;
    end

endmodule
