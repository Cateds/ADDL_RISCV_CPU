`timescale 1ns/1ps

module tb_pc_mips();
    // Inputs
    reg clk;
    reg rst;
    reg branch;
    reg [31:0] branch_addr;
    
    // Outputs
    wire [31:0] pc;
    wire [31:0] pc_plus_4;
    
    // Expected outputs for verification
    reg [31:0] expected_pc;
    reg [31:0] expected_pc_plus_4;
    
    // Instantiate the Unit Under Test (UUT)
    pc_mips uut (
        .clk(clk),
        .rst(rst),
        .branch(branch),
        .branch_addr(branch_addr),
        .pc(pc),
        .pc_plus_4(pc_plus_4)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end
    
    // Test vectors and monitoring
    initial begin
        // Initialize inputs
        rst = 1;
        branch = 0;
        branch_addr = 32'h0;
        expected_pc = 32'h0;
        expected_pc_plus_4 = 32'h4;
        
        // Setup waveform dumping
        $dumpfile("tb_pc_mips.vcd");
        $dumpvars(0, tb_pc_mips);
        
        // Reset sequence
        #20;
        rst = 0;
        
        // Test case 1: Normal PC increment
        #10;
        check_outputs("After reset");
        
        // Test case 2: Normal PC increment again
        #10;
        expected_pc = 32'h4;
        expected_pc_plus_4 = 32'h8;
        check_outputs("After first increment");
        
        // ===== 新增10个时钟周期的连续自增测试 =====
        // Test case: 连续自增测试3-10
        for (integer i = 0; i < 8; i = i + 1) begin
            #10; // 等待一个时钟周期
            expected_pc = 32'h8 + (i * 4);
            expected_pc_plus_4 = 32'hC + (i * 4);
            check_outputs("After continuous increment %0d");
        end
        
        // Test case: 分支跳转前的最后一次自增
        #10;
        expected_pc = 32'h28; // 0x8 + (8 * 4) = 0x28
        expected_pc_plus_4 = 32'h2C;
        check_outputs("Before branch, final increment");
        
        // Test case 3: Branch taken
        branch = 1;
        branch_addr = 32'h100;
        #10;
        expected_pc = 32'h2C; // 之前的PC+4
        expected_pc_plus_4 = 32'h30;
        check_outputs("Before branch effect");
        
        #10;
        expected_pc = 32'h100;
        expected_pc_plus_4 = 32'h104;
        check_outputs("After branch taken");
        
        // Test case 4: Return to normal PC increment
        branch = 0;
        #10;
        expected_pc = 32'h104;
        expected_pc_plus_4 = 32'h108;
        check_outputs("After returning to normal increment");
        
        // Test case 5: Another branch
        branch = 1;
        branch_addr = 32'h200;
        #20;
        expected_pc = 32'h200;
        expected_pc_plus_4 = 32'h204;
        check_outputs("After second branch taken");
        
        // Test case 6: Reset during operation
        #5;
        rst = 1;
        #10;
        expected_pc = 32'h0;
        expected_pc_plus_4 = 32'h4;
        check_outputs("After mid-operation reset");
        
        // Finish simulation
        #10;
        $display("Test completed successfully");
        $finish;
    end
    
    // Task to check outputs and display results
    task check_outputs;
        input [200:0] test_case;
        begin
            $display("Test case: %s", test_case);
            
            if (pc === expected_pc) begin
                $display("PASS: PC = %h (expected: %h)", pc, expected_pc);
            end else begin
                $display("FAIL: PC = %h (expected: %h)", pc, expected_pc);
            end
            
            if (pc_plus_4 === expected_pc_plus_4) begin
                $display("PASS: PC+4 = %h (expected: %h)", pc_plus_4, expected_pc_plus_4);
            end else begin
                $display("FAIL: PC+4 = %h (expected: %h)", pc_plus_4, expected_pc_plus_4);
            end
            
            $display("------------------------------------");
        end
    endtask
    
endmodule