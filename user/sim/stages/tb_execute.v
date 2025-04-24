`timescale 1ns/1ps
`include "../test_utils.vh"

module tb_execute();

    ALU_OP_ENUM     alu_op_enum();
    ALU_MUX_ENUM    alu_mux_enum();
    ALU_CMP_OP_ENUM cmp_op_enum();
    PC_MUX_ENUM     pc_mux_enum();

    // * 定义测试信号 ----------
    // ----- Clock -----
    reg clk;
    reg rst_n;
    // ----- Internal -----
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;
    reg [31:0] immediate;
    reg [31:0] pc;
    reg [3:0] alu_op;
    reg [2:0] cmp_op;
    reg alu_data1_sel;
    reg alu_data2_sel;
    reg branch_jump;

    // * 期望输出信号 ----------
    reg [31:0] expected_alu_result;
    reg [1:0] expected_branch;

    // * 实际输出信号 ---------
    reg [31:0] alu_result;
    reg [1:0] branch;

    execute
        u_execute(
            .clk                 	(clk                  ),
            .rst_n               	(rst_n                ),
            .rs1_data            	(rs1_data             ),
            .rs2_data            	(rs2_data             ),
            .immediate           	(immediate            ),
            .pc                  	(pc                   ),
            .alu_op              	(alu_op               ),
            .alu_data1_sel       	(alu_data1_sel        ),
            .alu_data2_sel       	(alu_data2_sel        ),
            .alu_result          	(alu_result           ),
            .cmp_op              	(cmp_op               ),
            .branch_jump            (branch_jump          ),
            .branch              	(branch               )
        );

    task check_result;
        parameter BUFFER_LEN = 128;
        input [BUFFER_LEN*8-1:0] description;
        begin
            #1;
            $display("Test: %0s (@time: %0t)", description, $time);
            `PRINT_TEST_BIN("ALU Result", alu_result, expected_alu_result);
            `PRINT_TEST_BIN("Branch", branch, expected_branch);
        end
    endtask

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_execute.vcd");
        $dumpvars(0, tb_execute);
        // * ----- Initialize -----
        clk = 0;
        rst_n = 0;
        alu_data1_sel = alu_mux_enum.D1_RS1;
        alu_data2_sel = alu_mux_enum.D2_RS2;
        rs1_data = 32'd100;
        rs2_data = 32'd4;
        immediate = 32'd10;
        pc = 32'd20;
        alu_op = alu_op_enum.NOP;
        cmp_op = cmp_op_enum.NOP;
        branch_jump = 0;
        expected_branch = pc_mux_enum.NOP;

        // * =============== ALU Test ===============
        $display("=============== ALU 指令响应 ===============");
        #10;
        rst_n = 1;

        // * ----- rs1_data + rs2_data -----
        alu_op = alu_op_enum.ADD;
        expected_alu_result = rs1_data + rs2_data;
        check_result("rs1_data + rs2_data");

        #10;
        // * ----- rs1_data - rs2_data -----
        alu_op = alu_op_enum.SUB;
        expected_alu_result = rs1_data - rs2_data;
        check_result("rs1_data - rs2_data");

        #10;
        // * ----- rs1_data & rs2_data -----
        alu_op = alu_op_enum.AND;
        expected_alu_result = rs1_data & rs2_data;
        check_result("rs1_data & rs2_data");

        #10;
        // * ----- rs1_data | rs2_data -----
        alu_op = alu_op_enum.OR;
        expected_alu_result = rs1_data | rs2_data;
        check_result("rs1_data | rs2_data");

        #10;
        // * ----- rs1_data ^ rs2_data -----
        alu_op = alu_op_enum.XOR;
        expected_alu_result = rs1_data ^ rs2_data;
        check_result("rs1_data ^ rs2_data");

        #10;
        // * ----- rs1_data << rs2_data -----
        alu_op = alu_op_enum.SLL;
        expected_alu_result = rs1_data << rs2_data;
        check_result("rs1_data << rs2_data");

        #10;
        // * ----- rs1_data >> rs2_data -----
        alu_op = alu_op_enum.SRL;
        expected_alu_result = rs1_data >> rs2_data;
        check_result("rs1_data >> rs2_data");

        #10;
        // * ----- rs1_data >>> rs2_data -----
        alu_op = alu_op_enum.SRA;
        expected_alu_result = rs1_data >>> rs2_data;
        check_result("rs1_data >>> rs2_data");

        #10;
        // * ----- (unsigned)rs1_data < (unsigned)rs2_data -----
        alu_op = alu_op_enum.SLTU;
        expected_alu_result = (rs1_data < rs2_data) ? 32'd1 : 32'd0;
        check_result("(unsigned) rs1_data < rs2_data");

        #10;
        // * ----- (signed)rs1_data < (signed)rs2_data -----
        alu_op = alu_op_enum.SLT;
        expected_alu_result = ($signed(rs1_data) < $signed(rs2_data)) ? 32'd1 : 32'd0;
        check_result("(signed) rs1_data < rs2_data");

        // * =============== ALU MUX Test ===============
        #10;
        alu_op = alu_op_enum.ADD;
        $display("=============== ALU MUX 指令响应 ===============");

        // * ----- rs1_data + immediate -----
        alu_data1_sel = alu_mux_enum.D1_RS1;
        alu_data2_sel = alu_mux_enum.D2_IMM;
        expected_alu_result = rs1_data + immediate;
        check_result("rs1_data + immediate");

        #10;
        // * ----- pc + immediate -----
        alu_data1_sel = alu_mux_enum.D1_PC;
        alu_data2_sel = alu_mux_enum.D2_IMM;
        expected_alu_result = pc + immediate;
        check_result("pc + immediate");

        #10;
        // * ----- pc + rs2_data -----
        alu_data1_sel = alu_mux_enum.D1_PC;
        alu_data2_sel = alu_mux_enum.D2_RS2;
        expected_alu_result = pc + rs2_data;
        check_result("pc + rs2_data");

        #10;
        $display("测试完成");
        $finish();
    end

endmodule
