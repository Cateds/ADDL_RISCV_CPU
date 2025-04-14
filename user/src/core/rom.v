module rom_256x32 (
    input wire [7:0] addr,
    output wire [31:0] data
);
    // 合法的参数声明方式
    parameter [255:0] BIT0_INIT = 256'h0000000000000000000000000000000000000000000000000000000000000013;
    parameter [255:0] BIT1_INIT = 256'h0000000000000000000000000000000000000000000000000000000000000001;
    
    // ... 其他位的初始化值
    
    // 使用generate语句自动生成所有32个ROM实例
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : rom_bits
            // 根据位索引选择不同的初始化值
            ROM256X1 #(
                .INIT(i == 0 ? BIT0_INIT : 
                      i == 1 ? BIT1_INIT : 
                      256'h0000000000000000000000000000000000000000000000000000000000000000)
            ) rom_bit (
                .O(data[i]),
                .A0(addr[0]), .A1(addr[1]), .A2(addr[2]), .A3(addr[3]),
                .A4(addr[4]), .A5(addr[5]), .A6(addr[6]), .A7(addr[7])
            );
        end
    endgenerate

endmodule