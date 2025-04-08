# TestBench List / 测试台列表

## Submodules / 子模块

- **Instruction Fetch (IF) / 取指**

  - [Program Counter (PC)](tb_program_counter.v)

- **Instruction Decode (ID) / 译码**

  - [Registers File](tb_registers.v)
  - [Instruction Decoder](tb_instruction_decoder/tb_instr.v)
    - B Type Decoder
      - [B Type Decoder](tb_instruction_decoder/tb_instr_B.v)
    - I Type Decoder
      - [I Type Decoder : Calculation](tb_instruction_decoder/tb_instr_I_Calc.v)
      - [I Type Decoder : Load](tb_instruction_decoder/tb_instr_I_Load.v)
      - [I Type Decoder : CSR](tb_instruction_decoder/tb_instr_I_CSR.v)
      - [I Type Decoder : Jump](tb_instruction_decoder/tb_instr_I_Jump.v)
      - [I Type Decoder : Fence](tb_instruction_decoder/tb_instr_I_Fence.v)
    - J Type Decoder
      - [J Type Decoder](tb_instruction_decoder/tb_instr_J.v)
    - R Type Decoder
      - [R Type Decoder](tb_instruction_decoder/tb_instr_R.v)
    - S Type Decoder
      - [S Type Decoder](tb_instruction_decoder/tb_instr_S.v)
    - U Type Decoder
      - [U Type Decoder : Upper Immediate](tb_instruction_decoder/tb_instr_U_Upper.v)
      - [U Type Decoder : Jump and Link](tb_instruction_decoder/tb_instr_U_Jump_Link.v)
  - [Program Counter Adder](tb_pc_adder.v)

- **Execute (EX) / 执行**

  - [Arithmetic Logic Unit (ALU)](tb_arithmetic_logic_unit/tb_alu.v)
    - [ALU Compute Unit](tb_arithmetic_logic_unit/tb_alu_compute_unit.v)
    - [ALU Input Multiplexer](tb_arithmetic_logic_unit/tb_alu_input_multiplexer.v)
  - [Branch Unit](tb_branch_unit.v)
  - [Control and Status Register (CSR)](tb_control_and_status_reg/tb_csr.v)
    - [CSR Register File](tb_control_and_status_reg/tb_csr_register_file.v)
    - [CSR Calculate Unit](tb_control_and_status_reg/tb_csr_calculate_unit.v)

- **Memory Access (MEM) / 访存**

  - [Memory Controller](tb_memory_controller.v)

- **Write Back (WB) / 写回**
  - [Write Back Unit](tb_write_back_unit.v)

> [TODO]
>
> - Pipeline Unit
> - Memory Unit
> - Interrupt Unit

## Integration / 集成

## Instruction Test / 指令测试

- R Type Instruction
- I Type Instruction
  - I Type ALU Instruction
  - I Type Load Instruction
  - I Type CSR Instruction
  - I Type Jump Instruction
  - I Type Fence Instruction
- S Type Instruction
- B Type Instruction
- U Type Instruction
  - U Type Upper Immediate Instruction
  - U Type Jump and Link Instruction
- J Type Instruction
