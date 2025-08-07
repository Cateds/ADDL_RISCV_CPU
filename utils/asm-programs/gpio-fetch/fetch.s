// fetch.s

_main:
    lui t0, 0x40100 // GPIO 初始地址

    addi t1, zero, 0x00FF // GPIO 输出模式
    sh t1, 4(t0) // 设置 GPIO 输出模式

loopSt:
    lh t3, (t0) // 读取 GPIO 输入值
    srli t3, t3, 8 // 将输入值右移 8 位
    andi t3, t3, 0xFF // 保留低 8 位
    sh t3, 2(t0) // 设置 GPIO 输出值

    jal loopSt  # jump to loopSt and save position to ra
    