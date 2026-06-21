module exe_stage(clock, reset, rd, reg_write_en, alu_result, 
						  id_exe_reg, exe_mem_reg);
						  
	input clock, reset;
	input [240:0] id_exe_reg;
	
	output [63:0] alu_result;
	output [171:0] exe_mem_reg;
	
	output reg reg_write_en;
	output reg [4:0] rd;
	
	reg mem_read, mem_to_reg, mem_write, alu_src, write_src, lui;
	reg [1:0] memory_type;
	reg [2:0] alu_op;
	reg [31:0] pc_curr;
	reg [63:0] extended_imm, rd_rs2_new, left_op;
	
	wire [63:0] alu_in2, right_op;

	always @(posedge clock or negedge reset) begin
		if (~reset) begin
			mem_read <= 1'b0;
			mem_to_reg <= 1'b0;
			mem_write <= 1'b0;
			alu_src <= 1'b0;
			reg_write_en <= 1'b0;
			write_src <= 1'b1;
			alu_op <= 3'b0;
			rd <= 5'b0;
			extended_imm <= 64'b0;
			pc_curr <= 32'b0;
			rd_rs2_new <= 64'b0;
			memory_type <= 2'b0;
			left_op <= 64'b0;
			lui <= 1'b0;
		end
		
		else begin
			mem_read		 <= id_exe_reg[0];
			mem_to_reg	 <= id_exe_reg[1];
			mem_write	 <= id_exe_reg[2];
			alu_src 		 <= id_exe_reg[3];
			reg_write_en <= id_exe_reg[4];
			lui 			 <= id_exe_reg[5];
			alu_op 		 <= id_exe_reg[8:6];
			rd 			 <= id_exe_reg[13:9];
			extended_imm <= id_exe_reg[77:14];
			pc_curr 		 <= id_exe_reg[109:78];
			rd_rs2_new   <= id_exe_reg[173:110];
			write_src	 <= id_exe_reg[174];
			left_op		 <= id_exe_reg[238:175];
			memory_type	 <= id_exe_reg[240:239];
		end
	end
	

	_2x1_mux ALU_Operand2_MUX(rd_rs2_new, extended_imm, alu_src, alu_in2);
	_2x1_mux LUI_MUX(alu_in2, 64'b0, lui, right_op);
	
   alu ALU_inst(left_op, right_op, alu_op, alu_result);

	exe_mem EXE_MEM(clock, reset, pc_curr, mem_read, mem_to_reg, mem_write, reg_write_en, 
						 write_src, rd, alu_result, rd_rs2_new, memory_type, exe_mem_reg);

endmodule
