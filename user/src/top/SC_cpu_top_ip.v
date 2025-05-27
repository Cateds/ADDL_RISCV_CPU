module SC_cpu_top_ip(
        input clk,
        input rst_n
    );

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

    dist_mem_ROM
        u_dist_mem_ROM(
            .a       (rom_addr[17:2]),
            .spo     (rom_data)
        );

    wire ram_ce;
    wire gpioA_ce;
    wire gpioB_ce;

    bus_controller
        bus_ctrl(
            .bus_addr  (bus_addr),
            .bus_re    (bus_re),
            .bus_we    (bus_we),
            .ram_ce    (ram_ce),
            .gpioA_ce  (gpioA_ce),
            .gpioB_ce  (gpioB_ce)
        );

    blk_mem_RAM
        u_blk_mem_RAM(
            .clka      (~clk),
            .ena       (ram_ce),
            .wea       (bus_we),
            .addra     (bus_addr[17:2]),
            .dina      (bus_wdata),
            .douta     (bus_rdata)
        );

endmodule
