`timescale 1ns/1ps
`include "../test_utils.vh"

module tb_memory_access_unit();

    MEM_OP_ENUM mem_op_enum();
    MEM_SEL_ENUM mem_sel_enum();

    // input declaration of module memory_access_unit
    reg [1:0] mem_op;
    reg [2:0] mem_sel;
    reg [31:0] mem_addr;
    reg [31:0] mem_wdata;
    reg [31:0] bus_rdata;

    // output declaration of module memory_access_unit
    reg [31:0] mem_rdata;
    reg bus_re;
    reg [3:0] bus_we;
    reg [31:0] bus_addr;
    reg [31:0] bus_wdata;

    // expected output data
    reg [31:0] expected_mem_rdata;
    reg [31:0] expected_bus_wdata;
    reg [31:0] expected_bus_re;
    reg [31:0] expected_bus_we;
    reg [31:0] expected_bus_addr;

    memory_access_unit
        u_memory_access_unit(
            .mem_op    	(mem_op     ),
            .mem_sel   	(mem_sel    ),
            .mem_addr  	(mem_addr   ),
            .mem_wdata 	(mem_wdata  ),
            .mem_rdata 	(mem_rdata  ),
            .bus_re    	(bus_re     ),
            .bus_we    	(bus_we     ),
            .bus_addr  	(bus_addr   ),
            .bus_wdata 	(bus_wdata  ),
            .bus_rdata 	(bus_rdata  )
        );

    task check_result;
        parameter BUFFER_LEN = 128;
        input [BUFFER_LEN*8-1:0] description;
        begin
            #1;
            $display("Test: %0s (@time: %0t)", description, $time);
            `PRINT_TEST_HEX("mem_rdata", mem_rdata, expected_mem_rdata);
            `PRINT_TEST_HEX("bus_wdata", bus_wdata, expected_bus_wdata);
            `PRINT_TEST_HEX("bus_re", bus_re, expected_bus_re);
            `PRINT_TEST_HEX("bus_we", bus_we, expected_bus_we);
            `PRINT_TEST_HEX("bus_addr", bus_addr, expected_bus_addr);
        end
    endtask

    initial begin
        $dumpfile("tb_memory_access_unit.vcd");
        $dumpvars(0, tb_memory_access_unit);
    end

    initial begin

    end

endmodule
