module load_hazard_unit (if_rd, if_rs2, if_rs1, if_opcode, id_opcode, rs2, stall);

	input [4:0] if_rd, if_rs2, if_rs1, rs2;
	input [6:0] if_opcode, id_opcode;
	
	output reg stall;

	
	always @(*) begin
		stall = 1'b0;
		
		if(id_opcode == 7'h03) begin
			if(if_rd == 5'b0) begin //x0 check
				stall = 1'b0;
			end
			
			else if((rs2 == if_rs1) || (rs2 == if_rs2)) begin
				stall = 1'b1;
			end
			
		end
		
		else begin
			stall = 1'b0;
		end
	end

endmodule
