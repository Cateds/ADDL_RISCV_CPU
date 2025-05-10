`timescale 1ns/1ps
`include "../../../inc/alu_opcode.v"
 
module instr_decoder_U_tb();
    // 测试信号
    reg [31:0] instruction;
    wire [4:0] rd_lui, rd_auipc;
    wire [31:0] immediate_lui, immediate_auipc;
    wire [2:0] alu_op_auipc;

    // 实例化待测模块
    instr_decoder_U_LUI lui_dut(
        .instruction(instruction),
        .rd(rd_lui),
        .immediate(immediate_lui)
    );

    instr_decoder_U_AUIPC auipc_dut(
        .instruction(instruction),
        .rd(rd_auipc),
        .immediate(immediate_auipc),
        .alu_op(alu_op_auipc)
    );

    // 波形生成
    initial begin
        $dumpfile("instr_decoder_U_tb.vcd");
        $dumpvars(0, instr_decoder_U_tb);
        
        // 测试 LUI 指令
        // lui x5, 0xABCDE
        instruction = 32'b10101011110011011110001010110111;
        #10;
        $display("\nLUI test:");
        $display("Expected rd: 5, Got: %d", rd_lui);
        $display("Expected immediate: 0xABCDE000, Got: %h", immediate_lui);
        
        // 测试 AUIPC 指令
        // auipc x7, 0x12345
        instruction = 32'b00010010001101000101001110010111;
        #10;
        $display("\nAUIPC test:");
        $display("Expected rd: 7, Got: %d", rd_auipc);
        $display("Expected immediate: 0x12345000, Got: %h", immediate_auipc);
        $display("Expected ALU_op: %b, Got: %b", `ALU_ADD, alu_op_auipc);

        #10 $finish;
    end

endmodule