module ROM_unit #(
        parameter INIT_FILE_PATH = "hex/rom_init.hex",
        parameter ADDR_WIDTH = 16
    )(
        input [ADDR_WIDTH-1:0] addr,
        output [31:0] data
    );

    localparam MEM_SIZE = 1 << ADDR_WIDTH;

    (* ram_style = "block" *) reg [31:0] memory [0:MEM_SIZE-1];

    initial begin
        $readmemh(INIT_FILE_PATH, memory);
    end

    assign data = memory[addr];

endmodule
