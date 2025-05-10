`timescale 1ns/1ps

module pc_adder_tb();
    // Test signals
    reg [31:0] pc;
    reg [31:0] immediate;
    wire [31:0] pc_adder_result;
    
    // Instantiate DUT
    pc_adder dut(
        .pc(pc),
        .immediate(immediate),
        .pc_adder_result(pc_adder_result)
    );
    
    // For waveform generation
    initial begin
        $dumpfile("pc_adder_tb.vcd");
        $dumpvars(0, pc_adder_tb);
        
        // Test case 1: Normal addition
        pc = 32'h00000004;
        immediate = 32'h00000004;
        #10;
        $display("Test 1: PC = %h, Immediate = %h", pc, immediate);
        $display("Expected: %h, Got: %h", ((pc + immediate) & 32'hFFFFFFFC), pc_adder_result);
        
        // Test case 2: Odd numbers
        pc = 32'h00000003;
        immediate = 32'h00000005;
        #10;
        $display("Test 2: PC = %h, Immediate = %h", pc, immediate);
        $display("Expected: %h, Got: %h", ((pc + immediate) & 32'hFFFFFFFC), pc_adder_result);
        
        // Test case 3: Maximum values
        pc = 32'hFFFFFFFF;
        immediate = 32'h00000001;
        #10;
        $display("Test 3: PC = %h, Immediate = %h", pc, immediate);
        $display("Expected: %h, Got: %h", ((pc + immediate) & 32'hFFFFFFFC), pc_adder_result);
        
        #10 $finish;
    end
endmodule