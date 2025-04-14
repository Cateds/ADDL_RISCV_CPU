`timescale 1ns/1ps

`include "../test_utils.vh"
module tb_write_back();

    // 声明常量实例
    WB_SEL_ENUM wb_sel_enum();

    // 定义测试信号
    reg clk;
    reg rst_n;
    reg [1:0] wb_sel;
    reg [31:0] alu_result;
    reg [31:0] immediate;
    reg [31:0] mem_data;
    reg [31:0] pc_next;
    reg [4:0] rd_in;
    reg reg_we_in;

    // 期望输出
    reg [31:0] expected_write_data;
    reg [4:0] expected_rd_out;
    reg expected_reg_we_out;

    // 实际输出
    wire [31:0] write_data;
    wire [4:0] rd_out;
    wire reg_we_out;

    write_back
        u_write_back(
            .clk        	(clk         ),
            .rst_n      	(rst_n       ),
            .wb_sel     	(wb_sel      ),
            .alu_result 	(alu_result  ),
            .immediate  	(immediate   ),
            .mem_data   	(mem_data    ),
            .pc_next    	(pc_next     ),
            .write_data 	(write_data  ),
            .rd_in      	(rd_in       ),
            .rd_out     	(rd_out      ),
            .reg_we_in  	(reg_we_in   ),
            .reg_we_out 	(reg_we_out  )
        );

    always #5 clk = ~clk;

    task check_result;
        parameter BUFFER_LEN = 128;
        input [BUFFER_LEN*8-1:0] description;
        begin
            #1;
            $display("Test: %0s (@time: %0t)", description, $time);
            `PRINT_TEST_HEX("Write Data", write_data, expected_write_data);
            `PRINT_TEST_HEX("rd", rd_out, rd_in);
            `PRINT_TEST_HEX("reg_we", reg_we_out, reg_we_in);
        end
    endtask

    initial begin
        $dumpfile("tb_write_back.vcd");
        $dumpvars(0, tb_write_back);
        clk = 0;
        rst_n = 0;

        #10;
        rst_n = 1;
        alu_result = 1;
        immediate = 2;
        mem_data = 3;
        pc_next = 4;
        rd_in = 5;
        reg_we_in = 1;
        wb_sel = wb_sel_enum.ALU_OUT;
        expected_write_data = alu_result;
        check_result("WB_ALU_OUT");

        #10;
        wb_sel = wb_sel_enum.IMM_DAT;
        expected_write_data = immediate;
        rd_in = 0;
        check_result("WB_IMM_DAT");

        #10;
        wb_sel = wb_sel_enum.MEM_DAT;
        expected_write_data = mem_data;
        rd_in = 1;
        reg_we_in = 0;
        check_result("WB_MEM_DAT");

        #10;
        wb_sel = wb_sel_enum.PC_NEXT;
        expected_write_data = pc_next;
        rd_in = 0;
        check_result("WB_PC_NEXT");

        #10;
        $display("测试完成");
        $finish;
    end
endmodule
