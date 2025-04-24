`timescale 1ns/1ps
`include "../test_utils.vh"

module tb_program_counter();

    PC_MUX_ENUM pc_mux_enum();

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
    program_counter
        dut(
            .branch(branch),
            .en(en),
            .clk(clk),
            .rst_n(rst_n),
            .alu_result(alu_result),
            .pc_adder_result(pc_adder_result),
            .pc(pc),
            .pc_next(pc_next)
        );

    task check_result;
        parameter BUFFER_LEN = 128;
        input [BUFFER_LEN*8-1:0] description;
        begin
            $display("Test: %0s (@time: %0t)", description, $time);
            `PRINT_TEST_HEX("PC", pc, expected_pc);
            `PRINT_TEST_HEX("PC Next", pc_next, expected_pc + 4);
        end
    endtask

    // 生成时钟信号
    always #5 clk = ~clk;

    // 初始化测试
    initial begin
        // 打开波形文件
        $dumpfile("tb_program_counter.vcd");
        $dumpvars(0, tb_program_counter);

        clk = 0;
        rst_n = 0;
        en = 1;
        alu_result = 128;
        pc_adder_result = 192;
        branch = pc_mux_enum.NOP;

        #10;
        expected_pc = 0;
        check_result("Initial State");
        
        rst_n = 1;
        #10;
        expected_pc = 4;
        check_result("Normal (+4)");

        #10;
        expected_pc = 8;
        check_result("Normal (+4)");

        branch = pc_mux_enum.PC_ADDER;
        #10;
        expected_pc = pc_adder_result;
        check_result("Branch to PC_ADDER");

        branch = pc_mux_enum.NOP;
        #10;
        expected_pc = expected_pc + 4;
        check_result("Normal (+4)");

        branch = pc_mux_enum.ALU_OUT;
        #10;
        expected_pc = alu_result;
        check_result("Branch to ALU_OUT");

        branch = pc_mux_enum.NOP;
        #10;
        expected_pc = expected_pc + 4;
        check_result("Normal (+4)");

        en = 0;
        #10;
        check_result("Disabled (+0)");

        en = 1;
        #10;
        expected_pc = expected_pc + 4;
        check_result("Enabled (+4)");

        #10;
        $display("Simulation finished.");
        $finish;
    end

    // 检查结果


endmodule
