module instr_decoder_I_Calc(
        input wire [31:0] instruction,
        output reg [3:0] alu_op,
        output wire [4:0] rd,
        output wire [4:0] rs1,
        output wire [31:0] immediate
    );

    ALU_OP_ENUM alu_op_enum();

    localparam FUNC3_ADDI = 3'b000;
    localparam FUNC3_SLTI = 3'b010;
    localparam FUNC3_SLTIU = 3'b011;
    localparam FUNC3_XORI = 3'b100;
    localparam FUNC3_ORI = 3'b110;
    localparam FUNC3_ANDI = 3'b111;
    localparam FUNC3_SLLI = 3'b001;
    localparam FUNC3_SRLI_SRAI = 3'b101;
    localparam FUNC7_Former = 7'b0000000;
    localparam FUNC7_Latter = 7'b0100000;

    wire [6:0] func7 = instruction[31:25];
    wire [2:0] func3 = instruction[14:12];

    assign immediate = {{20{instruction[31]}}, instruction[31:20]};
    assign rs1 = instruction[19:15];
    assign rd = instruction[11:7];

    always @(*) begin
        case (func3)
            FUNC3_ADDI:
                alu_op = alu_op_enum.ADD;
            FUNC3_SLTI:
                alu_op = alu_op_enum.SLT;
            FUNC3_SLTIU:
                alu_op = alu_op_enum.SLTU;
            FUNC3_XORI:
                alu_op = alu_op_enum.XOR;
            FUNC3_ORI:
                alu_op = alu_op_enum.OR;
            FUNC3_ANDI:
                alu_op = alu_op_enum.AND;
            FUNC3_SLLI:
                alu_op = alu_op_enum.SLL;
            FUNC3_SRLI_SRAI:
            case (func7)
                FUNC7_Former:
                    alu_op = alu_op_enum.SRL;
                FUNC7_Latter:
                    alu_op = alu_op_enum.SRA;
                default:
                    alu_op = alu_op_enum.NOP;
            endcase
            default:
                alu_op = alu_op_enum.NOP;
        endcase
    end

endmodule


module instr_decoder_I_Load(
        input wire [31:0] instruction,
        output wire [3:0] alu_op,
        output wire [4:0] rd,
        output wire [4:0] rs1,
        output wire [31:0] immediate,
        output reg [2:0] mem_sel,
        output wire [1:0] mem_op
    );

    MEM_SEL_ENUM    mem_sel_enum();
    MEM_OP_ENUM     mem_op_enum();
    ALU_OP_ENUM     alu_op_enum();

    localparam FUNC3_LB = 3'b000; // Load Byte
    localparam FUNC3_LH = 3'b001; // Load Halfword
    localparam FUNC3_LW = 3'b010; // Load Word
    localparam FUNC3_LBU = 3'b100; // Load Byte Unsigned
    localparam FUNC3_LHU = 3'b101; // Load Halfword Unsigned

    wire [2:0] func3 = instruction[14:12];

    assign immediate = {{20{instruction[31]}}, instruction[31:20]};
    assign rs1 = instruction[19:15];
    assign rd = instruction[11:7];
    assign mem_op = mem_op_enum.LOAD;
    assign alu_op = alu_op_enum.ADD;

    always @(*) begin
        case (func3)
            FUNC3_LB:
                mem_sel = mem_sel_enum.BYTE_SIGNED;
            FUNC3_LH:
                mem_sel = mem_sel_enum.HALF_SIGNED;
            FUNC3_LW:
                mem_sel = mem_sel_enum.WORD;
            FUNC3_LBU:
                mem_sel = mem_sel_enum.BYTE_UNSIGNED;
            FUNC3_LHU:
                mem_sel = mem_sel_enum.HALF_UNSIGNED;
            default:
                mem_sel = mem_sel_enum.NOP;
        endcase
    end
endmodule

module instr_decoder_I_Jump(
        input wire [31:0] instruction,
        output wire [3:0] alu_op,
        output wire [4:0] rd,
        output wire [4:0] rs1,
        output wire [31:0] immediate
    );

    ALU_OP_ENUM alu_op_enum();

    assign rd = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign immediate = {{20{instruction[31]}}, instruction[31:20]};
    assign alu_op = alu_op_enum.ADD;
endmodule

module instr_decoder_I_Env(
        input wire [31:0] instruction,
        output reg [4:0] rd,
        output reg [4:0] rs1,
        output reg [31:0] immediate,
        output reg [1:0] csr_op,
        output reg is_immediate
    );

    CSR_OP_ENUM csr_op_enum();

    localparam FUNC3_CSRRW = 3'b001;    // CSR Read and Write
    localparam FUNC3_CSRRS = 3'b010;    // CSR Read and Set
    localparam FUNC3_CSRRC = 3'b011;    // CSR Read and Clear
    localparam FUNC3_CSRRWI = 3'b101;
    localparam FUNC3_CSRRSI = 3'b110;
    localparam FUNC3_CSRRCI = 3'b111;

    localparam FUNC3_ECALL_EBREAK = 3'b000;    // ECALL
    localparam FUNC12_ECALL = 12'b0;
    localparam FUNC12_EBREAK = 12'b1;

    wire [2:0] func3 = instruction[14:12];
    wire [11:0] func12 = instruction[31:20];

    // TODO: CSR
    reg [11:0] csr;

    always @(*) begin
        case (func3)
            FUNC3_CSRRW,    FUNC3_CSRRS,    FUNC3_CSRRC,
            FUNC3_CSRRWI,   FUNC3_CSRRSI,   FUNC3_CSRRCI: begin
                csr_op = func3[1:0];
                is_immediate = func3[2];
                immediate = {27'b0 , instruction[31:20]};
                rd = instruction[11:7];
                rs1 = instruction[19:15];
                csr = instruction[31:20];
            end
            FUNC3_ECALL_EBREAK: begin // TODO <----------------------
                case (func12)
                    FUNC12_ECALL:
                        csr_op = csr_op_enum.NOP;
                    FUNC12_EBREAK:
                        csr_op = csr_op_enum.NOP;
                    default:
                        csr_op = csr_op_enum.NOP;
                endcase
            end // TODO <--------------------------------------------
            default: begin
                csr_op = csr_op_enum.NOP;
                is_immediate = 1'b0;
                immediate = 32'b0;
                rd = 5'b0;
                rs1 = 5'b0;
                csr = 12'b0;
            end
        endcase
    end
endmodule

module instr_decoder_I_Fence(
        input wire [31:0] instruction
    );
    // TODO: implement I type fence instruction decoder

    localparam FUNC3_FENCE = 3'b000;
    localparam FUNC3_FENCE_I = 3'b001;

    wire [2:0] func3 = instruction[14:12];

    assign pred = instruction[31:24];
    assign succ = instruction[23:16];

    always @(*) begin
        case (func3)
            FUNC3_FENCE: begin
                // TODO: implement I type fence instruction decoder
            end
            FUNC3_FENCE_I: begin
                // TODO: implement I type fence instruction decoder
            end
            default: begin
                // TODO: implement I type fence instruction decoder
            end
        endcase
    end
endmodule

