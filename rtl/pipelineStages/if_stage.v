module if_stage(clock, reset, pc_next, pc_curr2, rs1, rs2, rd, opcode_output, flush, taken, update, if_id_register);

    input clock, reset;
	 input flush, update, taken;
    input [31:0] pc_next;
	 

    output wire [4:0] rs1, rs2, rd;
	 output wire [6:0] opcode_output;
	 output [31:0] pc_curr2;
	 output [146:0] if_id_register;
	 
    wire alu_src, mem_read_en, mem_write_en, reg_write_en, mem_to_reg, write_src, predictionT, rd_ins_en;
	 wire jal, jalr, beq, bne, lui;
	 wire [1:0] memory_type;
    wire [2:0] alu_op, funct3;
    wire [6:0] opcode, funct7;
    wire [11:0] i_imm, s_imm, sb_imm;
    wire [19:0] u_imm, uj_imm;
    wire [31:0] pc_curr, predicted_pc, fin_pc;
	 wire [31:0] instr;

    assign opcode = instr[6:0];
	 assign rd = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
	 assign funct7 = instr[31:25];

    assign i_imm = instr[31:20];
    assign s_imm = {instr[31:25], instr[11:7]};
    assign sb_imm = {instr[31], instr[7], instr[30:25], instr[11:8]};
    assign u_imm = instr[31:12];
    assign uj_imm = {instr[31], instr[19:12], instr[20], instr[30:21]};
	 
	 assign opcode_output = opcode;
	 
	 assign fin_pc = (predictionT & (bne | beq)) ? pc_next : predicted_pc;
	 assign pc_curr2 = pc_curr;

    pc PC_inst(clock, reset, fin_pc, pc_curr);
	 
	 instruction_memory IM_inst (clock, reset, pc_curr, instr, rd_ins_en);
	 
    control_unit CU_inst(opcode, funct7, funct3, jal, jalr, beq, bne, lui, 
								 alu_src, mem_read_en, mem_write_en, reg_write_en, mem_to_reg, write_src,
								 memory_type, alu_op);
								 
	if_id IF_ID(clock, reset, pc_next, jal, jalr, beq, bne, lui, 
					alu_src, mem_read_en, mem_write_en, reg_write_en, mem_to_reg, write_src, memory_type,
					alu_op, rs1, rs2, rd, opcode, i_imm, u_imm, s_imm, sb_imm, uj_imm, flush, predictionT, if_id_register);
	
	branch_predict BP(clock, reset, beq, bne, taken, pc_curr, sb_imm, predicted_pc, predictionT, update);

endmodule
