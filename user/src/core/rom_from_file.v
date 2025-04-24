// module rom_from_file (
//     input wire [7:0] addr,
//     output reg [31:0] data
// );
//     // 修正: 使用标准Verilog兼容的存储器声明
//     reg [31:0] rom_array [0:255];  // 这是Verilog支持的存储器声明方式

//     // 初始化时从文件中读取数据
//     initial begin
//         $readmemh("./rom_init.hex", rom_array);
//     end

//     // 读取操作
//     always @(*) begin
//         data = rom_array[addr];
//     end
// endmodule

module rom256_from_file #(
        parameter FILE_PATH = "./rom_init.hex",
        parameter FILE_FORMAT = "hex" // 支持 "hex" 或 "bin"
    )(
        input wire [31:0] addr,
        output reg [31:0] data
    );

    localparam FORMAT_HEX = "hex";
    localparam FORMAT_BIN = "bin";

    wire [7:0] instr_addr; // 只取低8位作为地址
    assign instr_addr = addr[7:0]; // 只取低8位作为地址

    reg [31:0] rom_array [0:255];  // 这是Verilog支持的存储器声明方式
    initial begin
        case (FILE_FORMAT)
            FORMAT_HEX:
                $readmemh(FILE_PATH, rom_array);
            FORMAT_BIN:
                $readmemb(FILE_PATH, rom_array);
            default:
                $error("Unsupported file format: %s", FILE_FORMAT);
        endcase
    end

    always @(*) begin
        data = rom_array[instr_addr];
    end
endmodule
