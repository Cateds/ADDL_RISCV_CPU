module pc_adder(
        input wire [31:0] pc,
        input wire [31:0] immediate,
        output wire [31:0] pc_adder_result
    );
    assign pc_adder_result = pc + immediate;
endmodule
