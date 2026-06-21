module hazard_detect(rs1, rs2, exe_mem_write_reg, mem_wb_write_reg, wb_write_reg,
											exe_mem_write_en, mem_wb_write_en, wb_write_en, rs1_sll, rs2_sll,
											if_rd, if_rs2, if_rs1, if_opcode, id_opcode);

	input exe_mem_write_en, mem_wb_write_en, wb_write_en;
	input [4:0] rs1, rs2, exe_mem_write_reg, mem_wb_write_reg, wb_write_reg, if_rd, if_rs2, if_rs1;
	input [6:0] if_opcode, id_opcode;
	
	output reg [1:0] rs1_sll, rs2_sll;
	
	always @(*) begin
		
		if (exe_mem_write_en && (exe_mem_write_reg != 5'b0) && (exe_mem_write_reg == rs1)) begin 
			rs1_sll <= 2'b10;
		end
		else if (mem_wb_write_en && (mem_wb_write_reg != 5'b0) && (mem_wb_write_reg == rs1)) begin 
			rs1_sll <= 2'b01;
		end
		else if (wb_write_en && (wb_write_reg != 5'b0) && (wb_write_reg == rs1)) begin
			rs1_sll <= 2'b11;
		end
		else begin rs1_sll <= 2'b00; end


		if (exe_mem_write_en && (exe_mem_write_reg != 5'b0) && (exe_mem_write_reg == rs2)) begin 
			rs2_sll <= 2'b10;
		end
		else if (mem_wb_write_en && (mem_wb_write_reg != 5'b0) && (mem_wb_write_reg == rs2)) begin 
			rs2_sll <= 2'b01;
		end
		else if (wb_write_en && (wb_write_reg != 5'b0) && (wb_write_reg == rs2)) begin
			rs2_sll <= 2'b11;
		end
		else begin rs2_sll <= 2'b00; end
		
		
	end
endmodule