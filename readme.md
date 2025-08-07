# RISC-V CPU 项目

> Final Project for Application and Design of Digital Logics (ADDL) Challenge Course @ 2024-2025 Spring, Glasgow College, UESTC.

本项目实现了一个基本的 RISC-V 架构 CPU，包含完整的指令解码、执行和内存访问功能。

项目开发环境使用 Visual Studio Code + DigitalIDE 插件，支持 Icarus Verilog 仿真。

## 项目结构

```text
ADDL_RISCV_CPU/
├── readme.md               # 项目说明文件（本文件）
├── .vscode/                # VS Code 配置目录
│   └── property.json       # DigitalIDE 属性配置文件
├── prj/                    # 项目构建目录 (项目自动生成)
│   └── ...                 # 自动生成的文件
├── utils/                  # 项目相关工具
│   └── ...                 # 其他工具文件
└── user/                   # 用户代码
    ├── data/               # 数据文件
    ├── ip/                 # IP 核文件
    ├── sim/                # 仿真文件
    │   ├── sim.md          # 测试说明文档
    │   └── ...             # 其他测试文件
    └── src/                # 源代码
        ├── src.md          # 源代码说明文档
        └── ...             # 源代码文件
```

## 文件夹说明

### prj/ 目录

项目构建相关文件:

- **icarus/**: Icarus Verilog 仿真器构建文件
- **netlist/**: 网表生成相关文件，包含综合脚本和日志

### user/ 目录

用户代码和相关资源:

- [`user/data/`](user/data/data.md): 存放数据文件
- [`user/ip/`](user/ip/ip.md): 存放 IP 核文件
- [`user/sim/`](user/sim/sim.md): 存放仿真相关文件
- [`user/src/`](user/src/src.md): 存放源代码文件

更具体的文件说明见各个目录下对应的 markdown 文件

### utils/ 目录

存放项目相关的工具文件，具体而言是一个适配了项目要求的 `RV32I` 指令集的汇编器，支持将简单的 RISC-V 汇编代码转换为机器码，格式可选为 `hex` 或 `coe`。其中, `utils/assember-rs` 是汇编器的具体代码实现，`utils/asm-programs` 目录下包含一些用 RV32I 汇编语言编写的示例程序。

更具体的文件说明见 [`README.md`](utils/assembler-rs/readme.md)。
