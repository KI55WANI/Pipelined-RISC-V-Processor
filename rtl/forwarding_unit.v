module forwarding_unit(exe_mem_write_input, mem_wb_write_input,wb_write_data, rd_rs1_old, 
											  rd_rs2_old, rs1_sll, rs2_sll, rd_rs1_new, rd_rs2_new);

	input [1:0] rs1_sll, rs2_sll;
	input [63:0] exe_mem_write_input, mem_wb_write_input, wb_write_data, rd_rs1_old, rd_rs2_old;
	
	output reg[63:0] rd_rs1_new, rd_rs2_new;
	
	always @(*) begin
		case (rs1_sll)
			2'b00: rd_rs1_new = rd_rs1_old;
			2'b01: rd_rs1_new = exe_mem_write_input;
			2'b10: rd_rs1_new = mem_wb_write_input;
			2'b11: rd_rs1_new = wb_write_data;
		endcase
		case (rs2_sll)
			2'b00: rd_rs2_new = rd_rs2_old;
			2'b01: rd_rs2_new = exe_mem_write_input;
			2'b10: rd_rs2_new = mem_wb_write_input;
			2'b11: rd_rs2_new = wb_write_data;
		endcase
	end
	
endmodule