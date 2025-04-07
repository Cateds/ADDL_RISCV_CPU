`ifndef ALU_OPCODE_V
`define ALU_OPCODE_V

        // ALU 操作码常量定义
`define ALU_ADD   4'b0001  // 加法操作
`define ALU_SUB   4'b0010  // 减法操作
`define ALU_AND   4'b0100  // 逻辑与
`define ALU_OR    4'b0101  // 逻辑或
`define ALU_XOR   4'b0110  // 异或操作
`define ALU_SLL   4'b1000  // 逻辑左移
`define ALU_SRL   4'b1001  // 逻辑右移
`define ALU_SRA   4'b1010  // 算术右移
`define ALU_SLT   4'b1100  // 有符号比较，小于时置位
`define ALU_SLTU  4'b1101  // 无符号比较，小于时置位
`define ALU_NOP   4'b1111  // 无操作 (保留此定义，文档中未指定)

`define ALU_CMP_EQ  3'b000  // 比较操作，相等时置位
`define ALU_CMP_NE  3'b001  // 比较操作，不等时置位
`define ALU_CMP_LT  3'b100  // 比较操作，小于时置位
`define ALU_CMP_GE  3'b101  // 比较操作，大于等于时置位
`define ALU_CMP_LTU 3'b110  // 比较操作，无符号小于时置位
`define ALU_CMP_GEU 3'b111  // 比较操作，无符号大于等于时置位
`define ALU_CMP_NOP 3'b011  // 无操作 (保留此定义，文档中未指定)

`endif
