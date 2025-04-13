`timescale 1ns / 1ps

module tb_program_counter;

    // 参数定义
    parameter PERIOD = 10;  // 时钟周期 10ns

    // 输入信号定义
    reg branch_enable = 0;
    reg branch_relative = 0;
    reg en = 0;
    reg clk = 0;
    reg rst_n = 0;
    reg [31:0] branch_addr = 0;

    // 输出信号定义
    wire [31:0] pc;
    wire [31:0] pc_next;

    // 生成时钟信号
    initial begin
        forever
            #(PERIOD/2) clk = ~clk;
    end

    // 波形记录
    initial begin
        $dumpfile("tb_program_counter.vcd");
        $dumpvars(0, tb_program_counter);
    end

    // 测试序列
    initial begin
        // 初始化并复位
        rst_n = 0;
        en = 0;
        branch_enable = 0;
        branch_relative = 0;
        branch_addr = 32'h00000000;

        // 释放复位
        #(PERIOD*2) rst_n = 1;

        // 启用计数器
        #PERIOD en = 1;
        #(PERIOD*3);

        // 测试绝对分支跳转1
        branch_enable = 1;
        branch_relative = 0;
        branch_addr = 32'h00001000;
        #PERIOD;
        branch_enable = 0;
        #(PERIOD*3);

        // 测试相对分支跳转
        branch_enable = 1;
        branch_relative = 1;
        branch_addr = 32'h00000100; // 相对地址偏移
        #PERIOD;
        branch_enable = 0;
        #(PERIOD*3);

        // 测试绝对分支跳转2
        branch_enable = 1;
        branch_relative = 0;
        branch_addr = 32'h00002000;
        #PERIOD;
        branch_enable = 0;
        #(PERIOD*3);

        // 测试禁用计数器
        en = 0;
        #(PERIOD*3);

        // 重新启用计数器
        en = 1;
        #(PERIOD*3);

        // 测试复位功能
        rst_n = 0;
        #PERIOD;
        rst_n = 1;
        #(PERIOD*3);

        // 结束仿真
        $display("Simulation finished at time %t", $time);
        $finish;
    end

    // 输出监控
    initial begin
        $monitor("Time=%0t: rst_n=%0b, en=%0b, branch_enable=%0b, branch_relative=%0b, branch_addr=0x%h, pc=0x%h, pc_next=0x%h",
                 $time, rst_n, en, branch_enable, branch_relative, branch_addr, pc, pc_next);
    end

    // 实例化被测模块
    program_counter
        u_program_counter (
            .branch_enable   (branch_enable),
            .branch_is_relative (branch_relative),
            .en              (en),
            .clk             (clk),
            .rst_n           (rst_n),
            .branch_addr     (branch_addr),
            .pc              (pc),
            .pc_next         (pc_next)
        );

endmodule
