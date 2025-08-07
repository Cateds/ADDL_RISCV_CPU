use std::str::FromStr;

use strum_macros::{Display, EnumString, VariantNames};

use super::asm_parse_err::AssemblyParseError;

#[derive(
    Debug, EnumString, Display, VariantNames, PartialEq, Eq, Clone, Copy,
)]
#[strum(serialize_all = "lowercase")]
pub enum RegDefine {
    #[strum(serialize = "x0", serialize = "zero")]
    Zero = 0, // x0: 零寄存器，值恒为0
    #[strum(serialize = "x1", serialize = "ra")]
    Ra = 1, // x1 (Return Addr): 返回地址寄存器
    #[strum(serialize = "x2", serialize = "sp")]
    Sp = 2, // x2 (Stack Pointer): 栈指针寄存器、
    #[strum(serialize = "x3", serialize = "gp")]
    Gp = 3, // x3 (Global Pointer): 全局指针寄存器
    #[strum(serialize = "x4", serialize = "tp")]
    Tp = 4, // x4 (Thread Pointer): 线程指针寄存器
    #[strum(serialize = "x5", serialize = "t0")]
    T0 = 5, // x5 (Temporary): 临时寄存器
    #[strum(serialize = "x6", serialize = "t1")]
    T1 = 6, // x6 (Temporary): 临时寄存器
    #[strum(serialize = "x7", serialize = "t2")]
    T2 = 7, // x7 (Temporary): 临时寄存器
    #[strum(serialize = "s0", serialize = "fp", serialize = "x8")]
    S0 = 8, // x8 (Saved): 保存寄存器
    #[strum(serialize = "s1", serialize = "x9")]
    S1 = 9, // x9 (Saved): 保存寄存器
    #[strum(serialize = "x10", serialize = "a0")]
    A0 = 10, // x10 (Argument): 参数寄存器，A0通常为函数返回值寄存器
    #[strum(serialize = "x11", serialize = "a1")]
    A1 = 11, // x11 (Argument): 参数寄存器，函数传参使用A0-A7寄存器
    #[strum(serialize = "x12", serialize = "a2")]
    A2 = 12, // x12 (Argument): 参数寄存器
    #[strum(serialize = "x13", serialize = "a3")]
    A3 = 13, // x13 (Argument): 参数寄存器
    #[strum(serialize = "x14", serialize = "a4")]
    A4 = 14, // x14 (Argument): 参数寄存器
    #[strum(serialize = "x15", serialize = "a5")]
    A5 = 15, // x15 (Argument): 参数寄存器
    #[strum(serialize = "x16", serialize = "a6")]
    A6 = 16, // x16 (Argument): 参数寄存器
    #[strum(serialize = "x17", serialize = "a7")]
    A7 = 17, // x17 (Argument): 参数寄存器
    #[strum(serialize = "x18", serialize = "s2")]
    S2 = 18, // x18 (Saved): 保存寄存器
    #[strum(serialize = "x19", serialize = "s3")]
    S3 = 19, // x19 (Saved): 保存寄存器
    #[strum(serialize = "x20", serialize = "s4")]
    S4 = 20, // x20 (Saved): 保存寄存器
    #[strum(serialize = "x21", serialize = "s5")]
    S5 = 21, // x21 (Saved): 保存寄存器
    #[strum(serialize = "x22", serialize = "s6")]
    S6 = 22, // x22 (Saved): 保存寄存器
    #[strum(serialize = "x23", serialize = "s7")]
    S7 = 23, // x23 (Saved): 保存寄存器
    #[strum(serialize = "x24", serialize = "s8")]
    S8 = 24, // x24 (Saved): 保存寄存器
    #[strum(serialize = "x25", serialize = "s9")]
    S9 = 25, // x25 (Saved): 保存寄存器
    #[strum(serialize = "x26", serialize = "s10")]
    S10 = 26, // x26 (Saved): 保存寄存器
    #[strum(serialize = "x27", serialize = "s11")]
    S11 = 27, // x27 (Saved): 保存寄存器
    #[strum(serialize = "x28", serialize = "t3")]
    T3 = 28, // x28 (Temporary): 临时寄存器
    #[strum(serialize = "x29", serialize = "t4")]
    T4 = 29, // x29 (Temporary): 临时寄存器
    #[strum(serialize = "x30", serialize = "t5")]
    T5 = 30, // x30 (Temporary): 临时寄存器
    #[strum(serialize = "x31", serialize = "t6")]
    T6 = 31, // x31 (Temporary): 临时寄存器
}

