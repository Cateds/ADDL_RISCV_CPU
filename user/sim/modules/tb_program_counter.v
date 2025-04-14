`timescale 1ns/1ps
`include "../../inc/pc_mux.v"

module tb_program_counter();
    // 定义测试信号
    reg [1:0] branch;
    reg en;
    reg clk;
    reg rst_n;
    reg [31:0] alu_result;
    reg [31:0] pc_adder_result;
    wire [31:0] pc;
    wire [31:0] pc_next;
    
    // 期望输出
    reg [31:0] expected_pc;
    
    // 实例化被测模块
    program_counter dut(
        .branch(branch),
        .en(en),
        .clk(clk),
        .rst_n(rst_n),
        .alu_result(alu_result),
        .pc_adder_result(pc_adder_result),
        .pc(pc),
        .pc_next(pc_next)
    );
    
    // 生成时钟信号
    always #5 clk = ~clk;
    
    // 初始化测试
    initial begin
        // 打开波形文件
        $dumpfile("tb_program_counter.vcd");
        $dumpvars(0, tb_program_counter);
        
        // 初始化信号
        clk = 0;
        rst_n = 0;
        en = 1;
        branch = 2'b00;  // 默认PC+4
        alu_result = 32'h1000;
        pc_adder_result = 32'h2000;
        expected_pc = 32'h0;  // 复位后PC应为0
        
        // 检查复位状态
        #10;
        rst_n = 1;
        check_result("复位后状态");
        
        // 测试默认情况 (PC+4)
        #10;
        expected_pc = 32'h4;  // PC应该增加4
        check_result("默认PC+4");
        
        // 测试ALU输出
        #10;
        branch = `PC_MUX_ALU_OUT;
        expected_pc = alu_result;
        check_result("ALU输出选择");
        
        // 测试PC_ADDER输出
        #10;
        branch = `PC_MUX_PC_ADDER;
        expected_pc = pc_adder_result;
        check_result("PC_ADDER输出选择");
        
        // 测试禁用状态
        #10;
        en = 0;
        branch = 2'b00;  // 默认PC+4
        #10;
        check_result("禁用状态 (PC不应变化)");
        
        // 恢复启用状态
        #10;
        en = 1;
        #10;
        expected_pc = pc + 4;
        check_result("恢复启用状态");
        
        // 结束仿真
        #10;
        $display("测试完成!");
        $finish;
    end
    
    // 检查结果
    task check_result;
        input [100:0] test_case;
        begin
            #1; // 等待PC更新
            $display("测试用例: %s", test_case);
            $display("时间 = %0t, PC实际值 = %h, PC期望值 = %h, PC_NEXT = %h", 
                     $time, pc, expected_pc, pc_next);
            if (pc !== expected_pc) begin
                $display("错误: 期望PC = %h, 实际PC = %h", expected_pc, pc);
            end else begin
                $display("测试通过");
            end
            $display("-----------------------");
        end
    endtask

endmodule
