module alu(
        input wire [3:0] alu_op,
        input wire d1_sel,
        input wire d2_sel,
        input wire [31:0] rs1_data,
        input wire [31:0] rs2_data,
        input wire [31:0] immediate,
        input wire [31:0] pc,
        output reg [31:0] alu_result
    );

    // output declaration of module alu_input_mux
    wire [31:0] alu_data_1;
    wire [31:0] alu_data_2;

    alu_input_mux
        u_alu_input_mux(
            .d1_sel     	(d1_sel      ),
            .d2_sel     	(d2_sel      ),
            .rs1_data   	(rs1_data    ),
            .rs2_data   	(rs2_data    ),
            .immediate  	(immediate   ),
            .pc         	(pc          ),
            .alu_data_1 	(alu_data_1  ),
            .alu_data_2 	(alu_data_2  )
        );

    alu_compute_unit
        u_alu_compute_unit(
            .alu_data_1 	(alu_data_1  ),
            .alu_data_2 	(alu_data_2  ),
            .alu_op     	(alu_op      ),
            .alu_result 	(alu_result  )
        );

endmodule
