module mem_stage(clock, reset, rd, reg_write_en, wb_wr_data, 
						exe_mem_reg, mem_wb_reg);

   input clock, reset;
	input [171:0] exe_mem_reg;
	 
	reg mem_read, mem_to_reg, mem_write, write_src;
	reg [1:0] memory_type;
	reg [31:0] pc_curr;
	reg [63:0] alu_result, rs2_data, ext_pc_inc;
	 
	wire update;
   wire [63:0] mem_out, wb_data;
	
	assign update = mem_read | mem_write & clock;
	
	output reg reg_write_en;
	output reg [4:0] rd;
	
	output [63:0] wb_wr_data;
	output [69:0] mem_wb_reg;
	
	always @(posedge clock or negedge reset) begin
		if (~reset) begin
			mem_read  	 <= 1'b0;
			mem_to_reg   <= 1'b0;
			mem_write 	 <= 1'b0;
			reg_write_en <= 1'b0;
			write_src 	 <= 1'b1;
			rd 			 <= 5'b0;
			alu_result 	 <= 64'b0;
			rs2_data  	 <= 64'b0;
			pc_curr  	 <= 32'b0;
			ext_pc_inc 	 <= 64'b0;
			memory_type  <= 2'b00;
		end
		else begin
			mem_read 	 <= exe_mem_reg[0];
			mem_to_reg 	 <= exe_mem_reg[1];
			mem_write 	 <= exe_mem_reg[2];
			reg_write_en <= exe_mem_reg[3];
			write_src  	 <= exe_mem_reg[4];
			rd 			 <= exe_mem_reg[9:5];
			alu_result 	 <= exe_mem_reg[73:10];
			rs2_data 	 <= exe_mem_reg[137:74];
			pc_curr 		 <= exe_mem_reg[169:138];
			ext_pc_inc   <= pc_curr + 64'd1;
			memory_type  <= exe_mem_reg[171:170];
		end
	end


   data_mem DATA_MEM_inst(clock, reset, alu_result, rs2_data, mem_read, mem_write, memory_type, mem_out, update);
	
   _2x1_mux WB_MUX_inst(alu_result, mem_out, mem_to_reg, wb_data);
	
	assign wb_wr_data = (write_src) ? wb_data : ext_pc_inc;

	mem_wb MEM_WB(clock, reset, reg_write_en, rd, wb_wr_data, mem_wb_reg);


endmodule
