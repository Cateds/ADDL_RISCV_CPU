module WB_SEL_ENUM();
    localparam ALU_OUT = 2'b00;  // ALU 输出
    localparam IMM_DAT = 2'b01;  // 立即数数据
    localparam MEM_DAT = 2'b10;  // 内存数据
    localparam PC_NEXT = 2'b11;  // 下一条指令地址
    localparam NOP     = 2'b00;  // 无操作 (保留此定义，文档中未指定)
endmodule