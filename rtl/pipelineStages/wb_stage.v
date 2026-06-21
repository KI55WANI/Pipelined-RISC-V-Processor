module wb_stage(clock, reset, wb_write_en, wb_write_reg, wb_write_data, mem_wb_reg);

    input clock, reset;
	 input [69:0] mem_wb_reg;
	 
    output reg wb_write_en;
    output reg [4:0] wb_write_reg;
    output reg [63:0] wb_write_data;

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            wb_write_en   <= 1'b0;
            wb_write_reg  <= 5'b0;
            wb_write_data <= 64'b0;
        end else begin
            wb_write_en   <= mem_wb_reg[0];
            wb_write_reg  <= mem_wb_reg[5:1];
            wb_write_data <= mem_wb_reg[69:6];
        end
    end

endmodule
