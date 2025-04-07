`include "../../../inc/alu_opcode.v"

module alu_compute_unit(
        input wire [31:0] alu_data_1,
        input wire [31:0] alu_data_2,
        input wire [3:0] alu_op,
        output reg [31:0] alu_result
    );

    always @(*) begin
        case (alu_op)
            `ALU_ADD:
                alu_result = alu_data_1 + alu_data_2;
            `ALU_SUB:
                alu_result = alu_data_1 - alu_data_2;
            `ALU_AND:
                alu_result = alu_data_1 & alu_data_2;
            `ALU_OR:
                alu_result = alu_data_1 | alu_data_2;
            `ALU_XOR:
                alu_result = alu_data_1 ^ alu_data_2;
            `ALU_SLL:
                alu_result = alu_data_1 << alu_data_2[4:0];
            `ALU_SRL:
                alu_result = alu_data_1 >> alu_data_2[4:0];
            `ALU_SRA:
                alu_result = $signed(alu_data_1) >>> alu_data_2[4:0];
            `ALU_SLT:
                alu_result =
                ($signed(alu_data_1) < $signed(alu_data_2))
                ? 32'b1 : 32'b0; // Signed comparison
            `ALU_SLTU:
                alu_result =
                (alu_data_1 < alu_data_2)
                ? 32'b1 : 32'b0; // Unsigned comparison
            default:
                alu_result = 32'b0; // No operation
        endcase
    end
endmodule
