module SC_memory_access(
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
        // ----- Previous Stage Signals -----
        input wire [1:0] wb_sel_in,
        output wire [1:0] wb_sel_out,
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
        output bus_re,
        output [3:0] bus_we,
        output [31:0] bus_addr,
        output [31:0] bus_wdata,
        input [31:0] bus_rdata
    );

    assign wb_sel_out = wb_sel_in;
    assign alu_result_out = alu_result;
    assign immediate_out = immediate_in;
    assign pc_next_out = pc_next_in;
    assign rd_out = rd_in;
    assign reg_we_out = reg_we_in;

    memory_access_unit
        u_memory_access_unit(
            .mem_op    	(mem_op     ),
            .mem_sel   	(mem_sel    ),
            .mem_addr  	(alu_result   ),
            .mem_wdata 	(rs2_data  ),
            .mem_rdata 	(mem_rdata  ),
            .bus_re    	(bus_re     ),
            .bus_we    	(bus_we     ),
            .bus_addr  	(bus_addr   ),
            .bus_wdata 	(bus_wdata  ),
            .bus_rdata 	(bus_rdata  )
        );

endmodule
