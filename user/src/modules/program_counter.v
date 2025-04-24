module program_counter(
        input wire [1:0] branch,    // Whether to branch or not, and MUX of branch addr
        input wire en,  // Enable signal
        input wire clk, // Clock signal
        input wire rst_n,   // Reset signal, active low
        input wire [31:0] alu_result,   // The result of the ALU operation
        input wire [31:0] pc_adder_result,  // The result of the PC adder (PC + Imm)
        output reg [31:0] pc,   // Current PC value
        output wire [31:0] pc_next  // PC + 4
    );

    PC_MUX_ENUM pc_mux_enum();

    reg [31:0] next_pc_val;
    assign pc_next = pc + 4; // 计算下一个PC值

    always @(*) begin
        case (branch)
            pc_mux_enum.ALU_OUT:
                next_pc_val = alu_result;
            pc_mux_enum.PC_ADDER:
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