impl RegDefine {
    pub fn from_asm(reg: &str) -> Result<Self, AssemblyParseError> {
        RegDefine::from_str(reg).map_err(|_| {
            AssemblyParseError::InvalidOperandName {
                operand_name: reg.to_string(),
                src_line: None,
            }
        })
    }

    pub fn from_asm_offset(
        reg: &str,
    ) -> Result<(Self, i32), AssemblyParseError> {
        let reg = reg.trim();
        let left_paren = match reg.find('(') {
            Some(pos) => pos,
            None => {
                return Err(AssemblyParseError::InvalidOperandName {
                    operand_name: reg.to_string(),
                    src_line: None,
                })
            }
        };
        let right_paren = match reg.find(')') {
            Some(pos) => pos,
            None => {
                return Err(AssemblyParseError::InvalidOperandName {
                    operand_name: reg.to_string(),
                    src_line: None,
                })
            }
        };
        if left_paren >= right_paren || right_paren != reg.len() - 1 {
            return Err(AssemblyParseError::InvalidOperandName {
                operand_name: reg.to_string(),
                src_line: None,
            });
        }

        let offset_str = reg[0..left_paren].trim();
        let reg_str = reg[left_paren + 1..right_paren].trim();

        let offset = if offset_str.is_empty() {
            0
        } else {
            parse_integer(&offset_str)?
        };
        let reg = Self::from_asm(reg_str)?;
        Ok((reg, offset))
    }
}

impl Into<u32> for RegDefine {
    fn into(self) -> u32 {
        self as u32
    }
}

pub fn parse_integer(s: &str) -> Result<i32, AssemblyParseError> {
    let s = s.trim();
    if s.is_empty() {
        return Err(AssemblyParseError::InvalidOperandName {
            operand_name: s.to_string(),
            src_line: None,
        });
    }
    let (sign, s) = if s.starts_with('-') {
        (-1, &s[1..])
    } else if s.starts_with('+') {
        (1, &s[1..])
    } else {
        (1, s)
    };
    let value = if s.starts_with("0x") || s.starts_with("0X") {
        i32::from_str_radix(&s[2..], 16)
    } else if s.starts_with("0b") || s.starts_with("0B") {
        i32::from_str_radix(&s[2..], 2)
    } else if s.starts_with("0o") || s.starts_with("0O") {
        i32::from_str_radix(&s[2..], 8)
    } else if s.starts_with("0") && s.len() > 1 {
        i32::from_str_radix(&s[1..], 8)
    } else {
        s.parse::<i32>()
    };
    match value {
        Ok(value) => Ok(value * sign),
        Err(_) => Err(AssemblyParseError::InvalidOperandName {
            operand_name: s.to_string(),
            src_line: None,
        }),
    }
}

#[cfg(test)]
mod tests {
    use std::str::FromStr;

    use crate::instruction::registers::parse_integer;

    use super::RegDefine;

    #[test]
    fn test_register_definition() {
        assert_eq!(RegDefine::from_str("zero").unwrap(), RegDefine::Zero);
        assert_eq!(RegDefine::from_str("ra").unwrap(), RegDefine::Ra);
        assert_eq!(RegDefine::from_str("sp").unwrap(), RegDefine::Sp);
        assert_eq!(RegDefine::from_str("gp").unwrap(), RegDefine::Gp);
        assert_eq!(RegDefine::from_str("tp").unwrap(), RegDefine::Tp);
        assert_eq!(RegDefine::from_str("fp").unwrap(), RegDefine::S0);
        assert_eq!(RegDefine::from_str("s0").unwrap(), RegDefine::S0);
    }

    #[test]
    fn test_register_offset() {
        let (reg, offset) = RegDefine::from_asm_offset("  4(sp)  ").unwrap();
        assert_eq!(reg, RegDefine::Sp);
        assert_eq!(offset, 4);
        let (reg, offset) = RegDefine::from_asm_offset("  -8(sp)  ").unwrap();
        assert_eq!(reg, RegDefine::Sp);
        assert_eq!(offset, -8);
        let (reg, offset) = RegDefine::from_asm_offset("  (sp)  ").unwrap();
        assert_eq!(reg, RegDefine::Sp);
        assert_eq!(offset, 0);
        let result = RegDefine::from_asm_offset(" (sp) test");
        assert!(result.is_err());
        let result = RegDefine::from_asm_offset("invalid(sp)");
        assert!(result.is_err());
    }
    #[test]
    fn test_parse_integer() {
        let str = "-0x1234";
        let result = parse_integer(str);
        println!("{:?}", result);
        assert!(result.is_ok());
        assert_eq!(result.unwrap(), -0x1234);
    }

