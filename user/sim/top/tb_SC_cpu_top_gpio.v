`timescale 1ns/1ps
module tb_SC_cpu_top_gpio();
    reg clk;
    reg rst_n;

    // GPIO 测试信号
    reg [15:0] gpio_drive_data;
    reg [15:0] gpio_drive_enable;
    wire [15:0] gpioA_io;

    // GPIO 双向引脚驱动逻辑
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : gpio_drive
            assign gpioA_io[i] = gpio_drive_enable[i] ? gpio_drive_data[i] : 1'bz;
        end
    endgenerate

    SC_cpu_top_gpio
        #(
            .ROM_FILE_PATH   (
                "D:/MyDocs/Codes/Embedded_FPGA/ADDL_RISCV_CPU/user/data/rom_init.hex"
            ),
            .RAM_FILE_PATH   (
                "D:/MyDocs/Codes/Embedded_FPGA/ADDL_RISCV_CPU/user/data/ram_init.hex"
            )
        )
        u_cpu_top (
            .clk   	(clk    ),
            .rst_n 	(rst_n  ),
            .gpioA_io(gpioA_io)
        );
    initial begin
        clk = 0;
        gpio_drive_data = 16'hAA;
        gpio_drive_enable = 16'h0000; // 开始时不驱动，让CPU控制
        forever
            #5 clk = ~clk; // 10 time unit clock period
    end
    initial begin
        rst_n = 0; // Active low reset
        #16 rst_n = 1; // Release reset after 15 time units
    end

    // GPIO 测试任务
    initial begin
        gpio_drive_enable = 16'hFFFF; // 使能外部驱动
        gpio_drive_data = 16'h5555;   // 发送测试数据
    end
    initial begin
        $dumpfile("tb_SC_cpu_top_gpio.vcd");
        $dumpvars(0, tb_SC_cpu_top_gpio);
        $display("GPIO仿真开始...");
        $monitor("时间=%0t, gpioA_io=%h, gpio_drive_enable=%h, gpio_drive_data=%h",
                 $time, gpioA_io, gpio_drive_enable, gpio_drive_data);
        #300;
        $display("GPIO仿真结束.");
        $finish();
    end

endmodule
