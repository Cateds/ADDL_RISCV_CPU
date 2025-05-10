`timescale 1ns / 1ps

module tb_instr_decoder_J();

    // Inputs
    reg [31:0] instruction;
    
    // Outputs
    wire [4:0] rd;
    wire [31:0] immediate;
    wire [3:0] alu_op;
    
    // Instantiate the Unit Under Test (UUT)
    instr_decoder_J uut (
        .instruction(instruction),
        .rd(rd),
        .immediate(immediate),
        .alu_op(alu_op)
    );
    
    // Initialize Inputs
    initial begin
        $dumpfile("wave.vcd");  // 波形文件名称
        $dumpvars(0, tb_instr_decoder_J); // 记录所有信号
    end

    initial begin
    // 正向跳转
    instruction = 32'h004000EF;
    #10;
    $display("JAL x1, 0x400: rd=%0d, imm=0x%h", rd, immediate);

    
end
    
endmodule