// 基于 RV32I 指令集的流水灯程序
// GPIO[8]: 开关流水灯运行
// GPIO[9]: 开关流水灯方向

_main:
    # 初始化 GPIO 基地址
    lui x10, 0x40100          # x10 = GPIO 基地址（0x40100000）
    
    # 配置 GPIO 模式 - 设置低8位为输出，高位为输入
    addi x11, x10, 0x04       # x11 = GPIO 配置寄存器地址
    addi x12, x0, 0xFF        # x12 = 0xFF，设置低8位为输出模式
    sh x12, 0(x11)            # 写 GPIO 模式配置寄存器
    
    # 初始化变量
    addi x13, x0, 1           # x13 = 当前灯状态（从 0x01 开始）
    addi x14, x10, 0x02       # x14 = GPIO 输出寄存器地址
    addi x15, x0, 0           # x15 = 方向标志（0=正向，1=反向）
    addi x16, x0, 1           # x16 = 运行标志（0=停止，1=运行）

main_loop:
    # 读取 GPIO 输入状态
    lh x17, 0(x10)            # 读取 GPIO 输入值
    srli x18, x17, 8          # 右移8位获取输入位
    andi x19, x18, 1          # 提取 GPIO[8] - 运行开关
    srli x20, x18, 1          # 右移1位
    andi x20, x20, 1          # 提取 GPIO[9] - 方向开关
    
    # 检查运行开关
    beq x19, x0, stop_lights  # 如果 GPIO[8] = 0，停止流水灯
    
    # 更新方向标志
    add x15, x0, x20          # x15 = GPIO[9] 状态
    
    # 点亮当前灯
    sh x13, 0(x14)            # 输出当前灯状态
    
    # 延时
    lui x21, 0x00600             # x21 = 0x6000 = 24576

delay_loop:
    addi x21, x21, -1         # 计数器减1
    bne x21, x0, delay_loop   # 如果不为0继续延时
    
    # 更新灯的状态
    beq x15, x0, forward      # 如果方向为0，正向移动
    
backward:
    # 反向移动：右移一位，如果到达边界则回到 0x80
    srli x22, x13, 1          # x22 = x13 >> 1
    bne x22, x0, update_backward  # 如果不为0，使用右移结果
    addi x13, x0, 0x80        # 如果为0，重置为 0x80
    jal x0, main_loop         # 跳回主循环

update_backward:
    add x13, x0, x22          # x13 = x22
    jal x0, main_loop         # 跳回主循环

forward:
    # 正向移动：左移一位，如果超过 0x80 则回到 0x01
    slli x22, x13, 1          # x22 = x13 << 1
    addi x23, x0, 0x100       # x23 = 256 (0x100)
    blt x22, x23, update_forward  # 如果 x22 < 256，使用左移结果
    addi x13, x0, 1           # 如果超过范围，重置为 0x01
    jal x0, main_loop         # 跳回主循环

update_forward:
    add x13, x0, x22          # x13 = x22
    jal x0, main_loop         # 跳回主循环

stop_lights:
    # 关闭所有灯
    sh x0, 0(x14)             # 输出 0，关闭所有灯
    
    # 短延时后重新检查开关状态
    addi x21, x0, 1000        # 短延时计数器
short_delay:
    addi x21, x21, -1         # 计数器减1
    bne x21, x0, short_delay  # 如果不为0继续延时
    
    jal x0, main_loop         # 跳回主循环检查开关状态
