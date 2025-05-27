`timescale 1ns/1ps

module tb_gpio();

    // === 信号声明 ===
    
    // 时钟和复位
    reg clk;
    reg rst_n;
    
    // 总线接口信号
    reg gpio_ce;           // GPIO片选信号
    reg [3:0] bus_we;      // 字节写使能 [3:0] -> [31:24][23:16][15:8][7:0]
    reg bus_re;            // 读使能
    reg [31:0] bus_wdata;  // 写数据
    reg [16:0] bus_addr;   // 地址
    wire [31:0] bus_rdata; // 读数据
    
    // GPIO接口
    wire [15:0] gpio_io;
    
    // 外部输入模拟
    reg [15:0] external_input;   // 模拟外部输入信号
    reg [15:0] input_enable;     // 控制哪些GPIO作为输入 (1=外部驱动, 0=高阻)
    
    // === GPIO三态控制（模拟外部设备） ===
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : external_drive
            assign gpio_io[i] = input_enable[i] ? external_input[i] : 1'bz;
        end
    endgenerate
    
    // === 实例化被测模块 ===
    gpio uut (
        .clk(clk),
        .rst_n(rst_n),
        .gpio_ce(gpio_ce),
        .bus_we(bus_we),
        .bus_re(bus_re),
        .bus_wdata(bus_wdata),
        .bus_addr(bus_addr),
        .bus_rdata(bus_rdata),
        .gpio_io(gpio_io)
    );
    
    // === 时钟生成 ===
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz时钟
    end
    
    // === 测试任务定义 ===
    
    // 系统复位
    task system_reset;
        begin
            $display("[%0t] 执行系统复位", $time);
            rst_n = 0;
            gpio_ce = 0;
            bus_we = 4'b0000;
            bus_re = 0;
            bus_wdata = 32'h0;
            bus_addr = 17'h0;
            external_input = 16'h0;
            input_enable = 16'h0;
            
            repeat(3) @(posedge clk);
            rst_n = 1;
            @(posedge clk);
            $display("[%0t] 系统复位完成", $time);
        end
    endtask
    
    // 写GPIO寄存器
    task write_gpio_register(
        input [16:0] addr,
        input [31:0] data,
        input [3:0] byte_enable,
        input [512:0] description
    );
        begin
            $display("[%0t] 写寄存器: %0s", $time, description);
            $display("        地址=0x%04X, 数据=0x%08X, 字节使能=%04b", addr, data, byte_enable);
            
            @(posedge clk);
            gpio_ce = 1;
            bus_addr = addr;
            bus_wdata = data;
            bus_we = byte_enable;
            bus_re = 0;
            
            @(posedge clk);
            gpio_ce = 0;
            bus_we = 4'b0000;
            
            @(posedge clk);
        end
    endtask
    
    // 读GPIO寄存器
    task read_gpio_register(
        input [16:0] addr,
        input [512:0] description,
        output [31:0] read_value
    );
        begin
            $display("[%0t] 读寄存器: %0s", $time, description);
            $display("        地址=0x%04X", addr);
            
            @(posedge clk);
            gpio_ce = 1;
            bus_addr = addr;
            bus_re = 1;
            bus_we = 4'b0000;
            
            @(posedge clk);  // 同步读取需要等待一个时钟周期
            @(posedge clk);  // 数据在第二个时钟周期有效
            read_value = bus_rdata;
            
            gpio_ce = 0;
            bus_re = 0;
            
            $display("        读取结果=0x%08X", read_value);
            @(posedge clk);
        end
    endtask
    
    // 设置外部输入
    task set_external_inputs(
        input [15:0] input_value,
        input [15:0] enable_mask,
        input [512:0] description
    );
        begin
            $display("[%0t] 设置外部输入: %0s", $time, description);
            $display("        输入值=0x%04X, 使能掩码=0x%04X", input_value, enable_mask);
            
            external_input = input_value;
            input_enable = enable_mask;
            #10;  // 等待信号稳定
        end
    endtask
    
    // 验证GPIO输出
    task verify_gpio_output(
        input [15:0] expected_value,
        input [15:0] output_mask,
        input [512:0] description
    );
        reg [15:0] actual_output;
        begin
            actual_output = gpio_io & output_mask;  // 只检查输出引脚
            if (actual_output === (expected_value & output_mask)) begin
                $display("[%0t] ✓ 验证通过: %0s", $time, description);
                $display("        期望=0x%04X, 实际=0x%04X", expected_value & output_mask, actual_output);
            end else begin
                $display("[%0t] ✗ 验证失败: %0s", $time, description);
                $display("        期望=0x%04X, 实际=0x%04X", expected_value & output_mask, actual_output);
            end
        end
    endtask
    
    // === 主测试流程 ===
    reg [31:0] read_data;
    
    initial begin
        $display("==========================================");
        $display("         GPIO模块功能测试");
        $display("==========================================");
        
        // 生成波形文件
        $dumpfile("tb_gpio.vcd");
        $dumpvars(0, tb_gpio);
        
        // 测试1: 系统复位
        $display("\n=== 测试1: 系统复位 ===");
        system_reset();
        
        // 验证复位后的状态
        read_gpio_register(17'h08, "读取输出寄存器(复位后)", read_data);
        read_gpio_register(17'h10, "读取配置寄存器(复位后)", read_data);
        
        // 测试2: 配置寄存器功能
        $display("\n=== 测试2: 配置寄存器读写测试 ===");
        
        // 写入配置寄存器 (地址0x04-0x05, 数据在低16位)
        // 配置低8位为输出(0xFF)，高8位为输入(0x00)
        write_gpio_register(17'h10, 32'h000000FF, 4'b0011, "配置GPIO[7:0]=输出, GPIO[15:8]=输入");
        
        // 读回验证
        read_gpio_register(17'h10, "验证配置寄存器", read_data);
        if (read_data[15:0] == 16'h00FF) begin
            $display("✓ 配置寄存器写入正确");
        end else begin
            $display("✗ 配置寄存器写入错误，期望=0x00FF，实际=0x%04X", read_data[15:0]);
        end
        
        // 测试3: 输出寄存器功能
        $display("\n=== 测试3: 输出寄存器读写测试 ===");
        
        // 写入输出寄存器 (地址0x02-0x03, 数据在高16位)
        // 数据0x5AA5应该放在bus_wdata[31:16]，使用bus_we[3:2]
        write_gpio_register(17'h08, 32'h5AA50000, 4'b1100, "设置输出值为0x5AA5");
        
        // 读回验证
        read_gpio_register(17'h08, "验证输出寄存器", read_data);
        if (read_data[31:16] == 16'h5AA5) begin
            $display("✓ 输出寄存器写入正确");
        end else begin
            $display("✗ 输出寄存器写入错误，期望=0x5AA5，实际=0x%04X", read_data[31:16]);
        end
        
        // 验证GPIO输出
        verify_gpio_output(16'h00A5, 16'h00FF, "验证GPIO低8位输出");
        
        // 测试4: 输入功能测试
        $display("\n=== 测试4: GPIO输入功能测试 ===");
        
        // 设置外部输入信号 (只对配置为输入的引脚有效)
        set_external_inputs(16'h1234, 16'hFF00, "外部输入0x1234到GPIO[15:8]");
        
        // 读取输入寄存器
        read_gpio_register(17'h00, "读取GPIO输入状态", read_data);
        
        // 验证读取结果：低8位应该是输出值(0xA5)，高8位应该是输入值(0x12)
        if (read_data[15:0] == 16'h12A5) begin
            $display("✓ GPIO输入读取正确");
        end else begin
            $display("✗ GPIO输入读取错误，期望=0x12A5，实际=0x%04X", read_data[15:0]);
        end
        
        // 测试5: 字节选通写入测试
        $display("\n=== 测试5: 字节选通写入测试 ===");
        
        // 测试输出寄存器的字节写入
        $display("\n--- 输出寄存器字节写入测试 ---");
        
        // 只写输出寄存器低字节 (GPIO[7:0])
        write_gpio_register(17'h08, 32'h00330000, 4'b0100, "只写输出低字节=0x33");
        read_gpio_register(17'h08, "验证低字节写入", read_data);
        verify_gpio_output(16'h0033, 16'h00FF, "验证GPIO[7:0]=0x33");
        
        // 只写输出寄存器高字节 (GPIO[15:8])
        write_gpio_register(17'h08, 32'h77000000, 4'b1000, "只写输出高字节=0x77");
        read_gpio_register(17'h08, "验证高字节写入", read_data);
        
        // 测试配置寄存器的字节写入
        $display("\n--- 配置寄存器字节写入测试 ---");
        
        // 只写配置寄存器低字节
        write_gpio_register(17'h10, 32'h000000AA, 4'b0001, "只写配置低字节=0xAA");
        read_gpio_register(17'h10, "验证配置低字节", read_data);
        
        // 只写配置寄存器高字节
        write_gpio_register(17'h10, 32'h0000BB00, 4'b0010, "只写配置高字节=0xBB");
        read_gpio_register(17'h10, "验证配置高字节", read_data);
        
        // 测试6: 混合输入输出模式
        $display("\n=== 测试6: 混合输入输出模式测试 ===");
        
        // 重新配置：奇数位输出，偶数位输入
        write_gpio_register(17'h10, 32'h0000AAAA, 4'b0011, "配置奇数位=输出，偶数位=输入");
        
        // 设置输出值
        write_gpio_register(17'h08, 32'hCCCC0000, 4'b1100, "设置输出值=0xCCCC");
        
        // 设置外部输入
        set_external_inputs(16'h5555, 16'h5555, "外部输入0x5555到偶数位");
        
        // 读取并验证
        read_gpio_register(17'h00, "读取混合模式结果", read_data);
        $display("混合模式结果: GPIO=0x%04X (应该是0x?C?C和0x?5?5的组合)", read_data[15:0]);
        
        // 测试7: 总线高阻态测试
        $display("\n=== 测试7: 总线高阻态测试 ===");
        
        gpio_ce = 0;  // 取消片选
        bus_re = 1;   // 保持读使能
        
        #20;
        if (bus_rdata === 32'bz) begin
            $display("✓ 总线高阻态测试通过");
        end else begin
            $display("✗ 总线高阻态测试失败，应该为高阻态，实际=0x%08X", bus_rdata);
        end
        
        // 测试8: 动态信号变化测试
        $display("\n=== 测试8: 动态信号变化测试 ===");
        
        // 配置所有GPIO为输入
        write_gpio_register(17'h10, 32'h00000000, 4'b0011, "配置所有GPIO为输入");
        
        // 启动连续读取
        gpio_ce = 1;
        bus_re = 1;
        bus_addr = 17'h00;
        
        // 改变外部输入，观察响应
        set_external_inputs(16'h0000, 16'hFFFF, "外部输入=0x0000");
        repeat(3) @(posedge clk);
        $display("输入0x0000，读取=0x%04X", bus_rdata[15:0]);
        
        set_external_inputs(16'hFFFF, 16'hFFFF, "外部输入=0xFFFF");
        repeat(3) @(posedge clk);
        $display("输入0xFFFF，读取=0x%04X", bus_rdata[15:0]);
        
        set_external_inputs(16'hA5A5, 16'hFFFF, "外部输入=0xA5A5");
        repeat(3) @(posedge clk);
        $display("输入0xA5A5，读取=0x%04X", bus_rdata[15:0]);
        
        // 清理信号
        gpio_ce = 0;
        bus_re = 0;
        
        $display("\n==========================================");
        $display("         GPIO模块测试完成");
        $display("==========================================");
        
        // 额外等待时间以观察波形
        repeat(10) @(posedge clk);
        
        $finish;
    end
    
    // === 信号监控 ===
    always @(posedge clk) begin
        if (gpio_ce && (bus_re || |bus_we)) begin
            $display("[%0t] 总线活动: CE=%b, RE=%b, WE=%04b, ADDR=0x%04X, WDATA=0x%08X, RDATA=0x%08X, GPIO=0x%04X",
                     $time, gpio_ce, bus_re, bus_we, bus_addr, bus_wdata, bus_rdata, gpio_io);
        end
    end

endmodule