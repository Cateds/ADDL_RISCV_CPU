`include "../../../inc/alu_opcode.v"

module instr_decoder_U_LUI(
        input wire [31:0] instruction,
        output wire [4:0] rd,
        output wire [31:0] immediate
    );
    assign rd = instruction[11:7];
    assign immediate = {instruction[31:12], 12'b0};
endmodule

module instr_decoder_U_AUIPC(
        input wire [31:0] instruction,
        output wire [4:0] rd,
        output wire [31:0] immediate,
        output wire [2:0] alu_op
    );
    assign rd = instruction[11:7];
    assign immediate = {instruction[31:12], 12'b0};
    assign alu_op = `ALU_ADD;
endmodule
