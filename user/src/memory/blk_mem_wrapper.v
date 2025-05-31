module blk_mem_wrapper(
    input wire clka,
    input wire ena,
    input wire [3:0] wea,
    input wire [15:0] addra,
    input wire [31:0] dina,
    output wire [31:0] douta
);    // BRAM IP核的输出
    wire [31:0] bram_douta;
    
    // 实例化真正的BRAM IP核
    blk_mem_RAM u_blk_mem_RAM(
        .clka(clka),
        .ena(ena),
        .wea(wea),
        .addra(addra),
        .dina(dina),
        .douta(bram_douta)
    );
    
    // 控制输出逻辑，未使能时为高阻态
    assign douta = ena ? bram_douta : 32'hzzzzzzzz;

endmodule