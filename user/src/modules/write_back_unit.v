`include "../../inc/registers_writeback.v"

module write_back_unit(
        input wire [1:0] wb_sel,
        input wire [31:0] alu_result,
        input wire [31:0] immediate,
        input wire [31:0] mem_data,
        input wire [31:0] pc_next,
        output wire [31:0] write_data
    );

    always @(*) begin
        case (wb_sel)
            `REG_WB_ALU_OUT:
                write_data = alu_result;
            `REG_WB_IMM_DAT:
                write_data = immediate;
            `REG_WB_MEM_DAT:
                write_data = mem_data;
            `REG_WB_PC_NEXT:
                write_data = pc_next;
            default:
                write_data = 32'b0;
        endcase
    end

endmodule
