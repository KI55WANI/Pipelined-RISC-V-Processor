module id_exe(clock, reset, pc_curr, mem_read, mem_to_reg, mem_write_en, 
					alu_src, reg_write_en, write_src, alu_op, extended_imm, rd, rd_rs2_new, 
					left_op, lui, memory_type, id_exe_reg);

	input clock, reset, mem_read, mem_to_reg, mem_write_en, alu_src, reg_write_en, write_src, lui;
	input [1:0] memory_type;	
	input [2:0] alu_op;	
	input [4:0] rd;	
	input [31:0] pc_curr;	
	input [63:0] extended_imm, rd_rs2_new, left_op;
	
	output reg [240:0] id_exe_reg;
	
	always @(negedge clock or negedge reset) begin
if (~reset) begin
    id_exe_reg <= 241'b0 | (241'b1 << 174);
end


		else begin
			id_exe_reg[0]		  <= mem_read;
			id_exe_reg[1]		  <= mem_to_reg;
			id_exe_reg[2]		  <= mem_write_en;
			id_exe_reg[3] 		  <= alu_src;
			id_exe_reg[4] 		  <= reg_write_en;
			id_exe_reg[5] 		  <= lui;
			id_exe_reg[8:6]     <= alu_op;
			id_exe_reg[13:9]    <= rd;
			id_exe_reg[77:14]   <= extended_imm;
			id_exe_reg[109:78]  <= pc_curr;
			id_exe_reg[173:110] <= rd_rs2_new;
			id_exe_reg[174]	  <= write_src;
			id_exe_reg[238:175] <= left_op;
			id_exe_reg[240:239] <= memory_type;
		end
	end

endmodule