module rom_from_file (
    input wire [7:0] addr,
    output reg [31:0] data
);
    // 修正: 使用标准Verilog兼容的存储器声明
    reg [31:0] rom_array [0:255];  // 这是Verilog支持的存储器声明方式
    
    // 初始化时从文件中读取数据
    initial begin
        $readmemh("./rom_init.hex", rom_array);
    end
    
    // 读取操作
    always @(*) begin
        data = rom_array[addr];
    end
endmodule
