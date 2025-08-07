use colored::*;

#[allow(dead_code)]
pub enum LogLevel {
    Info,
    Warn,
    Error,
}

pub(crate) fn print_log(log_level: LogLevel, message: &str) {
    match log_level {
        LogLevel::Info => println!("{} {}", "[INFO] ".blue().bold(), message.blue()),
        LogLevel::Warn => println!("{} {}", "[WARN] ".yellow().bold(), message.yellow()),
        LogLevel::Error => println!("{} {}", "[ERROR]".red().bold(), message.red()),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_print_log() {
        print_log(LogLevel::Info, "This is an info message.");
        print_log(LogLevel::Warn, "This is a warning message.");
        print_log(LogLevel::Error, "This is an error message.");
    }
}