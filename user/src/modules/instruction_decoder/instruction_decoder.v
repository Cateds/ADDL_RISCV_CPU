`include "../../../inc/alu_opcode.v"
`include "../../../inc/alu_mux.v"
`include "../../../inc/registers_writeback.v"
`include "../../../inc/memory_opcode.v"
`include "../../../inc/memory_select.v"
`include "../../../inc/registers_writeback.v"


module instr_decoder(
        input wire [31:0] instruction,
        output reg [31:0] immediate,
        output reg [3:0] alu_op,
        output reg [2:0] cmp_op,
        output reg [4:0] rd,
        output reg [4:0] rs1,
        output reg [4:0] rs2,
        output reg reg_we,
        output reg alu_data1_sel,
        output reg alu_data2_sel,
        output reg [1:0] mem_op,
        output reg [2:0] mem_sel,
        output reg [1:0] wb_sel,
        output reg pc_jump
    );

    localparam OPCODE_R =       7'b0110011;
    localparam OPCODE_I_Calc =  7'b0010011;
    localparam OPCODE_I_Load =  7'b0000011;
    localparam OPCODE_I_Jump =  7'b1100111;
    localparam OPCODE_I_Env =   7'b1110011;
    localparam OPCODE_I_Fence = 7'b0000111;
    localparam OPCODE_S =       7'b0000011;
    localparam OPCODE_B =       7'b1100011;
    localparam OPCODE_U_LUI =   7'b0110111;
    localparam OPCODE_U_AUIPC = 7'b0010111;
    localparam OPCODE_J =       7'b1101111;

    assign opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            // * R-type instruction ----------
            OPCODE_R: begin
                immediate = 32'b0;
                alu_op = R_alu_op;
                cmp_op = `ALU_CMP_NOP;
                rd = R_rd;
                rs1 = R_rs1;
                rs2 = R_rs2;
                reg_we = 1'b1;
                alu_data1_sel = `ALU_D1_SEL_RS1;
                alu_data2_sel = `ALU_D2_SEL_RS2;
                mem_op = `MEM_OP_NOP;
                mem_sel = `MEM_SEL_NOP;
                wb_sel = `REG_WB_ALU_OUT;
                pc_jump = 1'b0;
            end
            // * I-type instruction ----------
            OPCODE_I_Calc: begin
                immediate = I_Calc_immediate;
                alu_op = I_Calc_alu_op;
                cmp_op = `ALU_CMP_NOP;
                rd = I_Calc_rd;
                rs1 = I_Calc_rs1;
                rs2 = 5'b0;
                reg_we = 1'b1;
                alu_data1_sel = `ALU_D1_SEL_RS1;
                alu_data2_sel = `ALU_D2_SEL_IMM;
                mem_op = `MEM_OP_NOP;
                mem_sel = `MEM_SEL_NOP;
                wb_sel = `REG_WB_ALU_OUT;
                pc_jump = 1'b0;
            end
            OPCODE_I_Load: begin
                immediate = I_Load_immediate;
                alu_op = I_Load_alu_op;
                cmp_op = `ALU_CMP_NOP;
                rd = I_Load_rd;
                rs1 = I_Load_rs1;
                rs2 = 5'b0;
                reg_we = 1'b1;
                alu_data1_sel = `ALU_D1_SEL_RS1;
                alu_data2_sel = `ALU_D2_SEL_IMM;
                mem_op = I_Load_mem_op;
                mem_sel = I_Load_mem_sel;
                wb_sel = `REG_WB_MEM_OUT;
                pc_jump = 1'b0;
            end
            OPCODE_I_Jump: begin
                immediate = I_Jump_immediate;
                alu_op = I_Jump_alu_op;
                cmp_op = `ALU_CMP_NOP;
                rd = I_Jump_rd;
                rs1 = I_Jump_rs1;
                rs2 = 5'b0;
                reg_we = 1'b1;
                alu_data1_sel = `ALU_D1_SEL_RS1;
                alu_data2_sel = `ALU_D2_SEL_IMM;
                mem_op = `MEM_OP_NOP;
                mem_sel = `MEM_SEL_NOP;
                wb_sel = `REG_WB_PC_NEXT;
                pc_jump = 1'b1;
            end
            // * S-type instruction ----------
            OPCODE_S: begin
                immediate = S_immediate;
                alu_op = S_alu_op;
                cmp_op = `ALU_CMP_NOP;
                rd = 5'b0;
                rs1 = S_rs1;
                rs2 = S_rs2;
                reg_we = 1'b0;
                alu_data1_sel = `ALU_D1_SEL_RS1;
                alu_data2_sel = `ALU_D2_SEL_IMM;
                mem_op = S_mem_op;
                mem_sel = S_mem_sel;
                wb_sel = `REG_WB_NOP;
                pc_jump = 1'b0;
            end
            // * U-type instruction ----------
            OPCODE_U_LUI: begin
                immediate = U_LUI_immediate;
                alu_op = `ALU_NOP;
                cmp_op = `ALU_CMP_NOP;
                rd = U_LUI_rd;
                rs1 = 5'b0;
                rs2 = 5'b0;
                reg_we = 1'b1;
                alu_data1_sel = `ALU_D1_SEL_RS1;
                alu_data2_sel = `ALU_D2_SEL_RS2;
                mem_op = `MEM_OP_NOP;
                mem_sel = `MEM_SEL_NOP;
                wb_sel = `REG_WB_IMM_DAT;
                pc_jump = 1'b0;
            end
            OPCODE_U_AUIPC: begin
                immediate = U_AUIPC_immediate;
                alu_op = U_AUIPC_alu_op;
                cmp_op = `ALU_CMP_NOP;
                rd = U_AUIPC_rd;
                rs1 = 5'b0;
                rs2 = 5'b0;
                reg_we = 1'b1;
                alu_data1_sel = `ALU_D1_SEL_PC;
                alu_data2_sel = `ALU_D2_SEL_IMM;
                mem_op = `MEM_OP_NOP;
                mem_sel = `MEM_SEL_NOP;
                wb_sel = `REG_WB_ALU_OUT;
                pc_jump = 1'b0;
            end
            // * J-type instruction ----------
            OPCODE_J: begin
                immediate = J_immediate;
                alu_op = J_alu_op;
                cmp_op = `ALU_CMP_NOP;
                rd = J_rd;
                rs1 = 5'b0;
                rs2 = 5'b0;
                reg_we = 1'b1;
                alu_data1_sel = `ALU_D1_SEL_PC;
                alu_data2_sel = `ALU_D2_SEL_IMM;
                mem_op = `MEM_OP_NOP;
                mem_sel = `MEM_SEL_NOP;
                wb_sel = `REG_WB_PC_NEXT;
                pc_jump = 1'b1;
            end
            // * B-type instruction ----------
            OPCODE_B: begin
                immediate = B_immediate;
                alu_op = B_alu_op;
                cmp_op = B_cmp_op;
                rd = 5'b0;
                rs1 = B_rs1;
                rs2 = B_rs2;
                reg_we = 1'b0;
                alu_data1_sel = `ALU_D1_SEL_RS1;
                alu_data2_sel = `ALU_D2_SEL_RS2;
                mem_op = `MEM_OP_NOP;
                mem_sel = `MEM_SEL_NOP;
                wb_sel = `REG_WB_NOP;
                pc_jump = 1'b0; 
                // branch 标志位 (将pc_adder值写入pc): 由 branch unit 计算
                // jump 标志位 (将alu_result值写入pc): 此时不设立
            end
        endcase
    end


    // * R-type instruction decoder --------------------
    wire [3:0] R_alu_op;
    wire [4:0] R_rd;
    wire [4:0] R_rs1;
    wire [4:0] R_rs2;
    instr_decoder_R
        instr_R (
            .instruction (instruction    ),
            .alu_op      (R_alu_op       ),
            .rd          (R_rd           ),
            .rs1         (R_rs1          ),
            .rs2         (R_rs2          )
        );

    // * B-type instruction decoder --------------------
    wire [3:0] B_alu_op;
    wire [2:0] B_cmp_op;
    wire [4:0] B_rs1;
    wire [4:0] B_rs2;
    wire [31:0] B_immediate;
    instr_decoder_B
        instr_B (
            .instruction    (instruction    ),
            .alu_op         (B_alu_op       ),
            .cmp_op         (B_cmp_op       ),
            .rs1            (B_rs1          ),
            .rs2            (B_rs2          ),
            .immediate      (B_immediate    )
        );

    // * J-type instruction decoder --------------------
    wire [31:0] J_immediate;
    wire [4:0] J_rd;
    wire [3:0] J_alu_op;
    instr_decoder_J
        instr_J(
            .instruction    (instruction    ),
            .rd             (J_rd           ),
            .immediate      (J_immediate    ),
            .alu_op         (J_alu_op       )
        );

    // * U-type instruction decoder --------------------

    // output declaration of module instr_decoder_U_LUI
    wire [4:0] U_LUI_rd;
    wire [31:0] U_LUI_immediate;
    instr_decoder_U_LUI
        instr_U_LUI(
            .instruction 	(instruction        ),
            .rd          	(U_LUI_rd           ),
            .immediate   	(U_LUI_immediate    )
        );

    // output declaration of module instr_decoder_U_AUIPC
    wire [4:0] U_AUIPC_rd;
    wire [31:0] U_AUIPC_immediate;
    wire [2:0] U_AUIPC_alu_op;
    instr_decoder_U_AUIPC
        instr_U_AUIPC(
            .instruction 	(instruction        ),
            .rd          	(U_AUIPC_rd         ),
            .immediate   	(U_AUIPC_immediate  ),
            .alu_op      	(U_AUIPC_alu_op     )
        );

    // * S-type instruction decoder --------------------

    // output declaration of module instr_decoder_S
    wire [4:0] S_rs1;
    wire [4:0] S_rs2;
    wire [31:0] S_immediate;
    wire [3:0] S_alu_op;
    wire [1:0] S_mem_op;
    wire [2:0] S_mem_sel;

    instr_decoder_S
        instr_S(
            .instruction 	(instruction  ),
            .rs1         	(S_rs1          ),
            .rs2         	(S_rs2          ),
            .immediate   	(S_immediate    ),
            .alu_op      	(S_alu_op       ),
            .mem_op      	(S_mem_op       ),
            .mem_sel     	(S_mem_sel      )
        );

    // * I-type instruction decoder --------------------

    // output declaration of module instr_decoder_I_Calc
    reg [3:0] I_Calc_alu_op;
    wire [4:0] I_Calc_rd;
    wire [4:0] I_Calc_rs1;
    wire [31:0] I_Calc_immediate;

    instr_decoder_I_Calc
        instr_I_Calc(
            .instruction 	(instruction  ),
            .alu_op      	(I_Calc_alu_op       ),
            .rd          	(I_Calc_rd           ),
            .rs1         	(I_Calc_rs1          ),
            .immediate   	(I_Calc_immediate    )
        );

    // output declaration of module instr_decoder_I_Load
    wire [4:0] I_Load_rd;
    wire [4:0] I_Load_rs1;
    wire [31:0] I_Load_immediate;
    wire [2:0] I_Load_mem_sel;
    wire [1:0] I_Load_mem_op;
    wire [3:0] I_Load_alu_op;

    instr_decoder_I_Load
        instr_I_Load(
            .instruction 	(instruction  ),
            .alu_op      	(I_Load_alu_op       ),
            .rd          	(I_Load_rd           ),
            .rs1         	(I_Load_rs1          ),
            .immediate   	(I_Load_immediate    ),
            .mem_sel     	(I_Load_mem_sel      ),
            .mem_op      	(I_Load_mem_op       )
        );

    // output declaration of module instr_decoder_I_Jump
    wire [4:0] I_Jump_rd;
    wire [4:0] I_Jump_rs1;
    wire [31:0] I_Jump_immediate;
    wire [3:0] I_Jump_alu_op;

    instr_decoder_I_Jump
        instr_I_Jump(
            .instruction 	(instruction  ),
            .alu_op      	(I_Jump_alu_op       ),
            .rd          	(I_Jump_rd           ),
            .rs1         	(I_Jump_rs1          ),
            .immediate   	(I_Jump_immediate    )
        );

    // I Env 和 I Fence 暂时不支持
endmodule
