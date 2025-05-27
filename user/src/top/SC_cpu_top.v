module SC_cpu_top #(
        parameter ROM_FILE_PATH = "",
        parameter RAM_FILE_PATH = ""
    )(
        input clk,
        input rst_n
    );

    // output declaration of module SC_cpu_core
    wire [31:0] rom_addr;
    wire [31:0] rom_data;
    wire bus_re;
    wire [3:0] bus_we;
    wire [31:0] bus_addr;
    wire [31:0] bus_wdata;
    wire [31:0] bus_rdata;

    SC_cpu_core
        cpu(
            .clk        (clk),
            .rst_n      (rst_n),
            .rom_addr   (rom_addr),
            .rom_data   (rom_data),
            .bus_re     (bus_re),
            .bus_we     (bus_we),
            .bus_addr   (bus_addr),
            .bus_wdata  (bus_wdata),
            .bus_rdata  (bus_rdata)
        );

    ROM_unit
        #(
            .INIT_FILE_PATH   (ROM_FILE_PATH),
            .ADDR_WIDTH  (16)
        )
        u_ROM_unit (
            .addr  (rom_addr[17:2]),
            .data  (rom_data)
        );

    wire ram_ce;
    wire gpio_ce;

    bus_controller
        bus_ctrl(
            .bus_addr  (bus_addr),
            .bus_re    (bus_re),
            .bus_we    (bus_we),
            .ram_ce    (ram_ce)
        );

    RAM_unit
        #(
            .ADDR_WIDTH  (16),
            .INIT_FILE_PATH (RAM_FILE_PATH)
        )
        u_RAM_unit(
            .clk    (clk),
            .ce     (ram_ce),
            .we     (bus_we),
            .addr   (bus_addr[17:2]),
            .din    (bus_wdata),
            .dout   (bus_rdata)
        );

endmodule
