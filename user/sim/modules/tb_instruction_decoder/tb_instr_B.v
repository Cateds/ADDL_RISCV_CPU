`timescale 1ns / 1ps
`include "../../../inc/alu_opcode.v"
module tb_instr_decoder_B();

    // 测试信号
    reg [31:0] instruction;
    wire [3:0] alu_op;
    wire [2:0] cmp_op;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [31:0] immediate;

    // 实例化被测试模块
    instr_decoder_B uut (
        .instruction(instruction),
        .alu_op(alu_op),
        .cmp_op(cmp_op),
        .rs1(rs1),
        .rs2(rs2),
        .immediate(immediate)
    );

    initial begin
        // 打开波形文件，文件名为 "instr_decoder_B_tb.vcd"
        $dumpfile("instr_decoder_B_tb.vcd");
        $dumpvars(0, instr_decoder_B_tb); // 显示整个 Testbench 的波形

        // 测试1：BEQ 指令（a == b）
        instruction = 32'h02106063; // opcode=1100011, rs2=00001, rs1=00000, func3=000, imm=组合
        #10;
        $display("Test 1 (BEQ): alu_op = %b, cmp_op = %b, rs1 = %d, rs2 = %d, immediate = %d", alu_op, cmp_op, rs1, rs2, immediate);

        // 测试2：BNE 指令（a != b）
        instruction = 32'h02106163; // func3=001
        #10;
        $display("Test 2 (BNE): alu_op = %b, cmp_op = %b, rs1 = %d, rs2 = %d, immediate = %d", alu_op, cmp_op, rs1, rs2, immediate);

        // 测试3：BLT 指令（a < b）
        instruction = 32'h02106463; // func3=100
        #10;
        $display("Test 3 (BLT): alu_op = %b, cmp_op = %b, rs1 = %d, rs2 = %d, immediate = %d", alu_op, cmp_op, rs1, rs2, immediate);

        // 测试4：BGE 指令（a >= b）
        instruction = 32'h02106563; // func3=101
        #10;
        $display("Test 4 (BGE): alu_op = %b, cmp_op = %b, rs1 = %d, rs2 = %d, immediate = %d", alu_op, cmp_op, rs1, rs2, immediate);

        // 测试5：BLTU 指令（a < b, 无符号）
        instruction = 32'h02106663; // func3=110
        #10;
        $display("Test 5 (BLTU): alu_op = %b, cmp_op = %b, rs1 = %d, rs2 = %d, immediate = %d", alu_op, cmp_op, rs1, rs2, immediate);

        // 测试6：BGEU 指令（a >= b, 无符号）
        instruction = 32'h02106763; // func3=111
        #10;
        $display("Test 6 (BGEU): alu_op = %b, cmp_op = %b, rs1 = %d, rs2 = %d, immediate = %d", alu_op, cmp_op, rs1, rs2, immediate);

        // 测试7：无效指令（测试解码错误情况）
        instruction = 32'hFFFFFFFF;
        #10;
        $display("Test 7 (Invalid): alu_op = %b, cmp_op = %b, rs1 = %d, rs2 = %d, immediate = %d", alu_op, cmp_op, rs1, rs2, immediate);

        // 结束仿真
        $finish;
    end


endmodule
