module ALU_OP_ENUM();
    localparam [3:0] ADD  = 4'b0001;  // 加法操作
    localparam [3:0] SUB  = 4'b0010;  // 减法操作
    localparam [3:0] AND  = 4'b0100;  // 逻辑与
    localparam [3:0] OR   = 4'b0101;  // 逻辑或
    localparam [3:0] XOR  = 4'b0110;  // 异或操作
    localparam [3:0] SLL  = 4'b1000;  // 逻辑左移
    localparam [3:0] SRL  = 4'b1001;  // 逻辑右移
    localparam [3:0] SRA  = 4'b1010;  // 算术右移
    localparam [3:0] SLT  = 4'b1100;  // 有符号比较，小于时置位
    localparam [3:0] SLTU = 4'b1101;  // 无符号比较，小于时置位
    localparam [3:0] NOP  = 4'b1111;  // 无操作 (保留此定义，文档中未指定)
endmodule

module ALU_CMP_OP_ENUM();
    localparam [2:0] EQ  = 3'b000;  // 比较操作，相等时置位
    localparam [2:0] NE  = 3'b001;  // 比较操作，不等时置位
    localparam [2:0] LT  = 3'b100;  // 比较操作，小于时置位
    localparam [2:0] GE  = 3'b101;  // 比较操作，大于等于时置位
    localparam [2:0] LTU = 3'b110;  // 比较操作，无符号小于时置位
    localparam [2:0] GEU = 3'b111;  // 比较操作，无符号大于等于时置位
    localparam [2:0] NOP = 3'b011;  // 无操作 (保留此定义，文档中未指定)
endmodule

module ALU_MUX_ENUM();
    localparam D1_RS1 = 0;  // ALU 输入1，来自寄存器文件的 rs1
    localparam D1_PC  = 1;  // ALU 输入1，来自 PC
    localparam D2_RS2 = 0;  // ALU 输入2，来自寄存器文件的 rs2
    localparam D2_IMM = 1;  // ALU 输入2，来自立即数
endmodule