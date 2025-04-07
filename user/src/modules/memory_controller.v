module memory_ctrl(
        // Internal signals
        input wire [1:0] mem_op,
        input wire [2:0] mem_sel,
        input wire [31:0] address,
        input wire [31:0] write_data,
        output wire [31:0] read_data,
        output wire mem_ready,

        // External signals
        output wire ram_ce_n,
        output wire ram_we_n,
        output wire ram_oe_n,
        output wire [3:0] ram_byte_en_n,
        output wire [31:0] ram_addr,
        inout wire [31:0] ram_data,

        // Clock and reset
        input wire clk,
        input wire rst_n
    );

    // TODO: Implement the memory controller logic here
    
endmodule
