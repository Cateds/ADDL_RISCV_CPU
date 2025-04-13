`include "../../inc/alu_opcode.v"
`include "../../inc/pc_mux.v"

module branch_unit(
        input wire [31:0] alu_result,
        input wire [2:0] cmp_opcode,
        input wire pc_jump,
        output wire [1:0] branch
    );

    assign zero_flag = (alu_result == 32'h0); // alu_opcode: ALU_XOR
    assign slt_result = alu_result[0]; // alu_opcode: ALU_SLT
    assign sltu_result = alu_result[0]; // alu_opcode: ALU_SLTU
    reg branch_flag;
    assign branch = pc_jump ? `PC_MUX_ALU_OUT : {1'b0, branch_flag};

    always @(*) begin
        case (cmp_opcode)
            `ALU_CMP_EQ:
                branch_flag = zero_flag;
            `ALU_CMP_NE:
                branch_flag = ~zero_flag;
            `ALU_CMP_LT:
                branch_flag = slt_result;
            `ALU_CMP_GE:
                branch_flag = ~slt_result;
            `ALU_CMP_LTU:
                branch_flag = sltu_result;
            `ALU_CMP_GEU:
                branch_flag = ~sltu_result;
            default:
                branch_flag = 1'b0; // 默认不分支
        endcase
    end



endmodule
