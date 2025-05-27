module bus_controller(
        input [31:0] bus_addr,
        input bus_re,
        input [3:0] bus_we,

        output reg ram_ce,
        output reg gpioA_ce,
        output reg gpioB_ce
    );

    assign bus_ce = | {bus_we, bus_re}; // 读或写操作时，bus_ce 为高电平

    task set_default;
        begin
            ram_ce = 1'b0;
            gpioA_ce = 1'b0;
            gpioB_ce = 1'b0;
        end
    endtask

    task set_gpio;
        begin
            case(bus_addr[15])
                1'b0:
                    gpioA_ce = 1'b1; // GPIO A 设备
                1'b1:
                    gpioB_ce = 1'b1; // GPIO B 设备
            endcase
        end
    endtask

    task set_peripheral;
        case (bus_addr[23:16])
            8'h10:  // GPIO 设备
                set_gpio;
            default:
                set_default; // 其他外设地址，禁用所有设备
        endcase
    endtask

    always @(*) begin
        set_default;
        if (bus_ce)
        case (bus_addr[31:24])
            8'h10:  // 片上 RAM
                ram_ce = 1'b1;
            8'h40:  // 外设集合
                set_peripheral;
            default:  // 未知地址，禁用所有设备
                set_default;
        endcase
    end

endmodule
