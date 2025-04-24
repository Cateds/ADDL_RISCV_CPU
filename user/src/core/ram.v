module ram #(
    parameter ADDR_WIDTH = 32,              // 地址宽度
    parameter DATA_WIDTH = 32,              // 数据宽度（通常为32位，与RISC-V寄存器宽度匹配）
    parameter RAM_DEPTH = (1 << ADDR_WIDTH) // RAM深度（2的ADDR_WIDTH次方）
)(
    input wire clk,                         // 时钟信号
    input wire rst_n,                       // 复位信号，低电平有效
    
    input wire [ADDR_WIDTH-1:0] addr,       // 地址线
    input wire [DATA_WIDTH-1:0] wdata,      // 写数据线
    input wire we,                          // 写使能
    input wire re,                          // 读使能
    
    output reg [DATA_WIDTH-1:0] rdata       // 读数据线
);

    // 定义RAM存储单元
    reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];
    
    // 初始化RAM（在实际项目中可以从文件加载初始内容）
    integer i;
    initial begin
        for (i = 0; i < RAM_DEPTH; i = i + 1) begin
            mem[i] = {DATA_WIDTH{1'b0}}; // 初始化为0
        end
        
        // 可以在此处添加从文件加载指令和数据的代码
        // $readmemh("program.hex", mem);
    end
    
    // 写操作
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // 复位操作，可根据需要选择是否清空RAM
        end else if (we) begin
            mem[addr] <= wdata;
        end
    end
    
    // 读操作
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rdata <= {DATA_WIDTH{1'b0}}; // 复位时输出为0
        end else if (re) begin
            rdata <= mem[addr];
        end
    end

endmodule
