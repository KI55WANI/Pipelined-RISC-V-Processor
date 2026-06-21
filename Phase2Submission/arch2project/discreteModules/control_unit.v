module control_unit(opcode, funct7, funct3, jal, jalr, beq, bne, lui, 
								 mem_read_en, mem_to_reg, mem_write_en, alu_src, reg_write_en, write_src,
								 mem_type, alu_op);

    input wire [6:0] opcode, funct7;
    input wire [2:0] funct3;
	 
    output reg jal, jalr, beq, bne, lui, mem_read_en, mem_to_reg, mem_write_en, alu_src, reg_write_en, write_src;
    output reg [1:0] mem_type;
    output reg [2:0] alu_op;

	 //opcode: R, U, UJ, SB, S Types
    parameter r_type=7'h40, addi_ori=7'h19, andi_type=7'h1A, 
				  load=7'h03, store=7'h21, branch=7'h62, lui_op=7'h38, jal_op=7'h6f, jalr_op=7'h67;
	 
	 //funct3: R Types
    parameter f3_srl = 3'b000, f3_or = 3'b001, f3_xor = 3'b010, f3_slt = 3'b011, f3_and = 3'b100, 
				  f3_sub = 3'b101, f3_addw = 3'b110, f3_sll = 3'b111;
	 
	 //funct3: I Types
	 parameter f3_addiw=3'b000, f3_andi=3'b110, f3_ori=3'b111;
	 
	 
	 //funct3: SB, S Types
    parameter f3_beq=3'b010, f3_bne=3'b000, f3_lw=3'b000, f3_lh=3'b010, f3_sw=3'b010, f3_sb=3'b000;
	 
	 //funct7 for necessary fields
    parameter f7_sub=7'b0100000;

    always @(*) begin
	 //default values
		jal=1'b0; jalr=1'b0; beq=1'b0; bne=1'b0; 
		lui=1'b0; mem_read_en=1'b0; mem_to_reg=1'b0; 
		mem_write_en=1'b0; alu_src=1'b0; reg_write_en=1'b0; 
		write_src=1'b1; alu_op=3'b000; mem_type=2'b11;

		case (opcode)
			r_type: begin
                reg_write_en=1;
                case (funct3)
                    f3_addw: alu_op=3'b000;
                    f3_and : alu_op=3'b001;
                    f3_xor : alu_op=3'b010;
                    f3_or  : alu_op=3'b011;
                    f3_sll : alu_op=3'b100;
                    f3_srl : alu_op=3'b101;
						  f3_sub : alu_op=3'b110;
                    f3_slt : alu_op=3'b111;
                    default: alu_op=3'bxxx;
                endcase
			end

			addi_ori: begin
                reg_write_en=1'b1; alu_src=1'b1;
                case (funct3)
                    f3_addiw: alu_op=3'b000;
                    f3_ori: alu_op=3'b011;
                    default: alu_op=3'bxxx;
                endcase
         end

			andi_type: begin
                reg_write_en=1'b1; alu_src=1'b1;
                alu_op = 3'b001;
         end

			load: begin
                reg_write_en=1'b1; mem_read_en=1'b1; mem_to_reg=1'b1; alu_src=1'b1;
                case (funct3)
                    f3_lh: mem_type=2'b01;
                    f3_lw: mem_type=2'b10;
                    default: mem_type=2'bxx;
                endcase
			end

         store: begin
                mem_write_en=1'b1; alu_src=1'b1;
                case (funct3)
                    f3_sb: mem_type=2'b00;
                    f3_sw: mem_type=2'b10;
                    default: mem_type=2'bxx;
                endcase
			end

         branch: begin
                case (funct3)
                    f3_beq: beq=1'b1;
                    f3_bne: bne=1'b1;
                    default: begin beq=1'bx; bne=1'bx; end
                endcase
			end

         jal_op: begin
                jal=1'b1; reg_write_en=1'b1; write_src=1'b0;
         end

         jalr_op: begin
                jalr=1'b1; reg_write_en=1'b1; alu_src=1'b1; write_src=1'b0;
         end

         lui_op: begin
                reg_write_en=1'b1; alu_src=1'b1; lui=1'b1;
          end

          default: begin
                jal = 1'b0;
                jalr = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                mem_read_en = 1'b0;
                mem_to_reg = 1'b0;
                mem_write_en = 1'b0;
                alu_src = 1'b0;
                reg_write_en = 1'b0;
                alu_op = 3'b000;
                write_src = 1'b0;
                mem_type = 2'b11;
          end
			 
        endcase
    end

endmodule
