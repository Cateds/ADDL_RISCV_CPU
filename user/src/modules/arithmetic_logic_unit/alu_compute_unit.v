module alu_compute_unit(
        input wire [31:0] alu_data_1,
        input wire [31:0] alu_data_2,
        input wire [3:0] alu_op,
        output reg [31:0] alu_result
    );

    ALU_OP_ENUM alu_op_enum();

    always @(*) begin
        case (alu_op)
            alu_op_enum.ADD:
                alu_result = alu_data_1 + alu_data_2;
            alu_op_enum.SUB:
                alu_result = alu_data_1 - alu_data_2;
            alu_op_enum.AND:
                alu_result = alu_data_1 & alu_data_2;
            alu_op_enum.OR:
                alu_result = alu_data_1 | alu_data_2;
            alu_op_enum.XOR:
                alu_result = alu_data_1 ^ alu_data_2;
            alu_op_enum.SLL:
                alu_result = alu_data_1 << alu_data_2[4:0];
            alu_op_enum.SRL:
                alu_result = alu_data_1 >> alu_data_2[4:0];
            alu_op_enum.SRA:
                alu_result = $signed(alu_data_1) >>> alu_data_2[4:0];
            alu_op_enum.SLT:
                alu_result =  ($signed(alu_data_1) < $signed(alu_data_2))
                    ? 32'b1 : 32'b0; // Signed comparison
            alu_op_enum.SLTU:
                alu_result = (alu_data_1 < alu_data_2)
                    ? 32'b1 : 32'b0; // Unsigned comparison
            default:
                alu_result = 32'b0; // No operation
        endcase
    end
endmodule
