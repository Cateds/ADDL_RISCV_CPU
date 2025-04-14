module instr_decoder_J(
        input wire [31:0] instruction,  // 输入指令
        output wire [4:0] rd,           // 目标寄存器
        output wire [31:0] immediate,   // 立即数
        output wire [3:0] alu_op       // ALU 操作码
    );

    ALU_OP_ENUM alu_op_enum();

    assign rd  = instruction[11:7];
    assign immediate ={
               instruction[31], instruction[19:12],
               instruction[20], instruction[30:21], 1'b0};
    assign alu_op = alu_op_enum.ADD;
endmodule
