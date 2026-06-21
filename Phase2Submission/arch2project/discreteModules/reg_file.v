module reg_file(clock, reset, rd_reg1, rd_reg2, wr_reg, wr_data, reg_write_en, rd_data1, rd_data2);

	input clock, reset, reg_write_en;
	input [4:0] rd_reg1, rd_reg2, wr_reg;
	input [63:0] wr_data;
	
	output [63:0] rd_data1, rd_data2;
	
	reg [63:0] registers [31:0];
	
	integer i;
	
	always @(negedge clock or negedge reset) begin
		i = 0;
		if(~reset) begin
			for(i=0; i<32; i = i+1) begin
				registers[i] = 64'b0;
				end
		end
		
		else if(reg_write_en) begin
			registers[wr_reg] <= wr_data;
			registers[0] <= 64'b0;
		end
	end
	
	assign rd_data1 = registers[rd_reg1];
	assign rd_data2 = registers[rd_reg2];
	
endmodule
	