`timescale 1ns / 1ps

module tb_instr_decoder;

  // 输入信号
  reg [31:0] instruction;
  
  // 输出信号
  wire [3:0] alu_op;
  wire [31:0] immediate;
  
  // 实例化被测模块
  instr_decoder uut (
      .instruction(instruction),
      .alu_op(alu_op),
      .immediate(immediate)
  );

  initial begin
      // 初始化信号
      instruction = 32'b0;

      // 测试向量
      #10 instruction = 32'b00000000000000000000000000000000; // 示例指令
      #10 instruction = 32'b00000000000000000000000000000001; // 示例指令
      #10 instruction = 32'b00000000000000000000000000000010; // 示例指令
      #10 instruction = 32'b00000000000000000000000000000011; // 示例指令

      // 结束仿真
      #10 $finish;
  end

  // 监视输出波形
  initial begin
      $dumpfile("instr_decoder.vcd"); // 波形文件名
      $dumpvars(0, tb_instr_decoder); // 记录所有变量
  end

endmodule
