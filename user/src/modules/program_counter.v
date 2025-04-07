`include "../../inc/pc_mux.v"

module program_counter(
        input wire [1:0] branch,
        input wire en,
        input wire clk,
        input wire rst_n,
        // input wire reset_n,
        input wire [31:0] alu_result,
        input wire [31:0] pc_adder_result,
        output reg [31:0] pc,
        output reg [31:0] pc_next
    );

    wire [31:0] next_pc_val;

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

    // 不带分支延迟槽的PC，使用阻塞赋值
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc = 32'h0;
            pc_next = 32'h4;
        end
        else if (en) begin
            pc = next_pc_val;
            pc_next = next_pc_val + 4; // 计算下一个PC值
        end
        // 如果en为0，保持PC不变
    end

endmodule //program_counter
