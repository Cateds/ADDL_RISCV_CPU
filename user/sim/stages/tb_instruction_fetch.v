`timescale 1ns/1ps
`include "../test_utils.vh"

module tb_instruction_fetch();

    PC_MUX_ENUM pc_mux_enum();

    // 定义测试信号
    reg clk;
    reg rst_n;
    reg [1:0] branch;
    reg [31:0] alu_result;
    reg [31:0] pc_adder_result;

    // 期望信号值
    reg [31:0] expected_pc;
    wire [31:0] expected_pc_next;
    wire [31:0] expected_instruction;

    // 输出信号值
    wire [31:0] pc;
    wire [31:0] pc_next;
    wire [31:0] instruction;
    wire [31:0] rom_addr;

    // 内部连接
    wire [31:0] rom_data;

    SC_instruction_fetch
        u_if(
            .clk             	(clk              ),
            .rst_n           	(rst_n            ),
            .en                 (1'b1             ),
            .branch          	(branch           ),
            .alu_result      	(alu_result       ),
            .pc_adder_result 	(pc_adder_result  ),
            .pc              	(pc               ),
            .pc_next         	(pc_next          ),
            .instruction     	(instruction      ),
            .rom_addr        	(rom_addr         ),
            .rom_data        	(rom_data         )
        );

    blk_mem_ROM
        connected_rom(
            .clka 	(~clk  ),
            .addra 	(rom_addr  ),
            .douta 	(rom_data  )
        );

    blk_mem_ROM
        expected_rom(
            .clka 	(~clk  ),
            .addra 	(expected_pc  ),
            .douta 	(expected_instruction  )
        );


    task check_result;
        parameter BUFFER_LEN = 128;
        input [BUFFER_LEN*8-1:0] description;
        begin
            $display("Test: %0s (@time: %0t)", description, $time);
            `PRINT_TEST_HEX("PC", pc, expected_pc);
            `PRINT_TEST_HEX("PC Next", pc_next, expected_pc_next);
            `PRINT_TEST_HEX("Instruction", instruction, expected_instruction);
        end
    endtask

    always #5 clk = ~clk;

    assign expected_pc_next = pc + 4;

    initial begin
        $dumpfile("tb_instruction_fetch.vcd");
        $dumpvars(0, tb_instruction_fetch);
        clk = 0;
        rst_n = 0;
        branch = pc_mux_enum.NOP;
        pc_adder_result = 128;
        alu_result = 192;
        expected_pc = 0;

        // * ----- Reset -----
        #19
         check_result("Initial State");

        // * ----- Self Added -----
        rst_n = 1;
        #10;
        expected_pc = expected_pc + 4;
        #1;
        check_result("Normal (+4)");

        #9;
        expected_pc = expected_pc + 4;
        #1;
        check_result("Normal (+4)");

        // * ----- Branch to PC Adder Value -----
        branch = pc_mux_enum.PC_ADDER;
        #9;
        expected_pc = pc_adder_result;
        #1;
        check_result("Branch to PC_ADDER");

        branch = pc_mux_enum.NOP;
        #9;
        expected_pc = expected_pc + 4;
        #1;
        check_result("Normal (+4)");

        branch = pc_mux_enum.ALU_OUT;
        #9;
        expected_pc = alu_result;
        #1;
        check_result("Jump to ALU_OUT");

        branch = pc_mux_enum.NOP;
        #9;
        expected_pc = expected_pc + 4;
        #1;
        check_result("Normal (+4)");

        branch = pc_mux_enum.NOP;
        #9;
        expected_pc = expected_pc + 4;
        #1;
        check_result("Normal (+4)");

        #10;
        // * ----- End -----
        $display("Simulation finished.");
        $finish;
    end

endmodule