    #[test]
    fn test_offset_bug() {
        // 测试 "4(t0)" 的解析是否正确
        let result = RegDefine::from_asm_offset("4(t0)");
        println!("Parsing '4(t0)': {:?}", result);
        assert!(result.is_ok());
        let (reg, offset) = result.unwrap();
        assert_eq!(reg, RegDefine::T0);
        println!("Expected offset: 4, Got offset: {}", offset);
        assert_eq!(offset, 4); // 应该是4，不是0x80

        // 测试一些可能导致问题的情况
        let test_cases = vec![
            "4(t0)", " 4(t0) ",
            "04(t0)", // 这可能是问题所在 - 以0开头
            "0004(t0)",
        ];

        for case in test_cases {
            let result = RegDefine::from_asm_offset(case);
            println!("Parsing '{}': {:?}", case, result);
            if let Ok((reg, offset)) = result {
                println!("  -> reg: {:?}, offset: {}", reg, offset);
            }
        }
    }

    #[test]
    fn test_sh_instruction_encoding() {
        // 创建一个简单的 sh 指令: sh t1, 4(t0)
        use crate::instruction::{opcode::RV32IOpcode, RV32IInstr};

        let instr = RV32IInstr::SType {
            opcode: RV32IOpcode::S_Store,
            func3: 0b001,       // sh 的 func3
            rs1: RegDefine::T0, // 基址寄存器 t0 = x5
            rs2: RegDefine::T1, // 源寄存器 t1 = x6
            imm: 4,             // 偏移量 4
        };

        let hex = instr.to_hex_str();
        println!("sh t1, 4(t0) encoded as: {}", hex);

        // 按照正确的 RISC-V S 类型格式，应该是：
        // imm[11:5] = 0 (bits 31-25)
        // rs2 = 6 (bits 24-20)
        // rs1 = 5 (bits 19-15)
        // func3 = 1 (bits 14-12)
        // imm[4:0] = 4 (bits 11-7)
        // opcode = 0x23 (bits 6-0)
        //
        // 二进制: 0000000_00110_00101_001_00100_0100011
        // 十六进制: 0x00629223

        let binary = instr.to_u32();
        println!("Binary: 0x{:08X}", binary);
        println!("Expected: 0x00629223");

        // 如果当前的错误编码导致了 0x80 的错误，我们来看看具体的值
        if binary != 0x00629223 {
            println!("编码错误！检查 S 类型指令的立即数位移");
        }
    }

    #[test]
    fn test_original_bug_report() {
        // 测试原始 bug 报告：sh t1, 4(t0) 应该正确编码偏移量 4
        // 而不是错误地编码成 0x80

        // 首先测试解析
        let result = RegDefine::from_asm_offset("4(t0)");
        assert!(result.is_ok());
        let (reg, offset) = result.unwrap();
        assert_eq!(reg, RegDefine::T0);
        assert_eq!(offset, 4);
        // 然后测试完整的指令编码
        use crate::instruction::RV32IInstr;
        use std::collections::HashMap;

        let label_map = HashMap::new();
        let operands = vec!["t1".to_string(), "4(t0)".to_string()];
        let instr = RV32IInstr::from_asm("sh", &operands, 0, &label_map);

        assert!(instr.is_ok());
        let instr = instr.unwrap();

        // 检查指令结构
        if let RV32IInstr::SType { rs1, rs2, imm, .. } = instr {
            assert_eq!(rs1, RegDefine::T0); // 基址寄存器
            assert_eq!(rs2, RegDefine::T1); // 源寄存器
            assert_eq!(imm, 4); // 偏移量应该是 4，不是 0x80
        } else {
            panic!("Expected SType instruction");
        }

        // 检查机器码编码
        let hex = instr.to_hex_str();
        println!("sh t1, 4(t0) -> {}", hex);

        // 确保不是错误的 0x80 编码
        let binary = instr.to_u32();
        assert_eq!(binary, 0x00629223, "机器码编码错误");

        // 验证立即数字段
        let imm_4_0 = (binary >> 7) & 0x1F; // bits[11:7]
        let imm_11_5 = (binary >> 25) & 0x7F; // bits[31:25]
        let reconstructed_imm = imm_4_0 | (imm_11_5 << 5);

        assert_eq!(reconstructed_imm, 4, "立即数字段编码错误");
    }
}
