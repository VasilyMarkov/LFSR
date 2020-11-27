`timescale 1ns/1ns
`include "lfsr.v"

module lfsr_tb();

reg [7:0] seed;
reg load;
reg clk;
reg rst;
wire [7:0] data;
wire out;


	lfsr i1 (seed, load, clk, rst, data, out);
	always
		#5 clk = !clk;
	initial
	begin
		clk = 0;
		rst = 0;
		seed = 0;
	end

	initial
	begin
		$dumpfile("out.vcd");
		$dumpvars(0,i1);
	end

	initial
	begin	
		
		#50 rst = 1;
		load = 1; 
		seed = 8'hD3; //seed
		#10 load = 0;
		#5000 $finish;
	end

endmodule