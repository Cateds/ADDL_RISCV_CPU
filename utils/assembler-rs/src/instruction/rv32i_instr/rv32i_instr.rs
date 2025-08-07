use std::{collections::HashMap, fs::File, io::BufWriter, path::Path};

use crate::{
    instruction::{
        asm_parse_err::AssemblyParseError,
        assembly::assembly::AssemblyLabel,
        mnemonic::Mnemonics,
        registers::{parse_integer, RegDefine},
    },
    output_format::OutputFormat,
};

use std::io::Write;

use super::opcode::RV32IOpcode;

pub struct RV32IProgram {
    pub instructions: Vec<RV32IProgramLine>,
}

pub struct RV32IProgramLine {
    pub addr: usize,
    pub instr: RV32IInstr,
}

#[allow(dead_code)]
impl RV32IProgram {
    pub fn new() -> Self {
        RV32IProgram {
            instructions: Vec::new(),
        }
    }

    pub fn append_instr(&mut self, instr: RV32IInstr) {
        self.instructions.push(RV32IProgramLine {
            addr: self.instructions.last().map_or(0, |f| f.addr + 4),
            instr,
        });
    }
    pub fn insert_instr(&mut self, instr: RV32IInstr, addr: usize) {
        self.instructions.push(RV32IProgramLine { addr, instr });
    }

