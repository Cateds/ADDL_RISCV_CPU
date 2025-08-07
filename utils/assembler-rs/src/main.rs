use std::process::exit;

use instruction::{
    assembly::assembly::AssemblyProgram, write_rv32i_prog_to_file,
};
use logs::{print_log, LogLevel};
use options::Config;
use output_format::OutputFormat;

mod instruction;
mod logs;
mod options;
mod output_format;

fn main() {
    let args = Config::new();
    let output_format = args.output_format.unwrap_or(OutputFormat::Mem);
    let output_file = args.output_file.unwrap_or(
        args.input_file.with_extension(match output_format {
            OutputFormat::Mem => "hex",
            OutputFormat::Coe => "coe",
        }),
    );
    let input_file = args.input_file;
    println!("Input Assembly File: {}", input_file.display());
    println!("Output Hex File: {}", output_file.display());
    if !input_file.exists() {
        print_log(
            LogLevel::Error,
            &format!("Input file does not exist: {}", input_file.display()),
        );
        std::process::exit(1);
    }
    if output_file.exists() {
        print_log(
            LogLevel::Warn,
            &format!("Output file already exists: {}", output_file.display()),
        );
        print_log(LogLevel::Warn, "The file will be overwritten.");
    }

    let asm_file = match AssemblyProgram::from_file(&input_file) {
        Ok(program) => program,
        Err(e) => {
            print_log(
                LogLevel::Error,
                &format!("In File {}: {}", input_file.display(), e),
            );
            exit(1);
        }
    };
    let rv32i_prog = match asm_file.try_into_rv32i_prog() {
        Ok(rv32i_prog) => rv32i_prog,
        Err(e) => {
            print_log(
                LogLevel::Error,
                &format!("In File {}: {}", input_file.display(), e),
            );
            exit(1);
        }
    };

    match write_rv32i_prog_to_file(
        &output_file,
        &rv32i_prog,
        &input_file,
        &output_format,
    ) {
        Ok(_) => println!(
            "Converted {} to {} successfully.",
            input_file.display(),
            output_file.display()
        ),
        Err(e) => {
            print_log(
                LogLevel::Error,
                &format!("In File {}: {}", input_file.display(), e),
            );
            std::process::exit(1);
        }
    }
}
