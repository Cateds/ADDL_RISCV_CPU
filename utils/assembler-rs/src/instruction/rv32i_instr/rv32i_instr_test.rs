#[cfg(test)]
mod tests {
    use std::collections::HashMap;

    use maplit::hashmap;

    use crate::instruction::{
        assembly::assembly::AssemblyLabel, opcode::RV32IOpcode,
        registers::RegDefine, RV32IInstr,
    };

    #[test]
    fn test_instr() {
        let label_map = HashMap::new();
        let oprands =
            vec!["t1".to_string(), "t2".to_string(), "t3".to_string()];
        let instr = RV32IInstr::from_asm("sub", &oprands, 0, &label_map);
        println!("Instr: {:?}", instr);
        assert!(instr.is_ok());
        assert_eq!(
            instr.as_ref().unwrap(),
            &RV32IInstr::RType {
                opcode: RV32IOpcode::R_Calc,
                func3: 0b000,
                rd: RegDefine::T1,
                rs1: RegDefine::T2,
                rs2: RegDefine::T3,
                func7: 0b0100000
            }
        );
        let hex_instr = instr.unwrap().to_hex_str();
        println!("Hex Instr: {:?}", hex_instr);

        let oprands = vec!["t1", "-10(t2)"]
            .iter()
            .map(|s| s.to_string())
            .collect::<Vec<_>>();
        let instr = RV32IInstr::from_asm("sw", &oprands, 4, &label_map);
        assert!(instr.is_ok());
        println!("Instr: {:?}", instr);
        assert_eq!(
            instr.as_ref().unwrap(),
            &RV32IInstr::SType {
                opcode: RV32IOpcode::S_Store,
                func3: 0b010,
                rs1: RegDefine::T2,
                rs2: RegDefine::T1,
                imm: -10
            }
        );
        println!("Hex Instr: {:?}", instr.unwrap().to_hex_str());
    }

    #[test]
    fn test_instr_to_hex() {
        let instr = RV32IInstr::from_asm(
            "call",
            &vec!["function".to_string()],
            12,
            &hashmap! {"function".to_string() => AssemblyLabel{ source_line:0, target_addr: 16}},
        )
        .unwrap();
        println!("Instr: {:?}", instr);
        assert_eq!(
            &instr,
            &RV32IInstr::JType {
                opcode: RV32IOpcode::J_JAL,
                rd: RegDefine::Ra,
                imm: 4
            }
        );
        println!("Hex Instr: {:?}", instr.to_hex_str());
    }
}
