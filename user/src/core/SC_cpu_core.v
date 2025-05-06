module SC_cpu_core(
        // * Clock Sync Signals Connection --------------------
        input clk,
        input rst_n,

        // * External Signals Connection --------------------
        // ----- Instruction Memory -----
        output [31:0] rom_addr,
        input [31:0] rom_data,
        // ----- Bus / Memory Access -----
        output bus_re,
        output [3:0] bus_we,
        output [31:0] bus_addr,
        output [31:0] bus_wdata,
        input [31:0] bus_rdata
    );


    // * Argument Declaration --------------------
    // ----- Instruction Fetch -----
    wire [31:0]     IF_pc;
    wire [31:0]     IF_pc_next;
    wire [31:0]     IF_instruction;
    // ----- Instruction Decode -----
    wire [31:0]      ID_immediate;
    wire [31:0]      ID_rs1_data;
    wire [31:0]      ID_rs2_data;
    wire [3:0]       ID_alu_op;
    wire [2:0]       ID_cmp_op;
    wire [4:0]       ID_rd;
    wire             ID_reg_we;
    wire             ID_alu_data1_sel;
    wire             ID_alu_data2_sel;
    wire [1:0]       ID_mem_op;
    wire [2:0]       ID_mem_sel;
    wire [1:0]       ID_wb_sel;
    wire             ID_branch_jump;
    wire [31:0]     ID_pca_result;
    wire [31:0]     ID_pc;
    wire [31:0]     ID_pc_next;
    // ----- Execute Unit -----
    wire [31:0]      EX_alu_result;
    wire [1:0]       EX_branch;
    wire [31:0]     EX_pc_next;
    wire [1:0]      EX_mem_op;
    wire [2:0]      EX_mem_sel;
    wire [1:0]      EX_wb_sel;
    wire [4:0]      EX_rd;
    wire            EX_reg_we;
    wire [31:0]     EX_pca_result;
    wire [31:0]     EX_rs2_data;
    wire [31:0]     EX_immediate;
    // ----- Memory Operation -----
    wire [31:0]     MEM_mem_rdata;
    wire [1:0]      MEM_wb_sel;
    wire [31:0]     MEM_alu_result;
    wire [31:0]     MEM_immediate;
    wire [31:0]     MEM_pc_next;
    wire [4:0]      MEM_rd;
    wire            MEM_reg_we;
    // ----- Write Back -----
    wire [31:0]     WB_wb_data;
    wire [4:0]      WB_rd;
    wire            WB_reg_we;


    // * Submodule Instantiation --------------------

    SC_instruction_fetch
        u_instruction_fetch(
            // * Clock Sync ----------
            .clk             	(clk),
            .rst_n           	(rst_n),
            .en             	(1'b1),
            // * Internal ----------
            .branch          	(EX_branch),
            .alu_result      	(EX_alu_result),
            .pc_adder_result 	(EX_pca_result),
            .pc              	(IF_pc),
            .pc_next         	(IF_pc_next),
            .instruction     	(IF_instruction),
            // * External ----------
            .rom_addr        	(rom_addr),
            .rom_data        	(rom_data)
        );

    SC_instruction_decode
        u_instruction_decode(
            // * Clock Sync ----------
            .clk             	(clk),
            .rst_n           	(rst_n),
            // * Internal ----------
            .pc           	    (IF_pc),
            .instruction     	(IF_instruction),
            .immediate       	(ID_immediate),
            .rs1_data        	(ID_rs1_data),
            .rs2_data        	(ID_rs2_data),
            .alu_op          	(ID_alu_op),
            .cmp_op          	(ID_cmp_op),
            .rd              	(ID_rd),
            .reg_we          	(ID_reg_we),
            .alu_data1_sel   	(ID_alu_data1_sel),
            .alu_data2_sel   	(ID_alu_data2_sel),
            .mem_op          	(ID_mem_op),
            .mem_sel         	(ID_mem_sel),
            .wb_sel          	(ID_wb_sel),
            .branch_jump        (ID_branch_jump),
            .pc_adder_result 	(ID_pca_result),
            .wb_rd           	(WB_rd),
            .wb_reg_we       	(WB_reg_we),
            .wb_data         	(WB_wb_data),
            // * Previous Stage ----------
            .pc_out          	(ID_pc),
            .pc_next_in      	(IF_pc_next),
            .pc_next_out     	(ID_pc_next)
        );

    SC_execute
        u_execute(
            // * Clock Sync ----------
            .clk           	        (clk),
            .rst_n         	        (rst_n),
            // * Internal ----------
            .rs1_data      	        (ID_rs1_data),
            .rs2_data      	        (ID_rs2_data),
            .immediate     	        (ID_immediate),
            .pc            	        (ID_pc),
            .alu_op        	        (ID_alu_op),
            .alu_data1_sel 	        (ID_alu_data1_sel),
            .alu_data2_sel 	        (ID_alu_data2_sel),
            .alu_result    	        (EX_alu_result),
            .cmp_op        	        (ID_cmp_op),
            .branch_jump       	    (ID_branch_jump),
            .branch        	        (EX_branch),
            // * Previous Stage ----------
            .pc_next_in    	        (ID_pc_next),
            .pc_next_out   	        (EX_pc_next),
            .mem_op_in     	        (ID_mem_op),
            .mem_op_out    	        (EX_mem_op),
            .mem_sel_in    	        (ID_mem_sel),
            .mem_sel_out   	        (EX_mem_sel),
            .wb_sel_in     	        (ID_wb_sel),
            .wb_sel_out    	        (EX_wb_sel),
            .rd_in         	        (ID_rd),
            .rd_out        	        (EX_rd),
            .reg_we_in     	        (ID_reg_we),
            .reg_we_out    	        (EX_reg_we),
            .pc_adder_result_in	    (ID_pca_result),
            .pc_adder_result_out    (EX_pca_result),
            .rs2_data_out           (EX_rs2_data),
            .immediate_out          (EX_immediate)
        );

    SC_memory_access
        u_memory_access(
            // * Clock Sync ----------
            .clk            	(clk),
            .rst_n          	(rst_n),
            // * Internal ----------
            .mem_op         	(EX_mem_op),
            .mem_sel        	(EX_mem_sel),
            .alu_result     	(EX_alu_result),
            .rs2_data       	(EX_rs2_data),
            .mem_rdata      	(MEM_mem_rdata),
            // * Previous Stage ----------
            .wb_sel_in          (EX_wb_sel),
            .wb_sel_out         (MEM_wb_sel),
            .alu_result_out     (MEM_alu_result),
            .immediate_in       (EX_immediate),
            .immediate_out      (MEM_immediate),
            .pc_next_in         (EX_pc_next),
            .pc_next_out        (MEM_pc_next),
            .rd_in              (EX_rd),
            .rd_out             (MEM_rd),
            .reg_we_in          (EX_reg_we),
            .reg_we_out         (MEM_reg_we),
            // * External ----------
            .bus_re         	(bus_re),
            .bus_we         	(bus_we),
            .bus_addr       	(bus_addr),
            .bus_wdata      	(bus_wdata),
            .bus_rdata      	(bus_rdata)
        );

    SC_write_back
        u_write_back(
            // * Clock Sync ----------
            .clk        	(clk),
            .rst_n      	(rst_n),
            // * Internal ----------
            .wb_sel     	(MEM_wb_sel),
            .alu_result 	(MEM_alu_result),
            .immediate  	(MEM_immediate),
            .mem_data   	(MEM_mem_rdata),
            .pc_next    	(MEM_pc_next),
            .write_data 	(WB_wb_data),
            // * Previous Stage ----------
            .rd_in      	(MEM_rd),
            .rd_out     	(WB_rd),
            .reg_we_in  	(MEM_reg_we),
            .reg_we_out 	(WB_reg_we)
        );
endmodule
