module alu_input_mux(
        input wire d1_sel,
        input wire d2_sel,

        input wire [31:0] rs1_data,
        input wire [31:0] rs2_data,
        input wire [31:0] immediate,
        input wire [31:0] pc,
        
        output wire [31:0] alu_data_1,
        output wire [31:0] alu_data_2
    );

    // 默认情况下，alu_data_1和alu_data_2的值为rs1_data和rs2_data
    assign alu_data_1 = d1_sel ? pc : rs1_data;
    assign alu_data_2 = d2_sel ? immediate : rs2_data;

endmodule
