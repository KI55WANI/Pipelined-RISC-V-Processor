`timescale 1ns/1ps
module testbench;

	reg clk, rst;
	
	initial begin
		clk = 0;
		rst = 0;
		#7 rst = 1;
		#1040 $stop;
	end
	
	always #10 clk = ~clk;
	
	processor uut(clk, rst);
	
	
endmodule
