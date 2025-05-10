module tb_SC_cpu_core_HelloWorld();

    // input signal declaration
    reg clk;
    reg rst_n;
    reg [31:0] rom_data;
    reg [31:0] bus_rdata;

    // output declaration of module SC_cpu_core
    wire [31:0] rom_addr;
    wire bus_re;
    wire [3:0] bus_we;
    wire [31:0] bus_addr;
    wire [31:0] bus_wdata;

    SC_cpu_core
        u_SC_cpu_core(
            .clk       	(clk        ),
            .rst_n     	(rst_n      ),
            .rom_addr  	(rom_addr   ),
            .rom_data  	(rom_data   ),
            .bus_re    	(bus_re     ),
            .bus_we    	(bus_we     ),
            .bus_addr  	(bus_addr   ),
            .bus_wdata 	(bus_wdata  ),
            .bus_rdata 	(bus_rdata  )
        );

endmodule

module tb_SC_cpu_core_HelloWorld_OutputStack(
        input clk,
        input rst_n,
        input [31:0] addr,
        input [31:0] wdata,
        input [3:0] we
    );
endmodule
