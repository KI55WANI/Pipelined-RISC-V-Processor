module id_stage(clock, reset, pc_curr2, pc_out, wb_write_data, wb_write_en, wb_write_reg,
				rs1, rs2, rd, rd_rs1_new, rd_rs2_new, rd_rs1_old, rd_rs2_old, opcode, 
				flush, stall, taken, update, pc_old, if_id_register, id_exe_reg);

    input clock, reset, wb_write_en, stall;
    input [4:0] wb_write_reg;
	 input [31:0] pc_curr2, pc_old;
    input [63:0] wb_write_data, rd_rs1_new, rd_rs2_new;
	 input [146:0] if_id_register;

	 
	 reg predictionT, mem_read_en, mem_to_reg, mem_write_en, alu_src, reg_write_en, write_src, jal, jalr, beq, bne, lui;
	 reg [1:0] memory_type;
	 reg [2:0] alu_op;
	 reg [11:0] i_imm, s_imm, sb_imm;
	 reg [19:0] u_imm, uj_imm;
	 reg [63:0] extended_imm;
	 reg [63:0] pc_next;



    output flush, taken;
	 output [31:0] pc_out;
	 output [63:0] rd_rs1_old, rd_rs2_old;
	 output [240:0] id_exe_reg;
	 
    output reg [4:0] rs1, rs2, rd;
    output reg [6:0] opcode;
	 
	 output wire update;
	 
	 wire zero;
	 wire [31:0] pc_curr, lui_addr;
	 wire [63:0] left_op;
	 
	 assign update = beq | bne;

	 
	always @(posedge clock or negedge reset) begin
		if (~reset) begin
			jal 			 <= 1'b0;
			jalr 			 <= 1'b0;
			beq 			 <= 1'b0;
			bne 			 <= 1'b0;
			mem_read_en  <= 1'b0;
			mem_to_reg 	 <= 1'b0;
			mem_write_en <= 1'b0;
			alu_src 		 <= 1'b0;
			reg_write_en <= 1'b0;
			write_src 	 <= 1'b1;
			memory_type  <= 2'b0;
			alu_op 		 <= 3'b0;
			rs1 			 <= 5'b0;
			rs2 			 <= 5'b0;
			rd 			 <= 5'b0;
			opcode		 <= 6'b0;
		end
		else if (stall) begin 
			jal 			 <= 1'b0;
			jalr 			 <= 1'b0;
			beq   		 <= 1'b0;
			bne 			 <= 1'b0;
			mem_read_en  <= 1'b0;
			mem_to_reg 	 <= 1'b0;
			mem_write_en <= 1'b0;
			alu_src 		 <= 1'b0;
			reg_write_en <= 1'b0;
			write_src 	 <= 1'b1;
			memory_type  <= 2'b0;
			alu_op 		 <= 3'b0;
			rs1 			 <= 5'b0;
			rs2 			 <= 5'b0;
			rd 			 <= 5'b0;
			opcode 		 <= 7'b0;
		end
		else begin
			lui 			 <= if_id_register[0];
			jal 	  		 <= if_id_register[1];
			jalr 			 <= if_id_register[2];
			beq 			 <= if_id_register[3];
			bne 			 <= if_id_register[4];
			mem_read_en  <= if_id_register[5];
			mem_to_reg 	 <= if_id_register[6];
			mem_write_en <= if_id_register[7];
			alu_src 		 <= if_id_register[8];
			reg_write_en <= if_id_register[9];
			write_src    <= if_id_register[10];
			memory_type  <= if_id_register[12:11];
			alu_op  	  	 <= if_id_register[15:13];
			rs1 		  	 <= if_id_register[20:16];
			rs2 	     	 <= if_id_register[25:21];
			rd 		  	 <= if_id_register[30:26];
			opcode 	  	 <= if_id_register[37:31];
			pc_next    	 <= if_id_register[69:38];
			s_imm  	  	 <= if_id_register[81:70];
			sb_imm 	  	 <= if_id_register[93:82];
			i_imm 	  	 <= if_id_register[105:94];
			u_imm 	  	 <= if_id_register[125:106];
			uj_imm 	  	 <= if_id_register[145:126];
			predictionT	 <= if_id_register[146];
		end
	end
	 
	 
	always @(*) begin
		if (beq | bne == 1'b1) begin
			extended_imm <= {{52{sb_imm[11]}}, sb_imm};
		end

		else if (jal) begin
			extended_imm <= {{44{uj_imm[19]}}, uj_imm};
		end
		
		else if (opcode == 8'h21) begin
			extended_imm <= {{52{s_imm[11]}}, s_imm};
		end

		
		else begin
			extended_imm <= {{52{i_imm[11]}}, i_imm};
		end

	end 
	
	assign pc_curr = (reset == 0) ? 32'b0 : (stall == 1) ? (pc_curr2 - 3'b100) : pc_curr2;
	assign zero = (rd_rs1_new == rd_rs2_new) ? 1'b1 : 1'b0;
	assign lui_addr[11:0] = 12'b0;
	assign lui_addr[31:12] = u_imm;
	
	_2x1_mux leftmux(rd_rs1_new, lui_addr, lui, left_op);
	
   reg_file RF(clock, reset, rs1, rs2, wb_write_reg, wb_write_data, wb_write_en, rd_rs1_old, rd_rs2_old);

   pc_controller PC_CTRL(rd_rs1_new, beq, bne, jal, jalr, zero, pc_curr, predictionT, extended_imm, pc_out, flush, taken, pc_next);
	
	id_exe ID_EXE(clock, reset, pc_curr, mem_read_en, mem_to_reg, mem_write_en, alu_src, reg_write_en, write_src, alu_op, extended_imm, rd, rd_rs2_new, left_op, lui, memory_type, id_exe_reg);


endmodule