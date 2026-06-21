module pc(clk, rst, pc_in, pc_out);

input clk, rst;
input [31:0] pc_in;

output reg [31:0] pc_out;

always @ (negedge clk or negedge rst) begin
	if(~rst) begin
		pc_out <= 32'b0;
	end
	
	else begin
		pc_out <= pc_in;
	end
end

endmodule