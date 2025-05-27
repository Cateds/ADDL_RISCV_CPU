module tb_SC_cpu_top_ip();

    reg clk;
    reg rst_n;

    SC_cpu_top_ip
        u_SC_cpu_top_ip(
            .clk   	(clk    ),
            .rst_n 	(rst_n  )
        );

    initial begin
        clk = 0;
        forever
            #5 clk = ~clk;
    end

    initial begin
        rst_n = 0; // Active low reset
        #16 rst_n = 1; // Release reset after 15 time units
    end

    initial begin
        $dumpfile("tb_SC_cpu_top_ip.vcd");
        $dumpvars(0, tb_SC_cpu_top_ip);
        $display("Simulation started...");
        #100;
        $display("Simulation finished.");
        $finish();
    end

endmodule
