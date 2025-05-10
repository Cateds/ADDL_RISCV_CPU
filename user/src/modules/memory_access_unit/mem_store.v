module memory_access_unit_store(
        // Internal signals
        input [2:0] mem_sel,
        input [31:0] mem_addr,
        input [31:0] mem_wdata,
        output [31:0] mem_rdata,

        // External signals
        output bus_re,
        output reg [3:0] bus_we,
        output [31:0] bus_wdata,
        input [31:0] bus_rdata
    );

    MEM_SEL_ENUM mem_sel_enum();

    reg [31:0] bus_wdata_reg;

    assign bus_wdata = bus_wdata_reg;
    assign bus_re = 1'b0;
    assign mem_rdata = 32'hz;

    always @(*) begin
        case (mem_sel)
            mem_sel_enum.BYTE_SIGNED,
            mem_sel_enum.BYTE_UNSIGNED : begin
                case(mem_addr[1:0])
                    2'b00: begin
                        bus_we = 4'b0001;
                        bus_wdata_reg = {24'h0, mem_wdata[7:0]};
                    end
                    2'b01: begin
                        bus_we = 4'b0010;
                        bus_wdata_reg = {16'h0, mem_wdata[7:0], 8'h0};
                    end
                    2'b10: begin
                        bus_we = 4'b0100;
                        bus_wdata_reg = {8'h0, mem_wdata[7:0], 16'h0};
                    end
                    2'b11: begin
                        bus_we = 4'b1000;
                        bus_wdata_reg = {mem_wdata[7:0], 24'h0};
                    end
                endcase
            end
            mem_sel_enum.HALF_SIGNED,
            mem_sel_enum.HALF_UNSIGNED : begin
                case(mem_addr[1])
                    1'b0: begin
                        bus_we = 4'b0011;
                        bus_wdata_reg = {16'h0, mem_wdata[15:0]};
                    end
                    1'b1: begin
                        bus_we = 4'b1100;
                        bus_wdata_reg = {mem_wdata[15:0], 16'h0};
                    end
                endcase
            end
            mem_sel_enum.WORD : begin
                bus_we = 4'b1111;
                bus_wdata_reg = mem_wdata;
            end
            default: begin
                bus_we = 4'b0;
                bus_wdata_reg = 32'hz;
            end
        endcase
    end
endmodule
