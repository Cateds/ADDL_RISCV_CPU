use std::str::FromStr;

use strum_macros::{Display, EnumString, VariantNames};

use super::asm_parse_err::AssemblyParseError;

#[derive(Debug, EnumString, Display, VariantNames, PartialEq, Eq)]
#[strum(serialize_all = "lowercase")]
pub enum Mnemonics {
    // * ========== Extension Instructions ========== *
    Ret,  // 返回指令，即 jalr ra, 0 ，返回到 ra 寄存器的地址
    Jr,   // 跳转到寄存器的地址，即 jalr x0, 0(target)
    Nop,  // 无操作指令，即 addi x0, x0, 0
    Call, // 调用指令，即 jal ra, 0(target)
    // * ========== Basic Instructions ========== *
    // * ---------- U type ---------- *
    Lui,   // 立即数加载高位
    Auipc, // 加载高位并加上PC
    // * ---------- J type ---------- *
    Jal, // 跳转到 PC + 立即数偏移量
    // * ---------- B Type ---------- *
    Beq,  // 相等跳转
    Bne,  // 不相等跳转
    Blt,  // 小于跳转
    Bge,  // 大于等于跳转
    Bltu, // 无符号小于跳转
    Bgeu, // 无符号大于等于跳转
    // * ---------- S type ---------- *
    Sb, // 字节存储
    Sh, // 半字存储
    Sw, // 字存储
    // * ---------- R type ---------- *
    Add,  // 加法
    Sub,  // 减法
    Sll,  // 左移
    Slt,  // 小于
    Sltu, // 无符号小于
    Xor,  // 异或
    Srl,  // 右移
    Sra,  // 算术右移
    Or,   // 或
    And,  // 与
    // * ---------- I type ---------- *
    // ----- I Calc -----
    Addi,  // 立即数加法
    Slti,  // 小于立即数
    Sltiu, // 无符号小于立即数
    Xori,  // 立即数异或
    Ori,   // 立即数或
    Andi,  // 立即数与
    Slli,  // 立即数左移
    Srli,  // 立即数右移
    Srai,  // 立即数算术右移
    // ----- I Load -----
    Lb,  // 字节加载
    Lh,  // 半字加载
    Lw,  // 字加载
    Lbu, // 无符号字节加载
    Lhu, // 无符号半字加载
    // ----- I Jump -----
    Jalr, // 跳转到寄存器加立即数
    // ----- I Fence -----
    Fence, // 屏障指令
    #[strum(serialize = "fence.i")]
    FenceI, // 屏障指令
    // ----- I Env -----
    Ecall,  // 环境调用
    Ebreak, // 环境中断
    CSRrw,  // CSR读写
    CSRrs,  // CSR读并设置位
    CSRrc,  // CSR读并清除位
    CSRrwi, // CSR立即数读写
    CSRrsi, // CSR立即数读并设置位
    CSRrci, // CSR立即数读并清除位
}

impl Mnemonics {
    pub fn from_str_asm(mnemonic: &str) -> Result<Self, AssemblyParseError> {
        match Mnemonics::from_str(mnemonic) {
            Ok(mnemonic) => Ok(mnemonic),
            Err(_) => Err(AssemblyParseError::InvalidMnemonicName {
                mnemonic: mnemonic.to_string(),
                src_line: None,
            }),
        }
    }
}

#[cfg(test)]
mod tests {
    use std::str::FromStr;

    use crate::instruction::mnemonic::Mnemonics;

    #[test]
    fn test_parse_mnemonics() {
        let mnemonics = Mnemonics::from_str("add").unwrap();
        assert_eq!(mnemonics, Mnemonics::Add);
        let mnemonics = Mnemonics::from_str("sub").unwrap();
        assert_eq!(mnemonics, Mnemonics::Sub);
        let mnemonics = Mnemonics::from_str("nop").unwrap();
        assert_eq!(mnemonics, Mnemonics::Nop);
        let mnemonic = Mnemonics::from_str("ret").unwrap();
        assert_eq!(mnemonic, Mnemonics::Ret);
    }
}
