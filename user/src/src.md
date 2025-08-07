# user/src 目录

`src` 目录存放的是项目的源代码文件。这些文件实现了 RISC-V CPU 的各个功能模块，包括指令解码、执行和内存访问等。

## 目录结构

- `bus/`：存放总线相关的代码文件，定义了 CPU 与内存和外设之间的通信协议。
  - `bus/bus_controller.v`：总线控制器模块，负责管理数据传输和地址解码。
  - `bus/memory_mapping.md`：内存映射说明文档，描述了 CPU 如何访问不同的内存区域和外设。
- `constants/`：存放常量定义文件，包含各种操作码和指令格式的定义。
  - `constants/alu_constants.v`：ALU 的操作码和输入的 Mux 选择信号定义。
  - `constants/csr_constants.v`：CSR（控制和状态寄存器）的操作码定义。
  - `constants/memory_constants.v`：访存单元的读/写操作及其他常量定义。
  - `constants/pc_constants.v`：Program Counter 的跳转相关常量定义。
  - `constants/wb_constants.v`：写回单元的多路选择相关常量定义
- `core/` 存放 RISC-V 的 CPU 核的顶层代码。
- `memory/`：存放内存相关的代码文件，定义了数据存储和访问方式。
  - `memory/ram.v`：用于 iVerilog 仿真的寄存器式存储器模块，模拟 RAM 的读写操作。
  - `memory/rom.v`：用于 iVerilog 仿真的只读存储器模块，模拟 ROM 的读取操作。
  - `memory/blk_mem_wrapper.v`：一个对 Xilinx Block RAM 的封装，以让 IP 核适配总线空闲时高阻的特性。
- `modules/`：存放各个功能模块的实现代码。
  - 详细的模块说明见 [`modules/modules.md`](modules/modules.md)。
- `peripherals/`：存放外设相关的代码文件，定义了 CPU 如何与外设进行交互。
  - `peripherals/gpio.v`：GPIO 外设模块，实现通用输入输出功能。
  - `peripherals/gpio.md`：GPIO 外设模块的寄存器映射和功能说明文档。
- `stages/`：存放 CPU 流水线层各个阶段的实现（理论上是这样，没来得及做流水线）
  - `SC_*.v` 代表的是单周期（Single Cycle）实现的各个阶段
  - `PL_*.v` 代表的是流水线（Pipelined）实现的各个阶段
- `top/`：存放 CPU 的顶层集成代码，包含 RISC-V 核，RAM，ROM，总线控制器和 GPIO 外设
