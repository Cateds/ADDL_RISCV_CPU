module execute(
        // * Clock Sync Signals Connection --------------------
        input wire clk,
        input wire rst_n,

        // * Internal Signals Connection --------------------
        // ----- ALU -----
        input wire [31:0] rs1_data,
        input wire [31:0] rs2_data,
        input wire [31:0] immediate,
        input wire [31:0] pc,
        input wire [3:0] alu_op,
        input wire alu_data1_sel,
        input wire alu_data2_sel,
        output wire [31:0] alu_result,
        // ----- Branch Unit -----
        input wire [2:0] cmp_op,
        input wire branch_jump,
        output wire [1:0] branch,
        // ----- Previous Stage Signals -----
        input wire [31:0] pc_next_in,
        output wire [31:0] pc_next_out,
        input wire [1:0] mem_op_in,
        output wire [1:0] mem_op_out,
        input wire [2:0] mem_sel_in,
        output wire [2:0] mem_sel_out,
        input wire [1:0] wb_sel_in,
        output wire [1:0] wb_sel_out,
        input wire [4:0] rd_in,
        output wire [4:0] rd_out,
        input wire reg_we_in,
        output wire reg_we_out,
        input wire [31:0] pc_adder_result_in,
        output wire [31:0] pc_adder_result_out,
        output wire [31:0] rs2_data_out,
        output wire [31:0] immediate_out
    );

    assign pc_next_out = pc_next_in;
    assign mem_op_out = mem_op_in;
    assign mem_sel_out = mem_sel_in;
    assign wb_sel_out = wb_sel_in;
    assign rd_out = rd_in;
    assign reg_we_out = reg_we_in;
    assign pc_adder_result_out = pc_adder_result_in;
    assign rs2_data_out = rs2_data;
    assign immediate_out = immediate;

    alu u_alu(
            .alu_op     	(alu_op         ),
            .d1_sel     	(alu_data1_sel  ),
            .d2_sel     	(alu_data2_sel  ),
            .rs1_data   	(rs1_data       ),
            .rs2_data   	(rs2_data       ),
            .immediate  	(immediate      ),
            .pc         	(pc             ),
            .alu_result 	(alu_result     )
        );

    branch_unit
        u_branch_unit(
            .alu_result 	(alu_result  ),
            .cmp_opcode 	(cmp_op      ),
            .branch_jump    (branch_jump     ),
            .branch     	(branch      )
        );

endmodule
