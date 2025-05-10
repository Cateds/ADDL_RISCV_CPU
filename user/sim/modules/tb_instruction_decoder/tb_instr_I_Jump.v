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
module tb_instr_decoder_I_Jump;

    // 输入信号
    reg [31:0] instruction;

    // 输出信号
    wire [3:0] alu_op;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [31:0] immediate;

    // 实例化被测模块
    instr_decoder_I_Jump uut (
        .instruction(instruction),
        .alu_op(alu_op),
        .rd(rd),
        .rs1(rs1),
        .immediate(immediate)
    );
    initial begin
        $dumpfile("tb_instr_I_Jump.vcd");
        $dumpvars(0, tb_instr_decoder_I_Jump);
    end
    // 仿真主程序
    initial begin
        $display("Starting tb_instr_decoder_I_Jump...");
        $dumpfile("tb_instr_decoder_I_Jump.vcd");
        $dumpvars(0, tb_instr_decoder_I_Jump);

        // 测试：JALR x1, 0(x2) — opcode 1100111, func3 000, rs1=x2, rd=x1, imm=0x000
        instruction = 32'b000000000000_00010_000_00001_1100111;
        #10;
        $display("Test 1: rd=%d, rs1=%d, imm=%d, alu_op=%b", rd, rs1, immediate, alu_op);

        // 测试：imm = 0xFFF (负数 -1)
        instruction = 32'b111111111111_00011_000_00010_1100111; // JALR x2, -1(x3)
        #10;
        $display("Test 2: rd=%d, rs1=%d, imm=%d", rd, rs1, immediate);

        // 测试：imm = 0x123, rs1 = 5, rd = 7
        instruction = 32'b000000010010_00101_000_00111_1100111; // JALR x7, 0x123(x5)
        #10;
        $display("Test 3: rd=%d, rs1=%d, imm=%d", rd, rs1, immediate);

        $finish;
    end

endmodule
