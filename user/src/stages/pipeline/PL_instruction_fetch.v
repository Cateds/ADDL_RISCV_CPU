module PL_instruction_fetch(
        // * Clock Sync Signals Connection --------------------
        input clk,
        input rst_n,
        input en,

        // * Pipeline Signals Connection --------------------
        input stall,
        input flush,

        // * Internal Signals Connection --------------------
        input [1:0] branch,
        input [31:0] alu_result,
        input [31:0] pc_adder_result,

        output [31:0] pc,
        output [31:0] pc_next,
        output [31:0] instruction,

        // * External Signals Connection --------------------
        output  [31:0] rom_addr,
        input  [31:0] rom_data
    );

    // output declaration of module program_counter
    program_counter
        u_program_counter(
            .branch          	(branch           ),
            .en              	(en               ),
            .clk             	(clk              ),
            .rst_n           	(rst_n            ),
            .alu_result      	(alu_result       ),
            .pc_adder_result 	(pc_adder_result  ),
            .pc              	(pc               ),
            .pc_next         	(pc_next          )
        );

    assign rom_addr = pc; // PC作为ROM的地址
    assign instruction = rom_data; // 从ROM中读取指令
endmodule
