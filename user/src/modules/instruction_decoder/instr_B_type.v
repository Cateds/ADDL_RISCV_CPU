module instr_decoder_B(
        input wire [31:0] instruction,
        output reg [3:0] alu_op,
        output reg [2:0] cmp_op,
        output wire [4:0] rs1,
        output wire [4:0] rs2,
        output wire [31:0] immediate
    );

    ALU_OP_ENUM     alu_op_enum();
    ALU_CMP_OP_ENUM cmp_op_enum();

    localparam FUNC3_BEQ = 3'h0; // a == b
    localparam FUNC3_BNE = 3'h1; // a != b
    localparam FUNC3_BLT = 3'h4; // a < b
    localparam FUNC3_BGE = 3'h5; // a >= b
    localparam FUNC3_BLTU = 3'h6; // a < b : unsigned
    localparam FUNC3_BGEU = 3'h7; // a >= b : unsigned

    wire [2:0] func3 = instruction[14:12];

    // B 类型指令立即数:
    // imm[12|10:5|4:1|11] = inst[31|30:25|11:8|7]
    // 符号扩展并左移 1 位（最低位为 0）
    assign immediate =
           {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
    assign rs2 = instruction[24:20];
    assign rs1 = instruction[19:15];

    always @(*) begin
        case (func3)
            FUNC3_BEQ: begin
                alu_op = alu_op_enum.XOR;
                cmp_op = cmp_op_enum.EQ;
            end
            FUNC3_BNE: begin
                alu_op = alu_op_enum.XOR;
                cmp_op = cmp_op_enum.NE;
            end
            FUNC3_BLT: begin
                alu_op = alu_op_enum.SLT;
                cmp_op = cmp_op_enum.LT;
            end
            FUNC3_BGE: begin
                alu_op = alu_op_enum.SLT;
                cmp_op = cmp_op_enum.GE;
            end
            FUNC3_BLTU: begin
                alu_op = alu_op_enum.SLTU;
                cmp_op = cmp_op_enum.LTU;
            end
            FUNC3_BGEU: begin
                alu_op = alu_op_enum.SLTU;
                cmp_op = cmp_op_enum.GEU;
            end
            default: begin
                alu_op = alu_op_enum.NOP;
                cmp_op = cmp_op_enum.NOP;
            end
        endcase
    end

endmodule
