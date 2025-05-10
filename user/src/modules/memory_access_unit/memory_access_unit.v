module memory_access_unit(
        // Internal signals
        input [1:0] mem_op,
        input [2:0] mem_sel,
        input [31:0] mem_addr,
        input [31:0] mem_wdata,
        output reg [31:0] mem_rdata,

        // External signals
        output reg bus_re,
        output reg [3:0] bus_we,
        output reg [31:0] bus_addr,
        output reg [31:0] bus_wdata,
        input [31:0] bus_rdata
    );

    MEM_OP_ENUM mem_op_enum();

    wire [31:0] st_mem_rdata;
    wire st_bus_re;
    wire [3:0] st_bus_we;
    wire [31:0] st_bus_wdata;
    wire [31:0] ld_mem_rdata;
    wire ld_bus_re;
    wire [3:0] ld_bus_we;
    wire [31:0] ld_bus_wdata;

    always @(*) begin
        case (mem_op)
            mem_op_enum.LOAD: begin
                bus_re = ld_bus_re;
                bus_we = ld_bus_we;
                bus_addr = mem_addr;
                bus_wdata = ld_bus_wdata;
                mem_rdata = ld_mem_rdata;
            end
            mem_op_enum.STORE: begin
                bus_re = st_bus_re;
                bus_we = st_bus_we;
                bus_addr = mem_addr;
                bus_wdata = st_bus_wdata;
                mem_rdata = st_mem_rdata;
            end
            default: begin
                bus_re = 1'b0;
                bus_we = 4'b0;
                bus_addr = 32'hz;
                bus_wdata = 32'hz;
                mem_rdata = 32'hz;
            end
        endcase
    end

    memory_access_unit_store
        u_store(
            .mem_sel   	(mem_sel    ),
            .mem_addr  	(mem_addr   ),
            .mem_wdata 	(mem_wdata  ),
            .mem_rdata 	(st_mem_rdata  ),
            .bus_re    	(st_bus_re     ),
            .bus_we    	(st_bus_we     ),
            .bus_wdata 	(st_bus_wdata  ),
            .bus_rdata 	(bus_rdata  )
        );

    memory_access_unit_load
        u_load(
            .mem_sel   	(mem_sel    ),
            .mem_addr  	(mem_addr   ),
            .mem_wdata 	(mem_wdata  ),
            .mem_rdata 	(ld_mem_rdata  ),
            .bus_re    	(ld_bus_re     ),
            .bus_we    	(ld_bus_we     ),
            .bus_wdata 	(ld_bus_wdata  ),
            .bus_rdata 	(bus_rdata  )
        );
endmodule
