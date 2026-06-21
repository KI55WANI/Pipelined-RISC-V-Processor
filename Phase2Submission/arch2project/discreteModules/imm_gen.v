module imm_gen(imm, extended_imm);
	input [11:0] imm;
	output [31:0] extended_imm;
	
	assign extended_imm = {{21{imm[11]}}, imm};
	
endmodule