module mem_wb(clock, reset, reg_write_en, wr_reg, wb_data, mem_wb_reg);

	input clock, reset, reg_write_en;
	input[4:0] wr_reg;
	input[63:0] wb_data;
	
	output reg[69:0] mem_wb_reg;
	
	always @(negedge clock or negedge reset) begin
		if (~reset) begin
			mem_wb_reg[0]    <= 1'b0;
			mem_wb_reg[6:1]  <= 5'b0;
			mem_wb_reg[69:6] <= 64'b0;
		end
		else begin
			mem_wb_reg[0] 	  <= reg_write_en;
			mem_wb_reg[6:1]  <= wr_reg;
			mem_wb_reg[69:6] <= wb_data;
		end
	end
	

endmodule