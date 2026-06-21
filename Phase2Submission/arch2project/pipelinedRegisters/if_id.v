module if_id(clock, reset, pc_next, jal, jalr, beq, bne, lui, 
					alu_src, mem_read_en, mem_write_en, reg_write_en, mem_to_reg, write_src, memory_type,
					alu_op, rs1, rs2, rd, opcode, i_imm, u_imm, s_imm, sb_imm, uj_imm, flush, predictionT, if_id_register);

	input clock, reset, flush;
	input jal, jalr, beq, bne, mem_read_en, mem_to_reg, mem_write_en, alu_src, reg_write_en, write_src, lui, predictionT;
	input [1:0] memory_type;
	input [2:0] alu_op;
	input [4:0] rs1, rs2, rd;
	input [6:0] opcode;
	input [31:0] pc_next;	
	input [11:0] i_imm, s_imm, sb_imm;	
	input [19:0] u_imm, uj_imm;
	
	output reg [146:0] if_id_register;
	
	always @(negedge clock or negedge reset or posedge flush) begin
		if (~reset) begin
			if_id_register[9:0]      <= 10'b0;
			if_id_register[10] 	    <= 1'b1;
			if_id_register[146:11]   <= 'b0;
		end
		
		else if(flush) begin
			if_id_register[9:0] 	    <= 10'b0;
			if_id_register[10] 	  	 <= 1'b1;
			if_id_register[146:11] 	 <= 'b0;
		end
		
		else begin
			if_id_register[0] 		 <= lui;
			if_id_register[1] 		 <= jal;
			if_id_register[2] 	 	 <= jalr;
			if_id_register[3] 		 <= beq;
			if_id_register[4] 		 <= bne;
			if_id_register[5] 		 <= mem_read_en;
			if_id_register[6] 		 <= mem_to_reg;
			if_id_register[7] 		 <= mem_write_en;
			if_id_register[8] 		 <= alu_src;
			if_id_register[9] 		 <= reg_write_en;
			if_id_register[10] 		 <= write_src;
			if_id_register[12:11]    <= memory_type;
			if_id_register[15:13]    <= alu_op;
			if_id_register[20:16]    <= rs1;
			if_id_register[25:21]    <= rs2;
			if_id_register[30:26]    <= rd;
			if_id_register[37:31]    <= opcode;
			if_id_register[69:38]    <= pc_next;
			if_id_register[81:70]    <= s_imm;
			if_id_register[93:82]    <= sb_imm;
			if_id_register[105:94] 	 <= i_imm;
			if_id_register[125:106]  <= u_imm;
			if_id_register[145:126]  <= uj_imm;
			if_id_register[146]  	 <= predictionT;

		end
	end

endmodule