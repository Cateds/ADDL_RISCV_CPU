_main:
    lui t0, 0x40100 // GPIO 初始地址

    addi t1, zero, 0xFF // GPIO 输出模式
    sh t1, 4(t2) // 设置 GPIO 输出模式

    addi t2, t0, 0x02 // GPIO 输出寄存器地址
    sh t3, 2(t2) // 设置 GPIO 输出值

    addi t2, t0, 0x04 // GPIO 配置寄存器地址
    sh t1, 4(t2) // 设置 GPIO 输入模式

    addi t2, t0, 0x00 // GPIO 输入寄存器地址
    lh t4, 0(t2) // 读取 GPIO 输入值
    