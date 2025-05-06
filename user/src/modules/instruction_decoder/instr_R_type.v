module instr_decoder_R(
        input [31:0] instruction,  // 输入指令
        output reg [3:0] alu_op, // ALU 操作码
        output [4:0] rd, // 目标寄存器
        output [4:0] rs1,  // 源寄存器 1
        output [4:0] rs2   // 源寄存器 2
    );

    ALU_OP_ENUM alu_op_enum();

    localparam FUNC3_ADD_SUB = 3'b000;
    localparam FUNC3_SLL = 3'b001;
    localparam FUNC3_SLT = 3'b010;
    localparam FUNC3_SLTU = 3'b011;
    localparam FUNC3_XOR = 3'b100;
    localparam FUNC3_SRL_SRA = 3'b101;
    localparam FUNC3_OR = 3'b110;
    localparam FUNC3_AND = 3'b111;
    localparam FUNC7_Former = 7'b0000000;
    localparam FUNC7_Latter = 7'b0100000;

    wire [6:0] func7 = instruction[31:25];
    wire [2:0] func3 = instruction[14:12];

    assign rd = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];

    always @(*) begin
        case (func3)
            FUNC3_ADD_SUB: begin
                case (func7)
                    FUNC7_Former:
                        alu_op = alu_op_enum.ADD;
                    FUNC7_Latter:
                        alu_op = alu_op_enum.SUB; // ALU_SUB
                endcase
            end
            FUNC3_SLL:
                alu_op = alu_op_enum.SLL; // ALU_SLL
            FUNC3_SLT:
                alu_op = alu_op_enum.SLT; // ALU_SLT
            FUNC3_SLTU:
                alu_op = alu_op_enum.SLTU; // ALU_SLTU
            FUNC3_XOR:
                alu_op = alu_op_enum.XOR; // ALU_XOR
            FUNC3_SRL_SRA: begin
                case (func7)
                    FUNC7_Former:
                        alu_op = alu_op_enum.SRL; // ALU_SRL
                    FUNC7_Latter:
                        alu_op = alu_op_enum.SRA; // ALU_SRA
                endcase
            end
            FUNC3_OR:
                alu_op = alu_op_enum.OR; // ALU_OR
            FUNC3_AND:
                alu_op = alu_op_enum.AND; // ALU_AND
            default:
                alu_op = alu_op_enum.NOP; // ALU_NOP
        endcase
    end

endmodule
