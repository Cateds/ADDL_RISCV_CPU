`timescale 1ns/1ps


module tb_alu_input_multiplexer;

    // 输入信号
    reg d1_sel;
    reg d2_sel;
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;
    reg [31:0] immediate;
    reg [31:0] pc;

    // 输出信号
    wire [31:0] alu_data_1;
    wire [31:0] alu_data_2;

    // 实例化 DUT
    alu_input_mux uut (
        .d1_sel(d1_sel),
        .d2_sel(d2_sel),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .immediate(immediate),
        .pc(pc),
        .alu_data_1(alu_data_1),
        .alu_data_2(alu_data_2)
    );
     initial begin
        $dumpfile("tb_alu_input_multiplexer.vcd");
        $dumpvars(0, tb_alu_input_multiplexer);
    end
    initial begin
      

        // 初始化输入数据
        rs1_data = 32'hAAAA_AAAA;
        rs2_data = 32'h5555_5555;
        immediate = 32'h0000_1234;
        pc = 32'h0040_0000;

        // 测试组合 1: d1_sel = 0, d2_sel = 0 -> rs1_data, rs2_data
        d1_sel = 0;
        d2_sel = 0;
        #10;
        $display("Case 1: d1_sel=0 d2_sel=0 -> alu_data_1=0x%h alu_data_2=0x%h", alu_data_1, alu_data_2);

        // 测试组合 2: d1_sel = 1, d2_sel = 0 -> pc, rs2_data
        d1_sel = 1;
        d2_sel = 0;
        #10;
        $display("Case 2: d1_sel=1 d2_sel=0 -> alu_data_1=0x%h alu_data_2=0x%h", alu_data_1, alu_data_2);

        // 测试组合 3: d1_sel = 0, d2_sel = 1 -> rs1_data, immediate
        d1_sel = 0;
        d2_sel = 1;
        #10;
        $display("Case 3: d1_sel=0 d2_sel=1 -> alu_data_1=0x%h alu_data_2=0x%h", alu_data_1, alu_data_2);

        // 测试组合 4: d1_sel = 1, d2_sel = 1 -> pc, immediate
        d1_sel = 1;
        d2_sel = 1;
        #10;
        $display("Case 4: d1_sel=1 d2_sel=1 -> alu_data_1=0x%h alu_data_2=0x%h", alu_data_1, alu_data_2);

        $finish;
    end

endmodule
