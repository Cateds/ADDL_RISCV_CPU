`include "../inc/registers/registers_writeback.v"
module tb_registers;

    // registers Parameters
    parameter PERIOD  = 10;

    // registers Inputs
    reg   [4:0]  rs1                           = 0 ;
    reg   [4:0]  rs2                           = 0 ;
    reg   [4:0]  rd                            = 0 ;
    reg   clk                                  = 0 ;
    reg   rst_n                                = 0 ;
    reg   we                                   = 0 ;
    reg   [1:0]  wb_select                     = 0 ;
    reg   [31:0]  alu_result                   = 0 ;
    reg   [31:0]  imm_data                     = 0 ;
    reg   [31:0]  mem_data                     = 0 ;
    reg   [31:0]  pc_next                      = 0 ;

    // registers Outputs
    wire  [31:0]  read_data1                   ;
    wire  [31:0]  read_data2                   ;


    initial begin
        forever
            #(PERIOD/2)  clk=~clk;
    end

    initial begin
        #(PERIOD*2) rst_n  =  1;
    end

    registers
        u_registers (
            .rs1                     ( rs1         [4:0]  ),
            .rs2                     ( rs2         [4:0]  ),
            .rd                      ( rd          [4:0]  ),
            .clk                     ( clk                ),
            .rst_n                   ( rst_n              ),
            .we                      ( we                 ),
            .wb_select               ( wb_select   [1:0]  ),
            .alu_result              ( alu_result  [31:0] ),
            .imm_data                ( imm_data    [31:0] ),
            .mem_data                ( mem_data    [31:0] ),
            .pc_next                 ( pc_next     [31:0] ),

            .read_data1              ( read_data1  [31:0] ),
            .read_data2              ( read_data2  [31:0] )
        );

    initial begin
        $dumpfile("tb_registers.vcd");
        $dumpvars(0, tb_registers);

        // Test case 1: ALU Result
        #(PERIOD*2);
        we = 1;
        wb_select = `REG_WB_ALU_OUT;
        rd = 5'd1;
        alu_result = 32'hAAAA_AAAA;
        #(PERIOD);
        we = 0;
        rs1 = 5'd1;
        #(PERIOD);
        $display("Test Case 1 - ALU Result:");
        $display("Expected: %h", 32'hAAAA_AAAA);
        $display("Actual  : %h\n", read_data1);

        // Test case 2: Immediate Data  
        #(PERIOD);
        we = 1;
        wb_select = `REG_WB_IMM_DAT;
        rd = 5'd2;
        imm_data = 32'h5555_5555;
        #(PERIOD);
        we = 0;
        rs2 = 5'd2;
        #(PERIOD);
        $display("Test Case 2 - Immediate Data:");
        $display("Expected: %h", 32'h5555_5555);
        $display("Actual  : %h\n", read_data2);

        // Test case 3: Memory Data
        #(PERIOD);
        we = 1;
        wb_select = `REG_WB_MEM_DAT;
        rd = 5'd1;
        mem_data = 32'hCCCC_CCCC;
        #(PERIOD);
        we = 0;
        rs1 = 5'd1;
        #(PERIOD);
        $display("Test Case 3 - Memory Data:");
        $display("Expected: %h", 32'hCCCC_CCCC);
        $display("Actual  : %h\n", read_data1);

        // Test case 4: PC+4
        #(PERIOD);
        we = 1;
        wb_select = `REG_WB_PC_NEXT;
        rd = 5'd4;
        pc_next = 32'h1234_5678;
        #(PERIOD);
        we = 0;
        rs2 = 5'd4;
        #(PERIOD);
        $display("Test Case 4 - PC+4:");
        $display("Expected: %h", 32'h1234_5678);
        $display("Actual  : %h\n", read_data2);

        #(PERIOD);
        we = 1;
        wb_select = `REG_WB_ALU_OUT;
        rd = 5'd0;
        alu_result = 32'hFFFFFFFF; // 写入寄存器0，应该无效
        #(PERIOD);
        we = 0;
        rs1 = 5'd0; // 读取寄存器0
        #(PERIOD);
        $display("Test Case 5 - Write to R0:");
        $display("Expected: %h", 32'h0000_0000); // 寄存器0应该始终为0
        $display("Actual  : %h\n", read_data1);

        $finish;  end

endmodule
