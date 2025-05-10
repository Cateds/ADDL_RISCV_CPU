module CSR_OP_ENUM();
    localparam RW  = 2'b01;  // Read and Write
    localparam RS  = 2'b10;  // Read and Set bits
    localparam RC  = 2'b11;  // Read and Clear bits
    localparam NOP = 2'b00;  // No operation
endmodule