`timescale 1ns/1ps
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

module tb_alu;

    // 输入信号
    reg [3:0] alu_op;
    reg d1_sel;
    reg d2_sel;
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;
    reg [31:0] immediate;
    reg [31:0] pc;

    // 输出信号
    wire [31:0] alu_result;

    // DUT 实例化
    alu uut (
        .alu_op(alu_op),
        .d1_sel(d1_sel),
        .d2_sel(d2_sel),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .immediate(immediate),
        .pc(pc),
        .alu_result(alu_result)
    );

    initial begin
        $dumpfile("tb_alu.vcd");
        $dumpvars(0, tb_alu);
    end

    initial begin
   
        // 初始化输入数据
        rs1_data  = 32'h0000_000A;  // 10
        rs2_data  = 32'h0000_0004;  // 4
        immediate = 32'h0000_0003;  // 3
        pc        = 32'h1000_0000;  // 0x10000000

        // 测试 ADD: rs1_data + rs2_data
        alu_op  = `ALU_ADD;
        d1_sel  = 0; // rs1
        d2_sel  = 0; // rs2
        #10;
        $display("ADD: rs1 + rs2 = %h", alu_result);

        // 测试 SUB: pc - immediate
        alu_op  = `ALU_SUB;
        d1_sel  = 1; // pc
        d2_sel  = 1; // imm
        #10;
        $display("SUB: pc - imm = %h", alu_result);

        // 测试 SLL: rs1 << imm
        alu_op  = `ALU_SLL;
        d1_sel  = 0;
        d2_sel  = 1;
        #10;
        $display("SLL: rs1 << imm = %h", alu_result);

        // 测试 SLT: rs1 < imm
        alu_op  = `ALU_SLT;
        rs1_data = -10;
        immediate = 32'd5;
        d1_sel  = 0;
        d2_sel  = 1;
        #10;
        $display("SLT: rs1 < imm = %h", alu_result);

        // 测试 AND: pc & rs2
        alu_op = `ALU_AND;
        d1_sel = 1;
        d2_sel = 0;
        rs2_data = 32'hFFFF000F;
        #10;
        $display("AND: pc & rs2 = %h", alu_result);

        $finish;
    end

endmodule
