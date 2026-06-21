module alu(operand1, operand2, op_sel, result);

	input [63:0] operand1, operand2;
	input [2:0] op_sel;

	reg [1:0] temp;

	output reg [63:0] result;

	always @(*) begin

	temp = {operand1[63],operand2[63]};
	
	case(op_sel)
		3'b000: result = operand1 + operand2;
		3'b001: result = operand1 & operand2;
		3'b010: result = operand1 ^ operand2;
		3'b011: result = operand1 | operand2;
		3'b100: result = operand1 << operand2;
		3'b101: result = operand1 >> operand2;
		3'b110: result = operand1 - operand2;
		3'b111: begin
				case(temp)
					2'b00:	begin
						result = (operand1<operand2);
					end
					
					2'b01:	begin
						result = 0;
					end
					
					2'b10:	begin
						result = 1;
					end
					
					2'b11:	begin
						result = ~(operand1<operand2);
					end
					
				endcase
				end
	endcase
	end
	
endmodule