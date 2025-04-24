module pc_mips_2(
        input clk,
        input rst_n,
        input branch,
        input [31:0] branch_addr,
        output [31:0] pc,
        output [31:0] pc_plus_4
    );

    reg [31:0] pc_reg;
    assign pc = pc_reg;
    assign pc_plus_4 = pc_reg + 4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            pc_reg <= 32'b0;
        else if (branch) 
            pc_reg <= branch_addr;
        else 
            pc_reg <= pc_plus_4;
    end
endmodule
