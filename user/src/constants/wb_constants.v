module WB_SEL_ENUM();
    parameter ALU_OUT = 2'b00;  // ALU 输出
    parameter IMM_DAT = 2'b01;  // 立即数数据
    parameter MEM_DAT = 2'b10;  // 内存数据
    parameter PC_NEXT = 2'b11;  // 下一条指令地址
    parameter NOP     = 2'b00;  // 无操作 (保留此定义，文档中未指定)
endmodule