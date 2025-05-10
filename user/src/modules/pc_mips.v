module pc_mips(
    input wire clk,
    input wire rst,
    input wire branch,
    input wire [31:0] branch_addr,
    output wire [31:0] pc,
    output wire [31:0] pc_plus_4
);
    reg [31:0] next_pc_reg;
    reg [31:0] pc_reg;

    assign pc = pc_reg;
    assign pc_plus_4 = pc_reg + 32'h4;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_reg <= 32'h0;
            next_pc_reg <= 32'h4;
        end else begin
            next_pc_reg <= branch ? branch_addr : pc_reg + 8;
            pc_reg <= next_pc_reg;
        end
    end
endmodule