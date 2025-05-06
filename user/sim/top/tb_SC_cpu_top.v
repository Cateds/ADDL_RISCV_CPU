`timescale 1ns/1ps

module tb_SC_cpu_top();

    reg clk;
    reg rst_n;

    SC_cpu_top
        u_cpu_top(
            .clk   	(clk    ),
            .rst_n 	(rst_n  )
        );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time unit clock period
    end

    initial begin
        rst_n = 0; // Active low reset
        #16 rst_n = 1; // Release reset after 15 time units
    end

    initial begin
        $dumpfile("tb_SC_cpu_top.vcd");
        $dumpvars(0, tb_SC_cpu_top);
        $display("Simulation started...");
        #400;
        $display("Simulation finished.");
        $finish();
    end

endmodule
