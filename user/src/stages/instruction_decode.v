module instruction_decode(
        // * Clock Sync Signals Connection --------------------
        input wire clk,
        input wire rst_n,

        // * Internal Signals Connection --------------------
        // About Instruction Decode
        input wire [31:0] pc,
        input wire [31:0] instruction,
        output wire [31:0] immediate,
        output wire [31:0] rs1_data,
        output wire [31:0] rs2_data,
        output wire [3:0] alu_op,
        output wire [2:0] cmp_op,
        output wire [4:0] rd,
        output wire reg_we,
        output wire alu_data1_sel,
        output wire alu_data2_sel,
        output wire [1:0] mem_op,
        output wire [2:0] mem_sel,
        output wire [1:0] wb_sel,
        output wire branch_jump,
        // About Register File
        input wire [4:0] wb_rd,
        input wire wb_reg_we,
        input wire [31:0] wb_data,
        // About PC Adder
        output wire [31:0] pc_adder_result,
        // Previous Stage Signals
        output wire [31:0] pc_out,
        input wire [31:0] pc_next_in,
        input wire [31:0] pc_next_out
    );

    // 直通信号
    assign pc_out = pc;
    assign pc_next_out = pc_next_in;

    wire [4:0] rs1;
    wire [4:0] rs2;

    instr_decoder
        u_instr_decoder(
            .instruction     (instruction),
            .immediate       (immediate),
            .alu_op          (alu_op),
            .cmp_op          (cmp_op),
            .rd              (rd),
            .rs1             (rs1),
            .rs2             (rs2),
            .reg_we          (reg_we),
            .alu_data1_sel   (alu_data1_sel),
            .alu_data2_sel   (alu_data2_sel),
            .mem_op          (mem_op),
            .mem_sel         (mem_sel),
            .wb_sel          (wb_sel),
            .branch_jump     (branch_jump)
        );

    registers
        u_registers(
            .clk          (clk),
            .rst_n        (rst_n),
            .rs1          (rs1),
            .rs2          (rs2),
            .rd           (wb_rd),
            .we           (wb_reg_we),
            .write_data   (wb_data),
            .rs1_data     (rs1_data),
            .rs2_data     (rs2_data)
        );

    pc_adder
        u_pc_adder(
            .pc                (pc),
            .immediate         (immediate),
            .pc_adder_result   (pc_adder_result)
        );

endmodule
