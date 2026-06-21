module exe_mem(clock, reset, pc_curr, mem_read, mem_to_reg, mem_write, reg_write_en, 
						 write_src, rd, alu_result, rs2_data, memory_type, exe_mem_reg);

	input clock, reset, mem_read, mem_to_reg, mem_write, reg_write_en, write_src;
	input [1:0] memory_type;
	input [4:0] rd;
	input [31:0] pc_curr;
	input [63:0] alu_result, rs2_data;

	output reg [171:0] exe_mem_reg;
	
	always @(negedge clock or negedge reset) begin
		if (~reset) begin
			exe_mem_reg[3:0]   <= 4'b0;
			exe_mem_reg[4] 	 <= 1'b1;
			exe_mem_reg[171:5] <= 'b0;
		end
		else begin
			exe_mem_reg[0]		   <= mem_read;
			exe_mem_reg[1]		   <= mem_to_reg;
			exe_mem_reg[2]		   <= mem_write;
			exe_mem_reg[3]		   <= reg_write_en;
			exe_mem_reg[4]		   <= write_src;
			exe_mem_reg[9:5]	   <= rd;
			exe_mem_reg[73:10]   <= alu_result;
			exe_mem_reg[137:74]  <= rs2_data;
			exe_mem_reg[169:138] <= pc_curr;
			exe_mem_reg[171:170] <= memory_type;
		end
	end
	
endmodule