`timescale 1ns/1ps

module tb_branch();

    ALU_CMP_OP_ENUM cmp_op_enum();
    
    // 定义输入信号
    reg [31:0] alu_result;
    reg [2:0] cmp_opcode;
    reg pc_jump;

    // 定义输出信号
    wire [1:0] branch;

    // 实例化被测试模块
    branch_unit
        dut(
            .alu_result(alu_result),
            .cmp_opcode(cmp_opcode),
            .branch_jump(pc_jump),
            .branch(branch)
        );

    // 初始化dump文件
    initial begin
        $dumpfile("tb_branch.vcd");
        $dumpvars(0, tb_branch);

        // 初始化输入
        alu_result = 32'h00000000;
        cmp_opcode = 3'b000;
        pc_jump = 1'b0;

        // Case 1: BEQ (rs1 == rs2 → zero_flag == 1)
        //#10;
        alu_result = 32'h00000000; // 零结果
        cmp_opcode = cmp_op_enum.EQ;
        pc_jump = 1'b0;
        #5;
        $display("Case 1: EQ, alu_result=0, pc_jump=0 => branch=%b", branch);

        // case2：(EQ)，alu_result ≠ 0，预期branch_flag = 0
        
        alu_result = 32'h00000001; // 非零结果
        cmp_opcode = cmp_op_enum.EQ;
        pc_jump = 1'b0;
        #5;
        $display("Case 2: EQ, alu_result=1, pc_jump=0 => branch=%b", branch);

        // Case 3: BNE (rs1 != rs2 → zero_flag == 0)
        
        alu_result = 32'h00000001; // 非零结果
        cmp_opcode = cmp_op_enum.NE;
        pc_jump = 1'b0;
        #5;
        $display("Case 3: NE, alu_result=1, pc_jump=0 => branch=%b", branch);

        // Case 4: BLT (rs1 < rs2 → slt_result == 1)
        alu_result = 32'h00000001; // alu_result[0] = 1
        cmp_opcode = cmp_op_enum.LT;
        pc_jump = 1'b0;
        #5;
        $display("Case 4: LT, alu_result[0]=1, pc_jump=0 => branch=%b", branch);

        // Case 5: BGE (rs1 >= rs2 → slt_result == 0)
        alu_result = 32'h00000000; // alu_result[0] = 0
        cmp_opcode = cmp_op_enum.GE;
        pc_jump = 1'b0;
        #5;
        $display("Case 5: GE, alu_result[0]=0, pc_jump=0 => branch=%b", branch);

        // Case 6:BLTU (rs1 < rs2 unsigned)
        alu_result = 32'h00000001; // alu_result[0] = 1
        cmp_opcode = cmp_op_enum.LTU;
        pc_jump = 1'b0;
        #5;
        $display("Case 6: LTU, alu_result[0]=1, pc_jump=0 => branch=%b", branch);

        // 测试案例7：无符号大于等于条件(GEU)，sltu_result = 0，预期branch_flag = 1
        #10;
        alu_result = 32'h00000000; // alu_result[0] = 0
        cmp_opcode = cmp_op_enum.GEU;
        pc_jump = 1'b0;
        #5;
        $display("Case 7: GEU, alu_result[0]=0, pc_jump=0 => branch=%b", branch);

        // 测试pc_jump对branch的影响
       
        alu_result = 32'h00000000;
        cmp_opcode = cmp_op_enum.EQ;
        pc_jump = 1'b1; // 设置pc_jump为1
        #5;
        $display("Case 8: pc_jump=1 => branch=%b", branch);

        // 结束测试
        
        $finish;
    end
endmodule
