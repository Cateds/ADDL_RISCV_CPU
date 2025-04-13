`ifndef CSR_OPCODE_V
`define CSR_OPCODE_V

`define CSR_OP_RW   2'b01   // Read and Write
`define CSR_OP_RS   2'b10   // Read and Set bits
`define CSR_OP_RC   2'b11   // Read and Clear bits
`define CSR_OP_NOP  2'b00   // No operation

`endif // CSR_OPCODE_V