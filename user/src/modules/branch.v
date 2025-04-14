module branch_unit(
        input wire [31:0] alu_result,
        input wire [2:0] cmp_opcode,
        input wire pc_jump,
        output wire [1:0] branch
    );

    ALU_CMP_OP_ENUM cmp_op_enum();
    PC_MUX_ENUM pc_mux_enum();

    assign zero_flag = (alu_result == 32'h0); // alu_opcode: ALU_XOR
    assign slt_result = alu_result[0]; // alu_opcode: ALU_SLT
    assign sltu_result = alu_result[0]; // alu_opcode: ALU_SLTU
    reg branch_flag;
    assign branch = pc_jump ? pc_mux_enum.ALU_OUT : {1'b0, branch_flag};

    always @(*) begin
        case (cmp_opcode)
            cmp_op_enum.EQ:
                branch_flag = zero_flag;
            cmp_op_enum.NE:
                branch_flag = ~zero_flag;
            cmp_op_enum.LT:
                branch_flag = slt_result;
            cmp_op_enum.GE:
                branch_flag = ~slt_result;
            cmp_op_enum.LTU:
                branch_flag = sltu_result;
            cmp_op_enum.GEU:
                branch_flag = ~sltu_result;
            default:
                branch_flag = 1'b0; // 默认不分支
        endcase
    end



endmodule
