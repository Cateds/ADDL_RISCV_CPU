#[allow(non_camel_case_types)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum RV32IOpcode {
    R_Calc = 0b0110011,
    I_Calc = 0b0010011,
    I_Load = 0b0000011,
    I_Jump = 0b1100111,
    I_Env = 0b1110011,
    I_Fence = 0b0001111,
    S_Store = 0b0100011,
    B_Branch = 0b1100011,
    U_LUI = 0b0110111,
    U_AUIPC = 0b0010111,
    J_JAL = 0b1101111,
}
