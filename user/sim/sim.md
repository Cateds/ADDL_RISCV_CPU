# RISC-V CPU 仿真测试文档

本文档介绍了 RISC-V CPU 仿真测试相关的目录结构和测试文件组织方式。

## 目录组织原则

`sim` 的目录结构和 `src` 类似，旨在如果在 `src` 中有模块 `src/xyz/abc.v` 的实现，则其对应的测试文件应该位于 `sim/xyz/tb_abc.v`，以方便管理和查找。

`sim` 目录下存放的是对应模块实现的 Testbench 文件和其他仿真相关的文件。

## 文件目录结构

```text
sim/
├── test_utils.vh                   # 测试工具宏定义文件
├── core/                           # 处理器核心测试
│   └── tb_SC_cpu_core_HelloWorld.v # 单周期CPU核心完整测试
├── modules/                        # 各功能模块测试
│   ├── instruction_decoder/        # 指令解码器测试
│   ├── tb_arithmetic_logic_unit/   # ALU测试目录
│   ├── tb_branch.v                 # 分支单元测试
│   ├── tb_instruction_decoder/     # 指令解码器测试目录
│   ├── tb_memory_access_unit.v     # 存储访问单元测试
│   ├── tb_program_counter.v        # 程序计数器测试
│   ├── tb_registers.v              # 寄存器组测试
│   └── tb_write_back_unit.v        # 写回单元测试
├── stages/                         # 流水线各阶段测试
│   ├── tb_execute.v                # 执行阶段测试
│   ├── tb_instruction_decode.v     # 指令解码阶段测试
│   ├── tb_instruction_fetch.v      # 取指阶段测试
│   ├── tb_instruction_fetch.coe    # 取指测试ROM初始化文件
│   ├── tb_instruction_fetch.hex    # 取指测试HEX文件
│   ├── tb_memory_access.v          # 访存阶段测试
│   └── tb_write_back.v             # 写回阶段测试
├── peripherals/                    # 外设测试
│   └── tb_gpio.v                   # GPIO外设测试
└── top/                            # 顶层集成测试
    ├── tb_SC_cpu_top.v             # 单周期CPU顶层测试
    ├── tb_SC_cpu_top_gpio.v        # 带GPIO的CPU顶层测试
    └── tb_SC_cpu_top_ip.v          # 带IP核的CPU顶层测试
```

## 测试工具和约定

最后没有用上类似的 TestCase 风格的测试文件，因为老师认为更应该关注异步信号响应以及对应的波形图来证明正确性，所以后面的测试风格和前面的不太相同。

### 测试工具头文件

- **文件**：`test_utils.vh`
- **功能**：提供统一的测试输出格式宏定义
- **主要宏**：
  - `PRINT_TEST_HEX`：十六进制格式输出测试结果
  - `PRINT_TEST_BIN`：二进制格式输出测试结果
  - `PRINT_TEST_DEC`：十进制格式输出测试结果
- **使用方法**：

  ```verilog
  `include "../test_utils.vh"
  `PRINT_TEST_HEX("ALU Result", alu_result, expected_result);
  ```

### 测试任务约定

每个测试文件建议包含标准化的 `check_result` 任务：

```verilog
task check_result;
    parameter BUFFER_LEN = 128;
    input [BUFFER_LEN*8-1:0] description;
    begin
        #1;
        $display("Test: %0s (@time: %0t)", description, $time);
        `PRINT_TEST_HEX("Signal_Name", actual_value, expected_value);
        // 更多测试项...
    end
endtask
```

## 各层级测试说明

### 模块级测试 (modules/)

测试单个功能模块的正确性，包括：

- **寄存器组测试**：验证读写操作、x0 寄存器特性
- **ALU 测试**：验证各种算术逻辑运算
- **分支单元测试**：验证条件分支逻辑
- **程序计数器测试**：验证 PC 更新逻辑
- **存储访问单元测试**：验证内存读写操作
- **写回单元测试**：验证数据写回选择逻辑

### 阶段级测试 (stages/)

测试流水线各阶段的集成功能：

- **取指阶段**：测试指令获取和 PC 更新
- **译码阶段**：测试指令解码和控制信号生成
- **执行阶段**：测试 ALU 运算和分支判断
- **访存阶段**：测试内存访问操作
- **写回阶段**：测试数据写回寄存器

### 核心级测试 (core/)

测试完整的 CPU 核心功能：

- **HelloWorld 测试**：运行简单程序验证 CPU 基本功能

### 顶层测试 (top/)

测试完整系统集成：

- **基础顶层测试**：CPU + 基本存储器
- **GPIO 测试**：CPU + GPIO 外设
- **IP 核测试**：CPU + Xilinx IP 核集成

### 外设测试 (peripherals/)

测试各种外设模块：

- **GPIO 测试**：验证通用输入输出功能
