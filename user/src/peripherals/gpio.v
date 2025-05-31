module gpio(
        // ----- Clock Sync Signals Connection -----
        input clk,
        input rst_n,
        input gpio_ce,

        // ----- Internal Signals Connection -----
        input [3:0] bus_we,
        input bus_re,
        input [31:0] bus_wdata,
        input [15:0] bus_addr,
        output [31:0] bus_rdata,

        // ----- External Signals Connection -----
        inout [15:0] gpio_io
    );

    // GPIO 寄存器定义
    reg [15:0] gpio_output_reg;  // 0x02-0x03: 输出寄存器
    reg [15:0] gpio_config_reg;  // 0x04-0x05: 配置寄存器 (0=输入, 1=输出)
    reg [31:0] bus_rdata_reg;    // 总线读数据寄存器

    // GPIO 三态控制逻辑 (使用generate块和assign语句)
    genvar j;
    generate
        for (j=0; j<16; j=j+1) begin : gpio_ctrl
            assign gpio_io[j] = gpio_config_reg[j] ? gpio_output_reg[j] : 1'bz;
        end
    endgenerate    // 同步读操作 (32位字对齐，但内部寄存器16位对齐)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bus_rdata_reg <= 32'b0;
        end
        else if (gpio_ce && bus_re) begin
            case (bus_addr[15:0])  // 使用字地址进行寄存器选择
                16'h0000: // 字地址0x00: 包含输入寄存器(0x00-0x01)和输出寄存器(0x02-0x03)
                    bus_rdata_reg <= {gpio_output_reg, gpio_io};  // [31:16]=输出, [15:0]=输入
                16'h0001: // 字地址0x01: 包含配置寄存器(0x04-0x05)
                    bus_rdata_reg <= {16'b0, gpio_config_reg};    // [15:0]=配置
                default:
                    bus_rdata_reg <= 32'b0;
            endcase
        end
    end

    // 总线输出控制 - 默认高阻态，只有在片选且读使能时才输出
    assign bus_rdata = (gpio_ce && bus_re) ? bus_rdata_reg : 32'bz;    // 总线写操作 (时序逻辑)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gpio_output_reg <= 16'b0;
            gpio_config_reg <= 16'b0;  // 默认全部为输入模式
        end
        else if (gpio_ce && (|bus_we)) begin
            case (bus_addr[15:0])  // 使用字地址进行寄存器选择
                16'h0000: begin // 字地址0x00: 输入寄存器(只读) + 输出寄存器
                    // 输出寄存器在高16位 (0x02-0x03对应bus_we[3:2])
                    if (bus_we[2])  // 对应 bus_wdata[23:16] -> gpio_output_reg[7:0]
                        gpio_output_reg[7:0] <= bus_wdata[23:16];
                    if (bus_we[3])  // 对应 bus_wdata[31:24] -> gpio_output_reg[15:8]
                        gpio_output_reg[15:8] <= bus_wdata[31:24];
                    // 注意: 输入寄存器在低16位，但它是只读的，不处理bus_we[1:0]
                end
                16'h0001: begin // 字地址0x01: 配置寄存器(0x04-0x05对应bus_we[1:0])
                    if (bus_we[0])  // 对应 bus_wdata[7:0] -> gpio_config_reg[7:0]
                        gpio_config_reg[7:0] <= bus_wdata[7:0];
                    if (bus_we[1])  // 对应 bus_wdata[15:8] -> gpio_config_reg[15:8]
                        gpio_config_reg[15:8] <= bus_wdata[15:8];
                end
            endcase
        end
    end

endmodule
