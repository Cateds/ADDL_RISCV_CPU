# RISC-V CPU 模块说明文档

本文档介绍了 RISC-V CPU 实现中各个关键模块的功能和实现细节。

## 文件目录结构

```text
modules/
├── arithmetic_logic_unit/        # 算术逻辑单元
│   ├── arithmetic_logic_unit.v   # ALU 顶层模块
│   ├── alu_input_mux.v           # ALU 输入多路复用器
│   └── alu_compute_unit.v        # ALU 计算单元
├── ctrl_and_state_reg/           # 控制和状态寄存器
│   ├── CSR_calculator.v          # CSR 计算单元
│   ├── CSR_registers.v           # CSR 寄存器组
│   └── CSR.v                     # CSR 顶层模块
├── instruction_decoder/          # 指令解码器
│   ├── instr_B_type.v            # B 型指令解码器
│   ├── instr_I_type.v            # I 型指令解码器
│   ├── instr_J_type.v            # J 型指令解码器
│   ├── instr_R_type.v            # R 型指令解码器
│   ├── instr_S_type.v            # S 型指令解码器
│   ├── instr_U_type.v            # U 型指令解码器
│   └── instruction_decoder.v     # 指令解码器顶层模块
├── branch.v                      # 分支单元
├── memory_controller.v           # 存储器控制器
├── pc_adder.v                    # PC 加法器
├── program_counter.v             # 程序计数器
├── registers.v                   # 寄存器组
└── write_back_unit.v             # 写回单元
```

## 核心模块概览

### 程序计数器 (Program Counter)

- 文件：`program_counter.v`
- 功能：管理 CPU 的指令执行顺序
- 主要特性：
  - 支持顺序执行（PC+4）
  - 支持分支跳转（branch）
  - 包含复位和使能控制
  - 提供下一条指令地址输出

### 寄存器组 (Registers)

- 文件：`registers.v`
- 功能：实现 CPU 的通用寄存器组
- 主要特性：
  - 32 个 32 位寄存器
  - 支持两个源寄存器读取（rs1, rs2）
  - 支持一个目标寄存器写入（rd）
  - 包含写使能控制
  - x0 寄存器永远为 0

### 算术逻辑单元 (ALU)

- 文件：`arithmetic_logic_unit/arithmetic_logic_unit.v`
- 功能：执行算术和逻辑运算
- 组成部分：
  - ALU 输入多路复用器
  - ALU 计算单元
- 支持操作：
  - 基本算术运算
  - 逻辑运算
  - 比较运算

### 分支单元 (Branch Unit)

- 文件：`branch.v`
- 功能：处理条件分支和跳转指令
- 支持的比较类型：
  - 相等/不相等比较（EQ/NE）
  - 有符号大小比较（LT/GE）
  - 无符号大小比较（LTU/GEU）

### PC 加法器 (PC Adder)

- 文件：`pc_adder.v`
- 功能：计算下一条指令地址
- 特点：支持指令的顺序执行（PC+4）

### 写回单元 (Write Back Unit)

- 文件：`write_back_unit.v`
- 功能：处理数据写回寄存器组
- 特点：
  - 选择写回数据来源
  - 控制写回时序

### 存储器控制器 (Memory Controller)

- 文件：`memory_controller.v`
- 功能：管理内存访问操作
- 支持：
  - 指令获取
  - 数据读写

## 控制和状态寄存器 (CSR)

位于 `ctrl_and_state_reg/` 目录下：

- CSR 寄存器组实现
- CSR 相关指令的处理
- 系统控制和状态管理

## 指令解码器 (Instruction Decoder)

位于 `instruction_decoder/` 目录下：

- 支持所有 RISC-V RV32I 基本指令集
- 包含各类型指令的专用解码器：
  - R 型指令（寄存器-寄存器运算）
  - I 型指令（立即数运算和访存）
  - S 型指令（存储指令）
  - B 型指令（分支指令）
  - U 型指令（长立即数）
  - J 型指令（跳转指令）
