_main:
    lui a0, 0x10000
    addi a1, zero, 0x48 // a1 : ASCII code of 'H'
    sb a1, 0(a0) // Store the character in memory
    addi a0, a0, 1 // Move to the next memory location
    addi a1, zero, 0x65 // a1 : ASCII code of 'e'
    sb a1, 0(a0) // Store the character in memory
    addi a0, a0, 1 // Move to the next memory location
    addi a1, zero, 0x6C // a1 : ASCII code of 'l'
    sb a1, 0(a0) // Store the character in memory
    addi a0, a0, 1 // Move to the next memory location
    addi a1, zero, 0x6C // a1 : ASCII code of 'l'
    sb a1, 0(a0) // Store the character in memory
    addi a0, a0, 1 // Move to the next memory location
    addi a1, zero, 0x6F // a1 : ASCII code of 'o'
    sb a1, 0(a0) // Store the character in memory
    addi a0, a0, 1 // Move to the next memory location
    addi a1, zero, 0x20 // a1 : ASCII code of ' '
    sb a1, 0(a0) // Store the character in memory
    addi a0, a0, 1 // Move to the next memory location
    addi a1, zero, 0x57 // a1 : ASCII code of 'W'
    sb a1, 0(a0) // Store the character in memory
    addi a0, a0, 1 // Move to the next memory location
    addi a1, zero, 0x6F // a1 : ASCII code of 'o'
    sb a1, 0(a0) // Store the character in memory
    addi a0, a0, 1 // Move to the next memory location
    addi a1, zero, 0x72 // a1 : ASCII code of 'r'
    sb a1, 0(a0) // Store the character in memory
    addi a0, a0, 1 // Move to the next memory location
    addi a1, zero, 0x6C // a1 : ASCII code of 'l'
    sb a1, 0(a0) // Store the character in memory
    addi a0, a0, 1 // Move to the next memory location
    addi a1, zero, 0x64 // a1 : ASCII code of 'd'
    sb a1, 0(a0) // Store the character in memory
    addi a0, a0, 1 // Move to the next memory location
    addi a1, zero, 0x21 // a1 : ASCII code of '!'
    sb a1, 0(a0) // Store the character in memory
    addi a0, a0, 1 // Move to the next memory location