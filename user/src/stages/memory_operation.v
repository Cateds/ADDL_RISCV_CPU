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


        // * External Signals Connection --------------------
        output wire ram_ce_n,
        output wire ram_we_n,
        output wire ram_oe_n,
        output wire [3:0] ram_byte_en_n,
        output wire [31:0] ram_addr,
        inout wire [31:0] ram_data
    );

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
