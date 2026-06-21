module _2x1_mux #(parameter length = 64) (in1, in2, sel, out); //dynamic

	input [length-1:0] in1, in2;
	
	input sel;
	
	output [length-1:0] out;
	
	assign out = (sel) ? in2 : in1;
	
endmodule