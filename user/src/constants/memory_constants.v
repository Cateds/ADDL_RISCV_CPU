module MEM_OP_ENUM();
    parameter NOP   = 2'b00;  // No Operation
    parameter LOAD  = 2'b01;  // Load Operation
    parameter STORE = 2'b10;  // Store Operation
endmodule

module MEM_SEL_ENUM();
    parameter BYTE_SIGNED  = 3'b000;  // Byte signed
    parameter BYTE_UNSIGNED= 3'b100;  // Byte unsigned
    parameter HALF_SIGNED  = 3'b001;  // Halfword signed
    parameter HALF_UNSIGNED= 3'b101;  // Halfword unsigned
    parameter WORD        = 3'b010;  // Word
    parameter NOP         = 3'b111;  // No Operation (reserved)
endmodule