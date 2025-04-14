module CSR_OP_ENUM();
    parameter RW  = 2'b01;  // Read and Write
    parameter RS  = 2'b10;  // Read and Set bits
    parameter RC  = 2'b11;  // Read and Clear bits
    parameter NOP = 2'b00;  // No operation
endmodule