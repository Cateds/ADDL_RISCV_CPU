use std::{
    collections::HashMap,
    fs::File,
    io::{BufRead, BufReader},
    path::Path,
};

use crate::instruction::{RV32IInstr, RV32IProgram};

use super::asm_parse_err::AssemblyParseError;

struct AssemblyCommand {
    pub source_line: usize,
    pub target_addr: usize,
    pub mnemonic: String,
    pub operands: Vec<String>,
}

pub struct AssemblyLabel {
    pub source_line: usize,
    pub target_addr: usize,
}

pub struct AssemblyProgram {
    asm_instrs: Vec<AssemblyCommand>,
    label_map: HashMap<String, AssemblyLabel>,
}

#[allow(dead_code)]
impl AssemblyProgram {
    pub fn new() -> Self {
        AssemblyProgram {
            asm_instrs: Vec::new(),
            label_map: HashMap::new(),
        }
    }

    pub fn from_file(file_name: &Path) -> Result<Self, AssemblyParseError> {
        let mut program = Self::new();
        program.load_file(file_name)?;
        Ok(program)
    }

    pub fn append_label(
        &mut self,
        label: &str,
        source_line: usize,
    ) -> Result<(), AssemblyParseError> {
        if self.label_map.contains_key(label) {
            return Err(AssemblyParseError::LabelMultipleDefined {
                label_name: label.to_string(),
                src_line1: self.label_map[label].source_line,
                src_line2: source_line,
            });
        }
        self.label_map.insert(
            label.to_string(),
            AssemblyLabel {
                source_line,
                target_addr: if self.asm_instrs.is_empty() {
                    0
                } else {
                    self.asm_instrs.last().unwrap().target_addr + 4
                },
            },
        );
        return Ok(());
    }

    pub fn append_command(
        &mut self,
        mnemonic: &str,
        operands: &[String],
        source_line: usize,
    ) {
        self.asm_instrs.push(AssemblyCommand {
            source_line,
            target_addr: if self.asm_instrs.is_empty() {
                0
            } else {
                self.asm_instrs.last().unwrap().target_addr + 4
            },
            mnemonic: mnemonic.to_string(),
            operands: operands.to_vec(),
        });
    }

    pub fn load_file(
        &mut self,
        file_name: &Path,
    ) -> Result<&mut Self, AssemblyParseError> {
        let file = File::open(file_name)?;
        let reader = BufReader::new(file);
        for (line_num, line_str) in reader.lines().enumerate() {
            let line_num = line_num + 1;
            let line_str = line_str?;
            let (label_name, mnemonic, operands) =
                parse_assembly_line(&line_str)
                    .map_err(|e| e.with_line_num(line_num))?;
            if let Some(label_name) = &label_name {
                self.append_label(label_name, line_num)?;
            }
            if let Some(mnemonic) = &mnemonic {
                self.append_command(mnemonic, &operands, line_num);
            }
        }
        return Ok(self);
    }

    pub fn try_into_rv32i_prog(
        self,
    ) -> Result<RV32IProgram, AssemblyParseError> {
        let mut rv32i_prog = RV32IProgram::new();
        for asm in self.asm_instrs.iter() {
            let instr = RV32IInstr::from_asm(
                &asm.mnemonic,
                &asm.operands,
                asm.target_addr,
                &self.label_map,
            )
            .map_err(|e| e.with_line_num(asm.source_line))?;
            rv32i_prog.insert_instr(instr, asm.target_addr);
        }
        Ok(rv32i_prog)
    }
}

