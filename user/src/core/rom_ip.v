module rom_IP();

    blk_mem_ROM u_rom (
        .clka(clk), // input clka
        .addra(addr), // input [7 : 0] addra
        .douta(douta) // output [31 : 0] douta
    );
endmodule