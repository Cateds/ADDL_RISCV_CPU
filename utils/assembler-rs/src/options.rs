use crate::output_format::OutputFormat;
use clap::Parser;
use std::path::PathBuf;

#[derive(Parser, Debug)]
#[command(name = "Assembler by Rust : Translate RV32I assembly into .hex file")]
#[command(version = env!("CARGO_PKG_VERSION"), author = "Cateds")]
#[command(arg_required_else_help = true)]
pub struct Config {
    #[arg(num_args = 1, help = "Input assembly file")]
    pub input_file: PathBuf,
    #[arg(long = "output", short = 'o', help = "Output file name")]
    pub output_file: Option<PathBuf>,
    #[arg(value_enum, long = "format", short = 'f', help = "Output format")]
    pub output_format: Option<OutputFormat>,
}

#[allow(dead_code)]
impl Config {
    pub fn new() -> Self {
        Config::parse()
    }

    pub fn from_str(input: &str) -> Self {
        Config::parse_from(input.split_whitespace())
    }
}

#[cfg(test)]
mod tests {
    use super::Config;
    use clap::Parser;
    use std::path::PathBuf;

    #[test]
    fn default_command_line() {
        let args = Config::from_str("asm-rs test.asm -o test2.hex");
        println!("{:?}", args);
        assert_eq!(args.input_file, PathBuf::from("test.asm"));
        assert_eq!(args.output_file, Some(PathBuf::from("test2.hex")));
        let output_path = args
            .output_file
            .unwrap_or(args.input_file.with_extension("hex"));
        println!("Output path: {:?}", output_path);
    }

    #[test]
    fn default_without_output() {
        let args = Config::from_str("arm-rs test3.asm");
        println!("{:?}", args);
        assert_eq!(args.input_file, PathBuf::from("test3.asm"));
        assert_eq!(args.output_file, None);
        let output_path = args
            .output_file
            .unwrap_or(args.input_file.with_extension("hex"));
        println!("Output path: {:?}", output_path);
    }

    #[test]
    fn with_full_arguments() {
        let args =
            Config::from_str("asm-rs test4.asm -o test5.hex --format mem");
        println!("{:?}", args);
        assert_eq!(args.input_file, PathBuf::from("test4.asm"));
        assert_eq!(args.output_file, Some(PathBuf::from("test5.hex")));
        assert_eq!(args.output_format, Some(super::OutputFormat::Mem));
        let output_path = args
            .output_file
            .unwrap_or(args.input_file.with_extension("hex"));
        println!("Output path: {:?}", output_path);
    }

    #[test]
    fn test_help() {
        // let args = Options::from_str();
        let args = Config::try_parse_from("asm-rs --help".split_whitespace());
        println!("{:?}", args);
        assert!(args.is_err());
    }
}
