module write_back_unit(
        input wire [1:0] wb_sel,
        input wire [31:0] alu_result,
        input wire [31:0] immediate,
        input wire [31:0] mem_data,
        input wire [31:0] pc_next,
        output reg [31:0] write_data
    );

    WB_SEL_ENUM wb_sel_enum();

    always @(*) begin
        case (wb_sel)
            wb_sel_enum.ALU_OUT:
                write_data = alu_result;
            wb_sel_enum.IMM_DAT:
                write_data = immediate;
            wb_sel_enum.MEM_DAT:
                write_data = mem_data;
            wb_sel_enum.PC_NEXT:
                write_data = pc_next;
            default:
                write_data = 32'b0;
        endcase
    end

endmodule