fn parse_assembly_line(
    line: &str,
) -> Result<(Option<String>, Option<String>, Vec<String>), AssemblyParseError> {
    // ----- 通过识别 "//" 和 "#" 来分离注释 ------
    let line = if let Some(idx) = line.find("//") {
        &line[0..idx]
    } else if let Some(idx) = line.find('#') {
        &line[0..idx]
    } else {
        line
    };

    if line.trim().is_empty() {
        // 没有有效内容则为空行
        return Ok((None, None, Vec::new()));
    }

    // ----- 通过冒号分离标签和指令 -----
    let (label, instr) = line
        .split_once(":")
        .map(|(l, i)| (l.trim(), i.trim()))
        .unwrap_or(("", line));
    if label.chars().any(|c| !c.is_alphanumeric() && c != '_') {
        // 如果标签中有非法字符，则返回错误
        return Err(AssemblyParseError::InvalidLabelName {
            label_name: label.to_string(),
            src_line: None,
        });
    }
    let label = if label.is_empty() {
        None
    } else {
        Some(label.to_string())
    };

    // ----- 通过空字符分离助记符和操作数 -----
    let instr = instr.trim();
    if instr.is_empty() {
        // 如果指令为空，则返回标签和空操作数
        return Ok((label, None, Vec::new()));
    }
    let (mnemonic, operands) = match instr.find(char::is_whitespace) {
        Some(idx) => (Some(instr[0..idx].to_string()), instr[idx..].trim()),
        None => (Some(instr.to_string()), ""),
    };

    // ----- 通过逗号分离操作数 -----
    let operands = operands
        .split(",")
        .map(|s| s.trim().to_string())
        .filter(|s| !s.is_empty())
        .collect::<Vec<_>>();
    if operands
        .iter()
        .any(|str| str.find(char::is_whitespace).is_some())
    {
        return Err(AssemblyParseError::UnrecognizedFormat { src_line: None });
    };
    return Ok((label, mnemonic, operands));
}

#[cfg(test)]
mod tests {
    use super::parse_assembly_line;

    #[test]
    fn test_parse_assembly_line() {
        let line = "label: add x1, x2,x3 // Here's the Comment";
        let (label, mnemonic, operands) = parse_assembly_line(line).unwrap();
        assert_eq!(label, Some("label".to_string()));
        assert_eq!(mnemonic, Some("add".to_string()));
        assert_eq!(
            operands,
            vec!["x1".to_string(), "x2".to_string(), "x3".to_string()]
        );

        let line = " PureLabelLine:  // Here's the line with pure label";
        let (label, mnemonic, operands) = parse_assembly_line(line).unwrap();
        assert_eq!(label, Some("PureLabelLine".to_string()));
        assert_eq!(mnemonic, None);
        assert_eq!(operands, Vec::<String>::new());

        let line =
            "    xor r1, r2, r3  // Here's the line with pure instruction";
        let (label, mnemonic, operands) = parse_assembly_line(line).unwrap();
        assert_eq!(label, None);
        assert_eq!(mnemonic, Some("xor".to_string()));
        assert_eq!(
            operands,
            vec!["r1".to_string(), "r2".to_string(), "r3".to_string()]
        );

        let line = "  // Pure Comment Line   ";
        let (label, mnemonic, operands) = parse_assembly_line(line).unwrap();
        assert_eq!(label, None);
        assert_eq!(mnemonic, None);
        assert_eq!(operands, Vec::<String>::new());

        let line = "    ret    ";
        let (label, mnemonic, operands) = parse_assembly_line(line).unwrap();
        assert_eq!(label, None);
        assert_eq!(mnemonic, Some("ret".to_string()));
        assert_eq!(operands, Vec::<String>::new());
    }

    #[test]
    fn test_parse_assembly_error() {
        let line = "invalid label:";
        let result = parse_assembly_line(line);
        println!("Error: {:?}", result);
        assert!(result.is_err());

        let line = " xor r1 r2, r3";
        let result = parse_assembly_line(line);
        println!("Error: {:?}", result);
        assert!(result.is_err());

        let line = "xor\tr1,\tr2\tr3";
        let result = parse_assembly_line(line);
        println!("Error: {:?}", result);
        assert!(result.is_err());
    }
}
