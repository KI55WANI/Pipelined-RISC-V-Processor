module processor(clock, reset);

	input clock, reset;

	wire wb_write_en, exe_mem_write_en, mem_wb_write_en, lui, stall, flush, taken, update;
	wire [1:0] rs1_sll, rs2_sll;
	wire [4:0] if_rs1, if_rs2, if_rd, rs1, rs2, rd, wb_write_reg, exe_mem_write_reg, mem_wb_write_reg;
	wire [6:0] if_opcode, id_opcode;
	wire [31:0] pc_next, pc_curr2;
	wire [63:0] rd_rs1_old, rd_rs2_old, rd_rs1_new, rd_rs2_new, wb_write_data, exe_mem_write_input, 
				mem_wb_write_input, left_op;
				
	wire [146:0] if_id_register;
	wire [240:0] id_exe_reg;
	wire [171:0] exe_mem_register;
	wire [69:0] mem_wb_register;


	if_stage IF_STAGE(clock, reset, pc_next, pc_curr2, if_rs1, if_rs2, if_rd, if_opcode, flush, taken, update, if_id_register);

	id_stage ID_STAGE(clock, reset, pc_curr2, pc_next, wb_write_data, wb_write_en, wb_write_reg,
				rs1, rs2, rd, rd_rs1_new, rd_rs2_new, rd_rs1_old, rd_rs2_old, id_opcode, 
				flush, stall, taken, update, if_id_register, id_exe_reg);
				
	exe_stage EXE_STAGE(clock, reset, exe_mem_write_reg, exe_mem_write_en, exe_mem_write_input, 
						  id_exe_reg, exe_mem_register);
						  
	mem_stage MEM_STAGE(clock, reset, mem_wb_write_reg, mem_wb_write_en, mem_wb_write_input, 
						exe_mem_register, mem_wb_register);
						
	wb_stage WB_STAGE(clock, reset, wb_write_en, wb_write_reg, wb_write_data, mem_wb_register);


	
	forwarding_unit FORWARDING_UNIT(exe_mem_write_input, mem_wb_write_input,wb_write_data, rd_rs1_old, 
											  rd_rs2_old, rs1_sll, rs2_sll, rd_rs1_new, rd_rs2_new);
											  
	hazard_detect HAZARD_DETECT(rs1, rs2, exe_mem_write_reg, mem_wb_write_reg, wb_write_reg,
											exe_mem_write_en, mem_wb_write_en, wb_write_en, rs1_sll, rs2_sll, if_rd, if_rs2, 
											if_rs1, if_opcode, id_opcode);
	
	load_hazard_unit LOAD_HAZARD_UNIT(if_rd, if_rs2, if_rs1, if_opcode, id_opcode, rs2, stall);


endmodule
