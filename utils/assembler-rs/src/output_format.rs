use std::io::Write;
use std::{fs::File, io::BufWriter, path::Path};

use clap::ValueEnum;

use crate::instruction::asm_parse_err::AssemblyParseError;

#[derive(Clone, Copy, ValueEnum, Debug, PartialEq)]
pub enum OutputFormat {
    Mem,
    Coe,
}

impl OutputFormat {
    pub fn write_output_header(
        &self,
        buf_writer: &mut BufWriter<File>,
        source_file_name: &Path,
    ) -> Result<(), AssemblyParseError> {
        match self {
            Self::Mem => {
                writeln!(
                    buf_writer,
                    "// From File: {}",
                    source_file_name
                        .file_name()
                        .unwrap_or_default()
                        .to_string_lossy()
                )?;
            }
            Self::Coe => {
                writeln!(
                    buf_writer,
                    "memory_initialization_radix = 16;\nmemory_initialization_vector =",
                )?;
            }
        }
        Ok(())
    }

    pub fn write_output_end(
        &self,
        buf_writer: &mut BufWriter<File>,
        source_file_name: &Path,
    ) -> Result<(), AssemblyParseError> {
        match self {
            Self::Mem => {
                writeln!(
                    buf_writer,
                    "// End of File: {}",
                    source_file_name
                        .file_name()
                        .unwrap_or_default()
                        .to_string_lossy()
                )?;
            }
            Self::Coe => {}
        }
        Ok(())
    }
}
