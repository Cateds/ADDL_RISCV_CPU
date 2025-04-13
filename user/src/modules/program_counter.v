`include "../../inc/pc_mux.v"

module program_counter(
        input wire [1:0] branch,
        input wire en,
        input wire clk,
        input wire rst_n,
        input wire [31:0] alu_result,
        input wire [31:0] pc_adder_result,
        output reg [31:0] pc,
        output wire [31:0] pc_next
    );

    reg [31:0] next_pc_val;
    assign pc_next = pc + 4; // 计算下一个PC值

    always @(*) begin
        case (branch)
            `PC_MUX_ALU_OUT:
                next_pc_val = alu_result;
            `PC_MUX_PC_ADDER:
                next_pc_val = pc_adder_result;
            default:
                next_pc_val = pc + 4;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            pc <= 32'h0;
        else if (en) 
            pc <= next_pc_val; 
    end

endmodule //program_counter
