module cpu(
        // * Clock Sync Signals Connection --------------------
        input wire clk,
        input wire rst_n,

        // * External Signals Connection --------------------
        // ----- Instruction Memory -----
        output wire [31:0] rom_addr,
        input wire [31:0] rom_data,
        // ----- Data Memory -----
        output wire ram_ce_n,
        output wire ram_we_n,
        output wire ram_oe_n,
        output wire [3:0] ram_byte_en_n,
        output wire [31:0] ram_addr,
        inout wire [31:0] ram_data
    );

    
endmodule
