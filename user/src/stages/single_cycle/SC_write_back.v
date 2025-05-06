module SC_write_back(
        // * Clkock Sync Signals Connection --------------------
        input wire clk,
        input wire rst_n,

        // * Internal Signals Connection --------------------
        // ----- Write Back Unit -----
        input wire [1:0] wb_sel,
        input wire [31:0] alu_result,
        input wire [31:0] immediate,
        input wire [31:0] mem_data,
        input wire [31:0] pc_next,
        output wire [31:0] write_data,
        // ----- Previous Stage Signals -----
        input wire [4:0] rd_in,
        output wire [4:0] rd_out,
        input wire reg_we_in,
        output wire reg_we_out
    );

    assign rd_out = rd_in;
    assign reg_we_out = reg_we_in;

    write_back_unit
        u_write_back_unit(
            .wb_sel     	(wb_sel      ),
            .alu_result 	(alu_result  ),
            .immediate  	(immediate   ),
            .mem_data   	(mem_data    ),
            .pc_next    	(pc_next     ),
            .write_data 	(write_data  )
        );

endmodule
