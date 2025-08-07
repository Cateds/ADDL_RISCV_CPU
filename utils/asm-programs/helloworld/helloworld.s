_main:
    addi a0, zero, 0
    addi a1, zero, 0x48 // a1 : ASCII code of 'H'
    call print_char
    addi a1, zero, 0x65 // a1 : ASCII code of 'e'
    call print_char
    addi a1, zero, 0x6C // a1 : ASCII code of 'l'
    call print_char
    addi a1, zero, 0x6C // a1 : ASCII code of 'l'
    call print_char
    addi a1, zero, 0x6F // a1 : ASCII code of 'o'
    call print_char
    addi a1, zero, 0x20 // a1 : ASCII code of ' '
    call print_char
    addi a1, zero, 0x57 // a1 : ASCII code of 'W'
    call print_char
    addi a1, zero, 0x6F // a1 : ASCII code of 'o'
    call print_char
    addi a1, zero, 0x72 // a1 : ASCII code of 'r'
    call print_char
    addi a1, zero, 0x6C // a1 : ASCII code of 'l'
    call print_char
    addi a1, zero, 0x64 // a1 : ASCII code of 'd'
    call print_char
    addi a1, zero, 0x21 // a1 : ASCII code of '!'
    call print_char
    call _exit

print_char:
    sb a1, 0(a0) // Store the character in memory
    ret // Return to the caller

_exit:
    nop