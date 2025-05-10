module tb_instruction_decoder();

    reg [31:0] instruction;

    // output declaration of module instr_decoder
    wire [31:0] immediate;
    wire [3:0] alu_op;
    wire [2:0] cmp_op;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire reg_we;
    wire alu_data1_sel;
    wire alu_data2_sel;
    wire [1:0] mem_op;
    wire [2:0] mem_sel;
    wire [1:0] wb_sel;
    wire branch_jump;

    instr_decoder
        u_instr_decoder(
            .instruction   	(instruction    ),
            .immediate     	(immediate      ),
            .alu_op        	(alu_op         ),
            .cmp_op        	(cmp_op         ),
            .rd            	(rd             ),
            .rs1           	(rs1            ),
            .rs2           	(rs2            ),
            .reg_we        	(reg_we         ),
            .alu_data1_sel 	(alu_data1_sel  ),
            .alu_data2_sel 	(alu_data2_sel  ),
            .mem_op        	(mem_op         ),
            .mem_sel       	(mem_sel        ),
            .wb_sel        	(wb_sel         ),
            .branch_jump   	(branch_jump    )
        );


    initial begin
        $dumpfile("tb_instruction_decoder.vcd");
        $dumpvars(0, tb_instruction_decoder);
        #100;
        $finish();
    end

    initial begin
        instruction = 32'h0;
        #10;
        instruction = 32'h003100B3;
        #10;
        instruction = 32'h40628233;
        #10;
        instruction = 32'h00A18093;
    end
endmodule
