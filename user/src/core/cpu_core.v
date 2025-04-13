module cpu_core(
        // * Clock Sync Signals Connection --------------------
        input wire clk,
        input wire rst_n,

        // * External Signals Connection --------------------
        // ----- Instruction Memory -----
        output wire [31:0] rom_addr,
        input wire [31:0] rom_data,
        // ----- Data Memory -----
        output wire ram_ce_n,
        output wire ram_we_n,
        output wire ram_oe_n,
        output wire [3:0] ram_byte_en_n,
        output wire [31:0] ram_addr,
        inout wire [31:0] ram_data
    );


    // * Argument Declaration --------------------
    // ----- Instruction Fetch -----
    wire [31:0]     IF_pc;
    wire [31:0]     IF_pc_next;
    wire [31:0]     IF_instruction;
    // ----- Instruction Decode -----
    reg [31:0]      ID_immediate;
    reg [31:0]      ID_rs1_data;
    reg [31:0]      ID_rs2_data;
    reg [3:0]       ID_alu_op;
    reg [2:0]       ID_cmp_op;
    reg [4:0]       ID_rd;
    reg             ID_reg_we;
    reg             ID_alu_data1_sel;
    reg             ID_alu_data2_sel;
    reg [1:0]       ID_mem_op;
    reg [2:0]       ID_mem_sel;
    reg [1:0]       ID_wb_sel;
    reg             ID_pc_jump;
    wire [31:0]     ID_pc_adder_result;
    wire [31:0]     ID_pc;
    wire [31:0]     ID_pc_next;
    // ----- Execute Unit -----
    reg [31:0]      EX_alu_result;
    reg [1:0]       EX_branch;
    wire [31:0]     EX_pc_next;
    wire [1:0]      EX_mem_op;
    wire [2:0]      EX_mem_sel;
    wire [1:0]      EX_wb_sel;
    wire [4:0]      EX_rd;
    wire            EX_reg_we;
    wire [31:0]     EX_pc_adder_result;
    wire [31:0]     EX_rs2_data;
    wire [31:0]     EX_immediate;
    // ----- Memory Operation -----
    wire [31:0]     MEM_mem_rdata;
    wire            MEM_mem_ready;
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

    instruction_fetch
        u_instruction_fetch(
            // * Clock Sync ----------
            .clk             	(clk),
            .rst_n           	(rst_n),
            // * Internal ----------
            .branch          	(EX_branch),
            .alu_result      	(EX_alu_result),
            .pc_adder_result 	(EX_pc_adder_result),
            .pc              	(IF_pc),
            .pc_next         	(IF_pc_next),
            .instruction     	(IF_instruction),
            // * External ----------
            .rom_addr        	(rom_addr),
            .rom_data        	(rom_data)
        );

    instruction_decode
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
            .pc_jump         	(ID_pc_jump),
            .pc_adder_result 	(ID_pc_adder_result),
            .wb_rd           	(WB_rd),
            .wb_reg_we       	(WB_reg_we),
            .wb_data         	(WB_wb_data),
            // * Previous Stage ----------
            .pc_out          	(ID_pc),
            .pc_next_in      	(IF_pc_next),
            .pc_next_out     	(ID_pc_next)
        );

    execute_unit
        u_execute_unit(
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
            .pc_jump       	        (ID_pc_jump),
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
            .pc_adder_result_in	    (ID_pc_adder_result),
            .pc_adder_result_out    (EX_pc_adder_result),
            .rs2_data_out           (EX_rs2_data),
            .immediate_out          (EX_immediate) 
        );

    memory_operation
        u_memory_operation(
            // * Clock Sync ----------
            .clk           	(clk),
            .rst_n         	(rst_n),
            // * Internal ----------
            .mem_op        	(EX_mem_op),
            .mem_sel       	(EX_mem_sel),
            .alu_result    	(EX_alu_result),
            .rs2_data      	(EX_rs2_data),
            .mem_rdata     	(MEM_mem_rdata),
            .mem_ready     	(MEM_mem_ready),
            // * External ----------
            .ram_ce_n      	(ram_ce_n),
            .ram_we_n      	(ram_we_n),
            .ram_oe_n      	(ram_oe_n),
            .ram_byte_en_n 	(ram_byte_en_n),
            .ram_addr      	(ram_addr),
            .ram_data      	(ram_data),
            // * Previous Stage ----------
            .wb_sel_in      (EX_wb_sel),
            .wb_sel_out     (MEM_wb_sel),
            .alu_result_in  (EX_alu_result),
            .alu_result_out (MEM_alu_result),
            .immediate_in   (EX_immediate),
            .immediate_out  (MEM_immediate),
            .pc_next_in     (EX_pc_next),
            .pc_next_out    (MEM_pc_next),
            .rd_in          (EX_rd),
            .rd_out         (MEM_rd),
            .reg_we_in      (EX_reg_we),
            .reg_we_out     (MEM_reg_we)
        );

    // output declaration of module write_back

    write_back
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
