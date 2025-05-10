module MEM_OP_ENUM();
    localparam NOP   = 2'b00;  // No Operation
    localparam LOAD  = 2'b01;  // Load Operation
    localparam STORE = 2'b10;  // Store Operation
endmodule

module MEM_SEL_ENUM();
    localparam BYTE_SIGNED   = 3'b000;  // Byte signed
    localparam BYTE_UNSIGNED = 3'b100;  // Byte unsigned
    localparam HALF_SIGNED   = 3'b001;  // Halfword signed
    localparam HALF_UNSIGNED = 3'b101;  // Halfword unsigned
    localparam WORD          = 3'b010;  // Word
    localparam NOP           = 3'b111;  // No Operation (reserved)
endmodule
