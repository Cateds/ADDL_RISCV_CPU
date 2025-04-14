module instr_decoder_S(
        input wire [31:0] instruction,
        output wire [4:0] rs1,
        output wire [4:0] rs2,
        output wire [31:0] immediate,
        output wire [3:0] alu_op,
        output wire [1:0] mem_op,
        output reg [2:0] mem_sel
    );

    ALU_OP_ENUM alu_op_enum();
    MEM_OP_ENUM mem_op_enum();
    MEM_SEL_ENUM mem_sel_enum();

    localparam FUNC3_SB = 3'b000; // Store Byte
    localparam FUNC3_SH = 3'b001; // Store Halfword
    localparam FUNC3_SW = 3'b010; // Store Word

    assign func3 = instruction[14:12];
    assign rs1 = instruction[19:15];    // 源寄存器 1，存储要存入内存的地址
    assign rs2 = instruction[24:20];    // 源寄存器 2，存储要存入内存的数据
    assign immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S 类型指令立即数

    assign alu_op = alu_op_enum.ADD;
    assign mem_op = mem_op_enum.STORE;

    always @(*) begin
        case (func3)
            FUNC3_SB:
                mem_sel = mem_sel_enum.BYTE_SIGNED;
            FUNC3_SH:
                mem_sel = mem_sel_enum.HALF_SIGNED;
            FUNC3_SW:
                mem_sel = mem_sel_enum.WORD;
            default:
                mem_sel = mem_sel_enum.NOP;
        endcase
    end
endmodule
