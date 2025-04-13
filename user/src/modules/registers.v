`include "../../inc/registers_writeback.v"

module registers(
        input wire [4:0] rs1,           // 源寄存器1
        input wire [4:0] rs2,           // 源寄存器2
        input wire [4:0] rd,            // 目标寄存器
        input wire clk,                 // 时钟信号
        input wire rst_n,               // 复位信号，低有效
        input wire we,                  // 写使能信号
        input wire [31:0] write_data,   // 写入数据
        output reg [31:0] rs1_data,     // 源寄存器1数据输出
        output reg [31:0] rs2_data      // 源寄存器2数据输出
    );

    reg [31:0] reg_file [0:31]; // 32个寄存器，每个寄存器32位

    integer i; // 用于循环的变量

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            // 使用for循环复位所有寄存器
            for (i = 0; i < 32; i = i + 1)
                reg_file[i] <= 32'h0;
        else
            if (we && rd != 5'd0)
                reg_file[rd] <= write_data; // 写入数据
    end

    always @(*) begin
        rs1_data = reg_file[rs1];
        rs2_data = reg_file[rs2];
    end

endmodule