    pub fn append_to_file(
        &self,
        buf_writer: &mut BufWriter<File>,
        output_format: &OutputFormat,
    ) -> Result<(), AssemblyParseError> {
        let mut cur_addr = 0;
        const NOP_INSTR: RV32IInstr = RV32IInstr::IType {
            opcode: RV32IOpcode::I_Calc,
            func3: 0b000,
            rd: RegDefine::Zero,
            rs1: RegDefine::Zero,
            imm: 0,
        };
        for (i, prog_line) in self.instructions.iter().enumerate() {
            while cur_addr < prog_line.addr {
                match output_format {
                    OutputFormat::Mem => {
                        writeln!(buf_writer, "{}", NOP_INSTR.to_hex_str())?
                    }
                    OutputFormat::Coe => {
                        writeln!(buf_writer, "{},", NOP_INSTR.to_hex_str())?
                    }
                }
                cur_addr += 4;
            }
            match output_format {
                OutputFormat::Mem => {
                    writeln!(buf_writer, "{}", prog_line.instr.to_hex_str())?
                }
                OutputFormat::Coe => {
                    if i == self.instructions.len() - 1 {
                        writeln!(
                            buf_writer,
                            "{};",
                            prog_line.instr.to_hex_str()
                        )?;
                    } else {
                        writeln!(
                            buf_writer,
                            "{},",
                            prog_line.instr.to_hex_str()
                        )?;
                    }
                }
            }
            cur_addr += 4;
        }
        Ok(())
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RV32IInstr {
    RType {
        opcode: RV32IOpcode,
        func3: u8,
        rd: RegDefine,
        rs1: RegDefine,
        rs2: RegDefine,
        func7: u8,
    },
    IType {
        opcode: RV32IOpcode,
        func3: u8,
        rd: RegDefine,
        rs1: RegDefine,
        imm: i32,
    },
    SType {
        opcode: RV32IOpcode,
        func3: u8,
        rs1: RegDefine,
        rs2: RegDefine,
        imm: i32,
    },
    BType {
        opcode: RV32IOpcode,
        func3: u8,
        rs1: RegDefine,
        rs2: RegDefine,
        imm: i32,
    },
    UType {
        opcode: RV32IOpcode,
        rd: RegDefine,
        imm: i32,
    },
    JType {
        opcode: RV32IOpcode,
        rd: RegDefine,
        imm: i32,
    },
}

impl RV32IInstr {
    pub fn to_u32(&self) -> u32 {
        use RV32IInstr::*;
        match self {
            RType {
                opcode,
                func3,
                rd,
                rs1,
                rs2,
                func7,
            } => {
                (*opcode as u32)
                    | (*rd as u32) << 7
                    | (*func3 as u32) << 12
                    | (*rs1 as u32) << 15
                    | (*rs2 as u32) << 20
                    | (*func7 as u32) << 25
            }
            IType {
                opcode,
                func3,
                rd,
                rs1,
                imm,
            } => {
                (*opcode as u32)
                    | (*rd as u32) << 7
                    | (*func3 as u32) << 12
                    | (*rs1 as u32) << 15
                    | (*imm as u32) << 20
            }
            SType {
                opcode,
                func3,
                rs1,
                rs2,
                imm,
            } => {
                (*opcode as u32)
                    | ((*imm as u32 & 0x1F) << 7)    // imm[4:0] -> bits[11:7]
                    | (*func3 as u32) << 12
                    | (*rs1 as u32) << 15
                    | (*rs2 as u32) << 20
                    | ((*imm as u32 & 0xFE0) << 20) // imm[11:5] -> bits[31:25]
            }
            BType {
                opcode,
                func3,
                rs1,
                rs2,
                imm,
            } => {
                (*opcode as u32)
                    | (*imm as u32 & 0x800) >> 4
                    | (*imm as u32 & 0x1E) << 7
                    | (*func3 as u32) << 12
                    | (*rs1 as u32) << 15
                    | (*rs2 as u32) << 20
                    | (*imm as u32 & 0x7E0) << 20
                    | (*imm as u32 & 0x1000) << 19
            }
            UType { opcode, rd, imm } => {
                (*opcode as u32) | (*rd as u32) << 7 | (*imm as u32) << 12
            }
            JType { opcode, rd, imm } => {
                (*opcode as u32)
                    | (*rd as u32) << 7
                    | (*imm as u32 & 0xFF000)
                    | (*imm as u32 & 0x800) << 9
                    | (*imm as u32 & 0x7FE) << 20
                    | (*imm as u32 & 0x100000) << 11
            }
        }
    }

    pub fn to_hex_str(&self) -> String {
        format!("{:08X}", self.to_u32())
    }

    pub fn from_asm(
        mnemonic: &str,
        operands: &Vec<String>,
        cur_addr: usize,
        label_map: &HashMap<String, AssemblyLabel>,
    ) -> Result<Self, AssemblyParseError> {
        use crate::instruction::assembly::mnemonic::Mnemonics::*;
        let mnemonic_enum = Mnemonics::from_str_asm(mnemonic)?;
        match mnemonic_enum {
            // * ========== Extension Instructions ========== *
            Nop => {
                check_operand_count(mnemonic, operands, 0)?;
                return Ok(RV32IInstr::IType {
                    opcode: RV32IOpcode::I_Calc,
                    func3: 0b000,
                    rd: RegDefine::Zero,
                    rs1: RegDefine::Zero,
                    imm: 0,
                });
            }
            Ret => {
                check_operand_count(mnemonic, operands, 0)?;
                return Ok(RV32IInstr::IType {
                    opcode: RV32IOpcode::I_Jump,
                    func3: 0b000,
                    rd: RegDefine::Zero,
                    rs1: RegDefine::Ra,
                    imm: 0,
                });
            }
            Jr => {
                check_operand_count(mnemonic, operands, 1)?;
                let rs1 = RegDefine::from_asm(&operands[0])?;
                return Ok(RV32IInstr::IType {
                    opcode: RV32IOpcode::I_Jump,
                    func3: 0b000,
                    rd: RegDefine::Zero,
                    rs1,
                    imm: 0,
                });
            }
            Call => {
                check_operand_count(mnemonic, operands, 1)?;
                let label_addr = get_label_idx(label_map, &operands[0])?;
                let offset = (label_addr as i32) - (cur_addr as i32);
                return Ok(RV32IInstr::JType {
                    opcode: RV32IOpcode::J_JAL,
                    rd: RegDefine::Ra,
                    imm: offset,
                });
            }
            // TODO: Implement other instructions
            // * ========== Basic Instructions ========== *
            // * ---------- U type ---------- *
            Lui => {
                check_operand_count(mnemonic, operands, 2)?;
                let rd = RegDefine::from_asm(&operands[0])?;
                let imm = parse_integer(&operands[1])?;
                return Ok(RV32IInstr::UType {
                    opcode: RV32IOpcode::U_LUI,
                    rd,
                    imm,
                });
            }
            Auipc => {
                check_operand_count(mnemonic, operands, 2)?;
                let rd = RegDefine::from_asm(&operands[0])?;
                let imm = parse_integer(&operands[1])?;
                return Ok(RV32IInstr::UType {
                    opcode: RV32IOpcode::U_AUIPC,
                    rd,
                    imm,
                });
            }
            // * ---------- J type ---------- *
            // ----- J Jump -----
            Jal => {
                check_operand_range(mnemonic, operands, 1..2)?;
                let (rd, offset) = if operands.len() == 1 {
                    (RegDefine::Ra, &operands[0])
                } else {
                    (RegDefine::from_asm(&operands[0])?, &operands[1])
                };
                let offset = match parse_integer(offset) {
                    Ok(offset) => offset,
                    Err(_) => {
                        let label_addr = get_label_idx(label_map, offset)?;
                        (label_addr as i32) - (cur_addr as i32)
                    }
                };
                return Ok(RV32IInstr::JType {
                    opcode: RV32IOpcode::J_JAL,
                    rd,
                    imm: offset,
                });
            }
            // * ---------- B Type ---------- *
            // ----- B Branch -----
            Beq | Bne | Blt | Bge | Bltu | Bgeu => {
                check_operand_count(mnemonic, operands, 3)?;
                let rs1 = RegDefine::from_asm(&operands[0])?;
                let rs2 = RegDefine::from_asm(&operands[1])?;
                let imm = match parse_integer(&operands[2]) {
                    Ok(imm) => imm,
                    Err(_) => {
                        let label_addr =
                            get_label_idx(label_map, &operands[2])?;
                        (label_addr as i32) - (cur_addr as i32)
                    }
                };
                let func3 = match mnemonic_enum {
                    Beq => 0b000,
                    Bne => 0b001,
                    Blt => 0b100,
                    Bge => 0b101,
                    Bltu => 0b110,
                    Bgeu => 0b111,
                    _ => {
                        return Err(AssemblyParseError::new_invalid_mnemonic(
                            mnemonic, 0,
                        ))
                    }
                };
                return Ok(RV32IInstr::BType {
                    opcode: RV32IOpcode::B_Branch,
                    func3,
                    rs1,
                    rs2,
                    imm,
                });
            }
            // * ---------- S type ---------- *
            // ----- S Store -----
            Sb | Sh | Sw => {
                check_operand_count(mnemonic, operands, 2)?;
                let rs2 = RegDefine::from_asm(&operands[0])?;
                let (rs1, imm) = RegDefine::from_asm_offset(&operands[1])?;
                let func3 = match mnemonic_enum {
                    Sb => 0b000,
                    Sh => 0b001,
                    Sw => 0b010,
                    _ => {
                        return Err(AssemblyParseError::new_invalid_mnemonic(
                            mnemonic, 0,
                        ))
                    }
                };
                return Ok(RV32IInstr::SType {
                    opcode: RV32IOpcode::S_Store,
                    func3,
                    rs1,
                    rs2,
                    imm,
                });
            }
            // * ---------- R type ---------- *
            // ----- R Calc -----
            Add | Sub | Sll | Slt | Sltu | Xor | Srl | Sra | Or | And => {
                check_operand_count(mnemonic, operands, 3)?;
                let rd = RegDefine::from_asm(&operands[0])?;
                let rs1 = RegDefine::from_asm(&operands[1])?;
                let rs2 = RegDefine::from_asm(&operands[2])?;
                let func3 = match mnemonic_enum {
                    Add | Sub => 0b000,
                    Sll => 0b001,
                    Slt => 0b010,
                    Sltu => 0b011,
                    Xor => 0b100,
                    Srl | Sra => 0b101,
                    Or => 0b110,
                    And => 0b111,
                    _ => {
                        return Err(AssemblyParseError::new_invalid_mnemonic(
                            mnemonic, 0,
                        ))
                    }
                };
                let func7 = match mnemonic_enum {
                    Add | Xor | Sll | Slt | Sltu | Or | And | Srl => 0b0000000,
                    Sub | Sra => 0b0100000,
                    _ => {
                        return Err(AssemblyParseError::new_invalid_mnemonic(
                            mnemonic, 0,
                        ))
                    }
                };
                return Ok(RV32IInstr::RType {
                    opcode: RV32IOpcode::R_Calc,
                    func3,
                    rd,
                    rs1,
                    rs2,
                    func7,
                });
            }
            // * ---------- I type ---------- *
            // ----- I Calc -----
            Addi | Slti | Sltiu | Xori | Ori | Andi | Slli | Srli | Srai => {
                check_operand_count(mnemonic, operands, 3)?;
                let rd = RegDefine::from_asm(&operands[0])?;
                let rs1 = RegDefine::from_asm(&operands[1])?;
                let imm = parse_integer(&operands[2])?;
                let imm = match mnemonic_enum {
                    Slli | Srli => imm & 0x1F,
                    Srai => (imm & 0x1F) | (0x400),
                    _ => imm,
                };
                let func3 = match mnemonic_enum {
                    Addi => 0b000,
                    Slti => 0b010,
                    Sltiu => 0b011,
                    Xori => 0b100,
                    Ori => 0b110,
                    Andi => 0b111,
                    Slli => 0b001,
                    Srli | Srai => 0b101,
                    _ => {
                        return Err(AssemblyParseError::new_invalid_mnemonic(
                            mnemonic, 0,
                        ))
                    }
                };
                return Ok(RV32IInstr::IType {
                    opcode: RV32IOpcode::I_Calc,
                    func3,
                    rd,
                    rs1,
                    imm,
                });
            }
            // ----- I Load -----
            Lb | Lh | Lw | Lbu | Lhu => {
                check_operand_count(mnemonic, operands, 2)?;
                let rd = RegDefine::from_asm(&operands[0])?;
                let (rs1, imm) = RegDefine::from_asm_offset(&operands[1])?;
                let func3 = match mnemonic_enum {
                    Lb => 0b000,
                    Lh => 0b001,
                    Lw => 0b010,
                    Lbu => 0b100,
                    Lhu => 0b101,
                    _ => {
                        return Err(AssemblyParseError::new_invalid_mnemonic(
                            mnemonic, 0,
                        ))
                    }
                };
                return Ok(RV32IInstr::IType {
                    opcode: RV32IOpcode::I_Load,
                    func3,
                    rd,
                    rs1,
                    imm,
                });
            }
            // ----- I Jump -----
            Jalr => {
                check_operand_range(mnemonic, operands, 1..2)?;
                let rd = if operands.len() == 1 {
                    RegDefine::Ra
                } else {
                    RegDefine::from_asm(&operands[0])?
                };
                let (rs1, imm) = match RegDefine::from_asm_offset(
                    operands.last().unwrap(),
                ) {
                    Ok((reg, imm)) => (reg, imm),
                    Err(_) => {
                        let reg =
                            RegDefine::from_asm(operands.last().unwrap())?;
                        (reg, 0)
                    }
                };
                let func3 = 0b000;
                Ok(RV32IInstr::IType {
                    opcode: RV32IOpcode::I_Jump,
                    func3,
                    rd,
                    rs1,
                    imm,
                })
            }
            // ----- I Fence -----
            Fence => {
                check_operand_count(mnemonic, operands, 2)?;
                let (pred, succ) = if operands.is_empty() {
                    (0b1111, 0b1111)
                } else if operands.len() == 2 {
                    let pred = parse_fence_flags(&operands[0])?;
                    let succ = parse_fence_flags(&operands[1])?;
                    (pred, succ)
                } else {
                    return Err(AssemblyParseError::OpernadsNotMatch {
                        mnemonic: mnemonic.to_string(),
                        operands: operands.clone(),
                        src_line: None,
                    });
                };
                let imm = ((pred as i32) << 4) | succ as i32;
                return Ok(RV32IInstr::IType {
                    opcode: RV32IOpcode::I_Fence,
                    func3: 0b000,
                    rd: RegDefine::Zero,
                    rs1: RegDefine::Zero,
                    imm,
                });
            }
            FenceI => {
                check_operand_count(mnemonic, operands, 0)?;
                return Ok(RV32IInstr::IType {
                    opcode: RV32IOpcode::I_Fence,
                    func3: 0b001,
                    rd: RegDefine::Zero,
                    rs1: RegDefine::Zero,
                    imm: 0,
                });
            }
            // ----- I Env -----
            Ecall | Ebreak => {
                let imm = match mnemonic_enum {
                    Ecall => 0b000000000000,
                    Ebreak => 0b000000000001,
                    _ => {
                        return Err(AssemblyParseError::new_invalid_mnemonic(
                            mnemonic, 0,
                        ));
                    }
                };
                return Ok(RV32IInstr::IType {
                    opcode: RV32IOpcode::I_Env,
                    func3: 0b000,
                    rd: RegDefine::Zero,
                    rs1: RegDefine::Zero,
                    imm,
                });
            }
            // ----- I CSR -----
            // TODO : Implement other instructions
            // * =============== Default =============== *
            _ => {
                return Err(AssemblyParseError::InvalidMnemonicName {
                    mnemonic: mnemonic.to_string(),
                    src_line: None,
                })
            }
        }
    }
}

fn check_operand_count(
    mnemonic: &str,
    operands: &Vec<String>,
    target_count: usize,
) -> Result<(), AssemblyParseError> {
    if operands.len() != target_count {
        return Err(AssemblyParseError::OpernadsNotMatch {
            mnemonic: mnemonic.to_string(),
            operands: operands.clone(),
            src_line: None,
        });
    }
    Ok(())
}

fn check_operand_range(
    mnemonic: &str,
    operands: &Vec<String>,
    target_range: std::ops::Range<usize>,
) -> Result<(), AssemblyParseError> {
    let (min, max) = (target_range.start, target_range.end);
    if operands.len() < min || operands.len() > max {
        return Err(AssemblyParseError::OpernadsNotMatch {
            mnemonic: mnemonic.to_string(),
            operands: operands.clone(),
            src_line: None,
        });
    } else {
        return Ok(());
    }
}

fn get_label_idx(
    label_map: &HashMap<String, AssemblyLabel>,
    label: &str,
) -> Result<usize, AssemblyParseError> {
    if let Some(label_info) = label_map.get(label) {
        return Ok(label_info.target_addr);
    } else {
        return Err(AssemblyParseError::InvalidLabelName {
            label_name: label.to_string(),
            src_line: None,
        });
    }
}

fn parse_fence_flags(flags: &str) -> Result<u8, AssemblyParseError> {
    let mut result = 0b0000;
    for flag in flags.chars() {
        match flag.to_ascii_lowercase() {
            'i' => result |= 0b1000,
            'r' => result |= 0b0100,
            'w' => result |= 0b0010,
            'o' => result |= 0b0001,
            _ => {
                return Err(AssemblyParseError::InvalidOperandName {
                    operand_name: format!("Invalid fence flag: {}", flag),
                    src_line: None,
                });
            }
        }
    }
    return Ok(result);
}

pub fn write_rv32i_prog_to_file(
    target_file: &Path,
    rv32i_prog: &RV32IProgram,
    source_file: &Path,
    output_fmt: &OutputFormat,
) -> Result<(), AssemblyParseError> {
    let out_file = File::create(target_file)?;
    let mut writer = std::io::BufWriter::new(out_file);
    output_fmt.write_output_header(&mut writer, source_file)?;
    rv32i_prog.append_to_file(&mut writer, output_fmt)?;
    output_fmt.write_output_end(&mut writer, source_file)?;
    Ok(())
}
