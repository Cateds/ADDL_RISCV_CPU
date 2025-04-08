`timescale 1ns / 1ps

module tb_registers;

    // Parameters
    parameter PERIOD = 10;  // Clock period 10ns

    // Input signals
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg clk;
    reg rst_n;
    reg we;
    reg [31:0] write_data;

    // Output signals
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    // Clock generation
    initial begin
        clk = 0;
        forever
            #(PERIOD/2) clk = ~clk;
    end

    // Waveform dump
    initial begin
        $dumpfile("tb_registers.vcd");
        $dumpvars(0, tb_registers);
    end

    // Test sequence
    initial begin
        // Initialize and reset
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        we = 0;
        rst_n = 0;
        write_data = 0;

        // Release reset
        #(PERIOD*2) rst_n = 1;

        // Test case 1: Write to register 1
        #PERIOD;
        rd = 5'd1;
        write_data = 32'hAABBCCDD;
        we = 1;
        #PERIOD;
        we = 0;

        // Test case 2: Read from register 1
        rs1 = 5'd1;
        rs2 = 5'd0;
        #PERIOD;

        // Test case 3: Write to register 2
        rd = 5'd2;
        write_data = 32'h11223344;
        we = 1;
        #PERIOD;
        we = 0;

        // Test case 4: Read from registers 1 and 2
        rs1 = 5'd1;
        rs2 = 5'd2;
        #PERIOD;

        // Test case 5: Write to register 0 (should have no effect)
        rd = 5'd0;
        write_data = 32'hFFFFFFFF;
        we = 1;
        #PERIOD;
        we = 0;

        // Test case 6: Read from register 0
        rs1 = 5'd0;
        rs2 = 5'd1;
        #PERIOD;

        // Test case 7: Multiple writes to different registers
        rd = 5'd10;
        write_data = 32'h55555555;
        we = 1;
        #PERIOD;

        rd = 5'd20;
        write_data = 32'hAAAAAAAA;
        #PERIOD;
        we = 0;

        // Test case 8: Read from multiple registers
        rs1 = 5'd10;
        rs2 = 5'd20;
        #PERIOD;

        // Test case 9: Reset test
        rst_n = 0;
        #PERIOD;
        rst_n = 1;
        #PERIOD;

        // Test case 10: Read after reset
        rs1 = 5'd1;
        rs2 = 5'd2;
        #PERIOD;

        // End simulation
        $display("Simulation finished at time %t", $time);
        $finish;
    end

    // Output monitoring
    initial begin
        $monitor("Time=%0t: rst_n=%0b, we=%0b, rd=%0d, write_data=0x%h, rs1=%0d, rs1_data=0x%h, rs2=%0d, rs2_data=0x%h",
                 $time, rst_n, we, rd, write_data, rs1, rs1_data, rs2, rs2_data);
    end

    // Instantiate the DUT
    registers u_registers (
                  .rs1(rs1),
                  .rs2(rs2),
                  .rd(rd),
                  .clk(clk),
                  .rst_n(rst_n),
                  .we(we),
                  .write_data(write_data),
                  .rs1_data(rs1_data),
                  .rs2_data(rs2_data)
              );

endmodule
