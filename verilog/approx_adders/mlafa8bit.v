`timescale 1ns / 1ns

module top(clk,rst,cin);

	parameter WIDTH = 512, HEIGHT = 512;
	parameter length = WIDTH*HEIGHT;
	
	input clk;
	input rst;
	input cin;
	
	wire w1,w2,w3,w4,w5,w6,w7,w0,w8,w9,w10,w11,w12,w13,w14,w15;
	reg [7:0] mem [0:length-1];
	reg [7:0] R,G,B;
	
	//input [7:0] R,G,B;
	
	wire [7:0] sR,sG,sB;
	wire cR,cG,cB;
	
	integer i;
	
	initial begin
		$readmemh("Lenna_gray_hex.txt",mem,0,length-1);
		i = 0;
	end
	
	always @(posedge clk) begin
		if(i < length) begin
			R <= mem[i];
//			G <= mem[i+1];
//			B <= mem[i+2];
			i = i + 1;
			#100;
		end
	end
	
	mlafa8 add(R,R,cin,sR,cR);
//	mlafa8 addG(G,G,cin,sG,cG);
//	mlafa8 addB(B,B,cin,sB,cB);
	
	always @(*) begin
		#1;
//		$display("@%0t:R= %h, G= %h, B= %h", $time,sR,sG,sB);
		$display("@%0t:R= %h", $time, sR);
						
	end

//	image_write image(clk,sR,sG,sB);
	image_write image(clk,sR);
	
endmodule

module image_write(input clk, input [7:0] R);

	parameter WIDTH = 512, HEIGHT = 512;
	parameter length = WIDTH*HEIGHT;
	integer fd;
	integer count;
	
	initial begin
		fd = $fopen("mlafa_3333_3333_lenna_grey.txt","w");
		count = 0;
	end
	
	always @(posedge clk) begin
		#1;
		$fwriteh(fd, R);
		$fwrite(fd,"\n");
//		$fwriteh(fd, G);
//		$fwrite(fd,"\n");
//		$fwriteh(fd, B);
//		$fwrite(fd,"\n");
		count = count + 1;
		if(count == length) begin
			$fclose(fd);
			$finish;
		end
	end

endmodule

//MLAFA_3333-3333
module mlafa8(input [7:0] a,b, input cin, output [7:0] s, output cout);
	
	reg [7:0] sreg;
	reg creg;
	wire w1,w2,w3,w4,w5,w6,w7,w0,w8,w9,w10,w11,w12,w13,w14,w15;
	
	majority m1(a[0],b[1], cin, w0);
	majority m2(a[1],b[0], cin, w1);
	majority m3(a[1],b[1], cin, w2);
	majority m4(a[2],b[3], w2, w3);
	majority m5(a[3],b[2], w2, w4);
	majority m6(a[3],b[3], w2, w5);
	majority m7(a[4],b[5], w5, w6);
	majority m8(a[5],b[4], w5, w7);
	majority m9(a[5],b[5], w5, w8);
	majority m10(a[6],b[7], w8, w9);
	majority m11(a[7],b[6], w8, w10);
	majority m12(a[7],b[7], w8, w11);
	majority m13(~cin,w0, w1, w12);
	majority m14(~w2,w3, w4, w13);
	majority m15(~w5,w6, w7, w14);
	majority m16(~w8,w9, w10, w15);
	
	always @(*) begin
		sreg <= {~w11,w15,~w8,w14,~w5,w13,~w2,w12};
		creg <= w11;
	end
	
	assign s = sreg;
	assign cout = creg;
	
endmodule

//MLAFA_1233-3333
/*module mlafa8(input [7:0] a,b, input cin, output [7:0] s, output cout);

	reg [7:0] sreg;
	reg creg;
	wire w1,w2,w3,w4,w5,w6,w7,w0,w8,w9,w10,w11,w12,w13;

	majority m1(a[0],b[0], cin, w0);
	majority m2(a[1],b[1], ~w0, w1);
	majority m3(a[2],b[3], w0, w2);
	majority m4(a[3],b[2], w0, w3);
	majority m5(a[3],b[3], w0, w4);
	majority m6(a[4],b[5], w4, w5);
	majority m7(a[5],b[4], w4, w6);
	majority m8(a[5],b[5], w4, w7);
	majority m9(a[6],b[7], w7, w8);
	majority m10(a[7],b[6], w7, w9);
	majority m11(a[7],b[7], w7, w10);
	majority m12(~w0,w2, w3, w11);
	majority m13(~w4,w5, w6, w12);
	majority m14(~w7,w8, w9, w13);

	always @(*) begin
	    sreg <= {~w10,w13,~w7,w12,~w4,w11,w1,~w0};
	    creg <= w10;
	end
	
	assign s = sreg;
	assign cout = creg;

endmodule*/

//MLAFA_1212-3333
/*module mlafa8(input [7:0] a,b, input cin, output [7:0] s, output cout);
	
	reg [7:0] sreg;
	reg creg;
	wire w1,w2,w3,w4,w5,w6,w7,w0,w8,w9,w10,w11;

	majority m1(a[0],b[0], cin, w0);
	majority m2(a[1],b[1], ~w0, w1);
	majority m3(a[2],b[2], w0, w2);
	majority m4(a[3],b[3], ~w2, w3);
	majority m5(a[4],b[5], w2, w4);
	majority m6(a[5],b[4], w2, w5);
	majority m7(a[5],b[5], w2, w6);
	majority m8(a[6],b[7], w6, w7);
	majority m9(a[7],b[6], w6, w8);
	majority m10(a[7],b[7], w6, w9);
	majority m11(~w2,w4, w5, w10);
	majority m12(~w6,w7, w8, w11);

	always @(*) begin
	    sreg <= {~w9,w11,~w6,w10,w3,~w2,w1,~w0};
	    creg <= w9;
	end
	
	assign s = sreg;
	assign cout = creg;

endmodule*/

//MLAFA_1212-1233
/*module mlafa8(input [7:0] a,b, input cin, output [7:0] s, output cout);
	
	reg [7:0] sreg;
	reg creg;
	wire w1,w2,w3,w4,w5,w6,w7,w0,w8,w9;

	majority m1(a[0],b[0], cin, w0);
	majority m2(a[1],b[1], ~w0, w1);
	majority m3(a[2],b[2], w0, w2);
	majority m4(a[3],b[3], ~w2, w3);
	majority m5(a[4],b[4], w2, w4);
	majority m6(a[5],b[5], ~w4, w5);
	majority m7(a[6],b[7], w4, w6);
	majority m8(a[7],b[6], w4, w7);
	majority m9(a[7],b[7], w4, w8);
	majority m10(~w4,w6, w7, w9);

	always @(*) begin
	    sreg = {~w8,w9,w5,~w4,w3,~w2,w1,~w0};
	    creg <= w8;
	end
	
	assign s = sreg;
	assign cout = creg;

endmodule*/

//MLAFA_1212-1212
/*module mlafa8(input [7:0] a,b, input cin, output [7:0] s, output cout);
	
	reg [7:0] sreg;
	reg creg;
	wire w1,w2,w3,w4,w5,w6,w7,w8;

	majority m1(a[0],b[0], cin, w1);
	majority m2(a[1],b[1], ~w1, w2);
	majority m3(a[2],b[2], w1, w3);
	majority m4(a[3],b[3], ~w3, w4);
	majority m5(a[4],b[4], w3, w5);
	majority m6(a[5],b[5], ~w5, w6);
	majority m7(a[6],b[6], w5, w7);
	majority m8(a[7],b[7], ~w7, w8);

	always @(*) begin
	    sreg <= {w8,~w7,w6,~w5,w4,~w3,w2,~w1};
	    creg <= w7;
	end
	
	assign s = sreg;
	assign cout = creg;

endmodule*/

//MLAFA_2121-2121
/*module mlafa8(input [7:0] a,b, input cin, output [7:0] s, output cout);
	
	reg [7:0] sreg;
	reg creg;
	wire w1,w2,w3,w4,w5,w6,w7,w8;

	majority m1(a[0],b[0], ~cin, w1);
	majority m2(a[1],b[1], cin, w2);
	majority m3(a[2],b[2], ~w2, w3);
	majority m4(a[3],b[3], w2, w4);
	majority m5(a[4],b[4], ~w4, w5);
	majority m6(a[5],b[5], w4, w6);
	majority m7(a[6],b[6], ~w6, w7);
	majority m8(a[7],b[7], w6, w8);

	always @(*) begin
	    sreg <= {~w8,w7,~w6,w5,~w4,w3,~w2,w1};
	    creg <= w8;
	end
	
	assign s = sreg;
	assign cout = creg;

endmodule*/

//MLAFA_2121-1212
/*module mlafa8(input [7:0] a,b, input cin, output [7:0] s, output cout);
	
	reg [7:0] sreg;
	reg creg;
	wire w1,w2,w3,w4,w5,w6,w7,w8;

	majority m1(a[0],b[0], ~cin, w1);
	majority m2(a[1],b[1], cin, w2);
	majority m3(a[2],b[2], ~w2, w3);
	majority m4(a[3],b[3], w2, w4);
	majority m5(a[4],b[4], w4, w5);
	majority m6(a[5],b[5], ~w5, w6);
	majority m7(a[6],b[6], w5, w7);
	majority m8(a[7],b[7], ~w7, w8);

	always @(*) begin
	    sreg <= {w8,~w7,w6,~w5,~w4,w3,~w2,w1};
	    creg <= w7;
	end
	
	assign s = sreg;
	assign cout = creg;

endmodule*/

//MLAFA_1212-2121
/*module mlafa8(input [7:0] a,b, input cin, output [7:0] s, output cout);
	
	reg [7:0] sreg;
	reg creg;
	wire w1,w2,w3,w4,w5,w6,w7,w8;

	majority m1(a[0],b[0], cin, w1);
	majority m2(a[1],b[1], ~w1, w2);
	majority m3(a[2],b[2], w1, w3);
	majority m4(a[3],b[3], ~w3, w4);
	majority m5(a[4],b[4], ~w3, w5);
	majority m6(a[5],b[5], w3, w6);
	majority m7(a[6],b[6], ~w6, w7);
	majority m8(a[7],b[7], w6, w8);

	always @(*) begin
	    sreg <= {~w8,w7,~w6,w5,w4,~w3,w2,~w1};
	    creg <= w8;
	end
	
	assign s = sreg;
	assign cout = creg;

endmodule*/

module majority(a,b,c,out);
	
	input a,b,c;
	output  reg out;
	always @(*)
		out <= a&b | b&c | c&a;
endmodule


