module pc_controller(rs1_data, beq, bne, jal, jalr, zero, pc_curr, predictionT, extended_imm, 
							pc_out, flush, taken, pc_old);

	input beq, bne, jal, jalr, predictionT, zero;
	input [31:0] pc_curr, pc_old;
	input [63:0] rs1_data, extended_imm;
	
	reg previousP;
	reg [31:0] pc_next;
	reg [63:0] temp_result;

	
	output flush;
	output reg taken;
	output [31:0] pc_out;

	always @(*) begin
		taken = 1'b0;
		pc_next = pc_old + 32'd4;
		temp_result = 64'd0;
		
		if (jalr) begin
			temp_result = rs1_data + ((extended_imm - 64'd1) << 2);
			pc_next = temp_result[31:0];
			taken = 1'b1;
		end
		
		else if ((bne & ~zero) | (beq & zero) | (jal)) begin
			temp_result = pc_curr + ((extended_imm - 1) << 2);
			pc_next = temp_result[31:0];
			taken = 1'b1;
		end
		
		else pc_next = pc_old + 'd4;
	end
	
	assign pc_out = (predictionT == taken)? pc_curr + 4 : pc_next;
	assign flush = ((predictionT != taken) & (beq | bne | jal | jalr)) ? 1'b1 : 1'b0; 
endmodule