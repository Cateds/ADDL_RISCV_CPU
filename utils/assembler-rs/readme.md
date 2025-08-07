# RV32I Assembler

一个用 Rust 编写的 RISC-V RV32I 指令集汇编器，可以将 RV32I 汇编代码转换为机器码，支持多种输出格式。

## 特性

- 🔧 支持完整的 RV32I 基础指令集
- 📝 支持标签和跳转指令
- 🎯 支持多种输出格式（HEX/COE）
- 🚀 快速、准确的汇编转换
- 🛡️ 完善的错误处理和诊断信息
- 📊 彩色日志输出

## 支持的指令

### 基础指令集

- **U 类型**: `lui`, `auipc`
- **J 类型**: `jal`
- **B 类型**: `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`
- **S 类型**: `sb`, `sh`, `sw`
- **R 类型**: `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and`
- **I 类型**:
  - 计算: `addi`, `slti`, `sltiu`, `xori`, `ori`, `andi`, `slli`, `srli`, `srai`
  - 加载: `lb`, `lh`, `lw`, `lbu`, `lhu`
  - 跳转: `jalr`
  - 屏障: `fence`, `fence.i`

### 扩展指令（伪指令）

- `ret` - 返回指令 (jalr ra, 0)
- `jr` - 跳转到寄存器 (jalr x0, 0(target))
- `nop` - 无操作 (addi x0, x0, 0)
- `call` - 调用指令 (jal ra, target)

## 使用方法

### 基本用法

```bash
# 将汇编文件转换为十六进制格式
asm-rs input.s

# 指定输出文件
asm-rs input.s -o output.hex

# 指定输出格式
asm-rs input.s -f coe  # Xilinx COE 格式
asm-rs input.s -f mem  # 内存十六进制格式
```

### 命令行选项

```text
Usage: asm-rs [OPTIONS] <INPUT_FILE>

Arguments:
  <INPUT_FILE>  输入汇编文件

Options:
  -o, --output <OUTPUT_FILE>    输出文件名
  -f, --format <OUTPUT_FORMAT>  输出格式 [可选值: mem, coe]
  -h, --help                    显示帮助信息
  -V, --version                 显示版本信息
```

## 汇编语法

### 注释

支持两种注释格式：

```assembly
// 这是单行注释
# 这也是单行注释
```

### 标签

```assembly
main:           # 定义标签
    addi x1, x0, 10
    jal main    # 跳转到标签
```

### 寄存器表示

支持数字表示和 ABI 名称：

```assembly
addi x1, x0, 5      # 数字表示
addi ra, zero, 5    # ABI 名称
```

### 立即数

支持十进制和十六进制：

```assembly
addi x1, x0, 100    # 十进制
addi x1, x0, 0x64   # 十六进制
```

## 示例程序

### Hello World 示例

```assembly
_main:
    addi a0, zero, 0
    addi a1, zero, 0x48     # 'H'
    call print_char
    addi a1, zero, 0x65     # 'e'
    call print_char
    # ... 更多字符
    call _exit

print_char:
    sb a1, 0(a0)
    ret

_exit:
    nop
```

## 输出格式

### MEM 格式 (.hex)

标准的十六进制内存格式：

```text
// From File: input.s
00000513
04800593
060000EF
// End of File: input.s
```

### COE 格式 (.coe)

Xilinx 内存初始化格式：

```text
memory_initialization_radix = 16;
memory_initialization_vector =
00000513,
04800593,
060000EF;
```

## 错误处理

汇编器提供详细的错误信息：

- 🔴 **语法错误**: 无效的指令格式或操作数
- 🟡 **标签错误**: 重复定义或未定义的标签
- 🟠 **寄存器错误**: 无效的寄存器名称
- 🔵 **立即数错误**: 立即数超出范围

## 开发

### 运行测试

```bash
cargo test
```

### 格式化代码

```bash
cargo fmt
```

### 检查代码

```bash
cargo clippy
```

## 项目结构

```text
src/
├── main.rs                 # 主入口
├── instruction/            # 指令处理模块
│   ├── assembly/          # 汇编解析
│   └── rv32i_instr/       # RV32I 指令定义
├── logs.rs                # 日志输出
├── options.rs             # 命令行参数
└── output_format.rs       # 输出格式处理
data/                      # 示例汇编文件
```
