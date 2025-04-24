module memory_operation(
        // * Clock Sync Signals Connection --------------------
        input wire clk,
        input wire rst_n,

        // * Internal Signals Connection --------------------
        // ----- Memory Controller -----
        input wire [1:0] mem_op,
        input wire [2:0] mem_sel,
        input wire [31:0] alu_result,
        input wire [31:0] rs2_data,
        output wire [31:0] mem_rdata,
        output wire mem_ready,
        // ----- Previous Stage Signals -----
        input wire [1:0] wb_sel_in,
        output wire [1:0] wb_sel_out,
        input wire [31:0] alu_result_in,
        output wire [31:0] alu_result_out,
        input wire [31:0] immediate_in,
        output wire [31:0] immediate_out,
        input wire [31:0] pc_next_in,
        output wire [31:0] pc_next_out,
        input wire [4:0] rd_in,
        output wire [4:0] rd_out,
        input wire reg_we_in,
        output wire reg_we_out,

        // * External Signals Connection --------------------
        output wire ram_ce_n,
        output wire ram_we_n,
        output wire ram_oe_n,
        output wire [3:0] ram_byte_en_n,
        output wire [31:0] ram_addr,
        inout wire [31:0] ram_data
    );

    assign wb_sel_out = wb_sel_in;
    assign alu_result_out = alu_result_in;
    assign immediate_out = immediate_in;
    assign pc_next_out = pc_next_in;
    assign rd_out = rd_in;
    assign reg_we_out = reg_we_in;

    memory_ctrl
        u_memory_ctrl(
            .mem_op        	(mem_op         ),
            .mem_sel       	(mem_sel        ),
            .mem_addr      	(alu_result     ),
            .mem_wdata     	(rs2_data       ),
            .mem_rdata     	(mem_rdata      ),
            .mem_ready     	(mem_ready      ),
            .ram_ce_n      	(ram_ce_n       ),
            .ram_we_n      	(ram_we_n       ),
            .ram_oe_n      	(ram_oe_n       ),
            .ram_byte_en_n 	(ram_byte_en_n  ),
            .ram_addr      	(ram_addr       ),
            .ram_data      	(ram_data       ),
            .clk           	(clk            ),
            .rst_n         	(rst_n          )
        );

endmodule
