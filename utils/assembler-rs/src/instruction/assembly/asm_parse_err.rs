use thiserror::Error;

#[derive(Debug, Error)]
pub enum AssemblyParseError {
    #[error("Line {src_line2}: Label \"{label_name}\" is defined more than once at line {src_line1}")]
    LabelMultipleDefined {
        label_name: String,
        src_line1: usize,
        src_line2: usize,
    },
    #[error("Line {0}: Unknown Instruction Format at line {0}",
            src_line.map_or("None".to_string(), |f| f.to_string()))]
    UnrecognizedFormat { src_line: Option<usize> },
    #[error("Failed to operate with file: {0}")]
    IOError(#[from] std::io::Error),
    #[error("Line {}: Invalid Label Name \"{label_name}\"",
            src_line.map_or("None".to_string(), |f| f.to_string()))]
    InvalidLabelName {
        label_name: String,
        src_line: Option<usize>,
    },
    #[error("Line {}: Invalid Mnemonic \"{mnemonic}\"",
            src_line.map_or("None".to_string(), |f| f.to_string()))]
    InvalidMnemonicName {
        mnemonic: String,
        src_line: Option<usize>,
    },
    #[error("Line {}: Invalid Operand Name \"{operand_name}\"", 
            src_line.map_or("None".to_string(), |f| f.to_string()))]
    InvalidOperandName {
        operand_name: String,
        src_line: Option<usize>,
    },
    #[error("Line {}: Mnemonic \"{mnemonic}\" does not match the operands \"{operands:?}\"",
            src_line.map_or("None".to_string(), |f| f.to_string()))]
    OpernadsNotMatch {
        mnemonic: String,
        operands: Vec<String>,
        src_line: Option<usize>,
    },
}

impl AssemblyParseError {
    pub fn with_line_num(self, line_num: usize) -> Self {
        match self {
            AssemblyParseError::LabelMultipleDefined {
                label_name,
                src_line1,
                ..
            } => AssemblyParseError::LabelMultipleDefined {
                label_name,
                src_line1,
                src_line2: line_num,
            },
            AssemblyParseError::UnrecognizedFormat { .. } => {
                AssemblyParseError::UnrecognizedFormat {
                    src_line: Some(line_num),
                }
            }
            AssemblyParseError::InvalidLabelName { label_name, .. } => {
                AssemblyParseError::InvalidLabelName {
                    label_name,
                    src_line: Some(line_num),
                }
            }
            AssemblyParseError::InvalidMnemonicName { mnemonic, .. } => {
                AssemblyParseError::InvalidMnemonicName {
                    mnemonic,
                    src_line: Some(line_num),
                }
            }
            AssemblyParseError::InvalidOperandName { operand_name, .. } => {
                AssemblyParseError::InvalidOperandName {
                    operand_name,
                    src_line: Some(line_num),
                }
            }
            AssemblyParseError::OpernadsNotMatch {
                mnemonic, operands, ..
            } => AssemblyParseError::OpernadsNotMatch {
                mnemonic,
                operands,
                src_line: Some(line_num),
            },
            _ => self,
        }
    }

    pub fn new_invalid_mnemonic(mnemonic: &str, src_line: usize) -> Self {
        AssemblyParseError::InvalidMnemonicName {
            mnemonic: mnemonic.to_string(),
            src_line: Some(src_line),
        }
    }
}
