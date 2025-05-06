module RAM_unit #(
        parameter ADDR_WIDTH = 16
    )(
        input clk,
        input ce,
        input [3:0] we,
        input [ADDR_WIDTH-1:0] addr,
        input [31:0] din,
        output reg [31:0] dout
    );

    localparam MEM_SIZE = 1 << ADDR_WIDTH;

    (* ram_style = "block" *) reg [31:0] mem [0:MEM_SIZE-1];

    always @(posedge clk) begin
        if (ce) begin
            if (we[0])
                mem[addr][7:0] <= din[7:0];
            if (we[1])
                mem[addr][15:8] <= din[15:8];
            if (we[2])
                mem[addr][23:16] <= din[23:16];
            if (we[3])
                mem[addr][31:24] <= din[31:24];
        end
    end

    always @(*) begin
        dout = 32'bz;
        if (ce)
            dout = mem[addr];
    end
endmodule
