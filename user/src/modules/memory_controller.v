module memory_ctrl(
        // Internal signals
        input wire [1:0] mem_op,
        input wire [2:0] mem_sel,
        input wire [31:0] mem_addr,
        input wire [31:0] mem_wdata,
        output wire [31:0] mem_rdata,

        // External signals
        output reg ram_ce,  // RAM chip enable
        output wire bus_we,
        output wire bus_re,
        output wire [3:0] bus_data_byte_sel,
        output wire [31:0] bus_addr,
        inout wire [31:0] bus_data,

        // Clock and reset
        input wire clk,
        input wire rst_n
    );


endmodule
