module registers(
        input wire [4:0] rs1,           // Source Register Address 1
        input wire [4:0] rs2,           // Source Register Address 2
        input wire [4:0] rd,            // Destination Register Address
        input wire clk,                 // Input clock signal
        input wire rst_n,               // Active low reset signal
        input wire we,                  // Write enable signal
        input wire [31:0] write_data,   // Data to be written to the register
        output reg [31:0] rs1_data,     // Source Register 1 Data Output
        output reg [31:0] rs2_data      // Source Register 2 Data Output
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
