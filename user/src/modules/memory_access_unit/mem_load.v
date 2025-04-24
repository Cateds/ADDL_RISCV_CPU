module memory_access_unit_load(
        // Internal signals
        input [2:0] mem_sel,
        input [31:0] mem_addr,
        input [31:0] mem_wdata,
        output [31:0] mem_rdata,

        // External signals
        output bus_re,
        output [3:0] bus_we,
        output [31:0] bus_wdata,
        input [31:0] bus_rdata
    );

    MEM_SEL_ENUM mem_sel_enum();

    reg [31:0] bus_rdata_reg;

    assign mem_rdata = bus_rdata_reg;
    assign bus_we = 4'b0;
    assign bus_wdata = 32'hz;
    assign bus_re = 1'b1;

    always @(*) begin
        case (mem_sel)
            mem_sel_enum.WORD:
                bus_rdata_reg = bus_rdata;
            mem_sel_enum.HALF_UNSIGNED:
            case (mem_addr[1])
                1'b0:
                    bus_rdata_reg = {16'h0, bus_rdata[15:0]};
                1'b1:
                    bus_rdata_reg = {16'h0, bus_rdata[31:16]};
            endcase
            mem_sel_enum.HALF_SIGNED:
            case (mem_addr[1])
                1'b0:
                    bus_rdata_reg = {{16{bus_rdata[15]}}, bus_rdata[15:0]};
                1'b1:
                    bus_rdata_reg = {{16{bus_rdata[31]}}, bus_rdata[31:16]};
            endcase
            mem_sel_enum.BYTE_UNSIGNED:
            case (mem_addr[1:0])
                2'b00:
                    bus_rdata_reg = {24'h0, bus_rdata[7:0]};
                2'b01:
                    bus_rdata_reg = {24'h0, bus_rdata[15:8]};
                2'b10:
                    bus_rdata_reg = {24'h0, bus_rdata[23:16]};
                2'b11:
                    bus_rdata_reg = {24'h0, bus_rdata[31:24]};
            endcase
            mem_sel_enum.BYTE_SIGNED:
            case (mem_addr[1:0])
                2'b00:
                    bus_rdata_reg = {{24{bus_rdata[7]}}, bus_rdata[7:0]};
                2'b01:
                    bus_rdata_reg = {{24{bus_rdata[15]}}, bus_rdata[15:8]};
                2'b10:
                    bus_rdata_reg = {{24{bus_rdata[23]}}, bus_rdata[23:16]};
                2'b11:
                    bus_rdata_reg = {{24{bus_rdata[31]}}, bus_rdata[31:24]};
            endcase
            default:
                bus_rdata_reg = 32'hz;
        endcase
    end
endmodule
