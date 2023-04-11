`timescale 1ns/1ns

module mlafa8_test;

	reg clk;
	reg rst;
	reg cin;
	//reg [7:0] R,G,B;
	//wire [7:0] sr,sg,sb;

	top dut(clk,rst);

	initial begin

		clk = 1'b0;
		rst = 1'b0;

	end

	always #200 clk = ~clk;

endmodule
