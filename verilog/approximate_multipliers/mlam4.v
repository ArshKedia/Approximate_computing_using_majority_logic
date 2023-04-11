`timescale 1ns / 1ns

module top(clk,rst);

	parameter WIDTH = 512, HEIGHT = 512;
	parameter length = WIDTH*HEIGHT*3;
	
	input clk;
	input rst;
	
	
	reg [7:0] mem [0:length-1];
	reg [7:0] R,G,B;
	
	//input [7:0] R,G,B;
	
	wire [16:1] sR,sG,sB;
	
	integer i;
	
	initial begin
		$readmemh("Lenna_hex.txt",mem,0,length-1);
		i = 0;
	end
	
	always @(posedge clk) begin
		if(i < length) begin
			R <= mem[i];
			G <= mem[i+1];
			B <= mem[i+2];
			i = i + 3;
			#100;
		end
	end
	
	mlam8x8_mlac22_p10 mulR(R,R,sR);
	mlam8x8_mlac22_p10 mulG(G,G,sG);
	mlam8x8_mlac22_p10 mulB(B,B,sB);
	
	always @(*) begin
		#1;
		$display("@%0t:R= %h, G= %h, B= %h", $time,sR,sG,sB);
		
						
	end

	image_write image(clk,sR[16:9],sG[16:9],sB[16:9]);
	
endmodule

module image_write(input clk, input [7:0] R,G,B);

	parameter WIDTH = 512, HEIGHT = 512;
	parameter length = WIDTH*HEIGHT*3;
	
	integer fd;
	integer count;
	
	initial begin
		fd = $fopen("mlam4_out.txt","w");
		count = 0;
	end
	
	always @(posedge clk) begin
		#1;
		$fwriteh(fd, R);
		$fwrite(fd,"\n");
		$fwriteh(fd, G);
		$fwrite(fd,"\n");
		$fwriteh(fd, B);
		$fwrite(fd,"\n");
		count = count + 3;
		if(count == length) begin
			$fclose(fd);
			$finish;
		end
	end

endmodule

module mlam8x8_mlac22_p10(a,b,out);
input [7:0] a,b;
output [16:1] out;
wire [48:1] pp;
wire [7:1] sa,ca,x;
wire [18:1] s,co;
wire [16:1] comp;
wire [5:1] i0, i1, i2, i3, i4, i5, i6;


mlam_8x8 ml1(a,b,pp,comp);

assign i0 = {pp[13], pp[6], pp[10], pp[9], pp[25]};
assign i1 = {pp[16], pp[15], pp[19], pp[12], pp[28]};
assign i2 = {pp[17], pp[20], pp[29], pp[32], ca[2]};
assign i3 = {pp[18], pp[22], pp[21], pp[37], ca[3]};
assign i4 = {pp[23], pp[28], pp[35], comp[8], co[5]};
assign i5 = {pp[24], pp[40], pp[39], ca[5], 1'b0};
assign i6 = {pp[41], pp[44], comp[14], comp[15], co[7]};


mlac22 mm1(i0,x[1],ca[1],sa[1]);
mlac22 mm2(i1,x[2],ca[2],sa[2]);
mlac22 mm3(i2,x[3],ca[3],sa[3]);
mlac22 mm4(i3,x[4],ca[4],sa[4]);
mlac22 mm5(i4,x[5],ca[5],sa[5]);
mlac22 mm6(i5,x[6],ca[6],sa[6]);
mlac22 mm7(i6,x[7],ca[7],sa[7]);



mlafa mf1(pp[4],pp[3],pp[7],s[1],co[1]);
mlafa mf2(pp[5],pp[8],co[1],s[2],co[2]);
mlafa mf3(pp[14],pp[11],pp[26],s[3],co[3]);
mlafa mf4(pp[27],pp[31],1'b0,s[4],co[4]);
mlafa mf5(pp[30],pp[34],pp[33],s[5],co[5]);
mlafa mf6(comp[13],comp[12],ca[4],s[6],co[6]);
mlafa mf7(pp[43],pp[36],1'b0,s[7],co[7]);
mlafa mf8(pp[42],pp[46],pp[45],s[8],co[8]);
mlafa mf9(sa[1],co[2],1'b0,s[9],co[9]);
mlafa mf10(s[3],ca[1],x[1],s[10],co[10]);
mlafa mf11(sa[2],s[4],co[3],s[11],co[11]);
mlafa mf12(sa[3],co[4],x[2],s[12],co[12]);
mlafa mf13(sa[4],s[5],x[3],s[13],co[13]);
mlafa mf14(sa[5],s[6],x[4],s[14],co[14]);
mlafa mf15(sa[6],s[7],co[6],s[15],co[15]);
mlafa mf16(sa[7],ca[6],x[6],s[16],co[16]);
mlafa mf17(s[8],ca[7],x[7],s[17],co[17]);
mlafa mf18(pp[47],comp[16],co[8],s[18],co[18]);


assign out[1] = pp[1];
assign out[2] = pp[2];
assign out[3] = s[1];
assign out[4] = s[2];
assign out[5] = s[9];

wire [9:1] temp_carr;


efa e1(s[10],co[9],1'b0,temp_carr[1],out[6]);
efa e2(s[11],co[10],temp_carr[1],temp_carr[2],out[7]);
efa e3(s[12],co[11],temp_carr[2],temp_carr[3],out[8]);
efa e4(s[13],co[12],temp_carr[3],temp_carr[4],out[9]);
efa e5(s[14],co[13],temp_carr[4],temp_carr[5],out[10]);
efa e6(s[15],co[14],temp_carr[5],temp_carr[6],out[11]);
efa e7(s[16],co[15],temp_carr[6],temp_carr[7],out[12]);
efa e8(s[17],co[16],temp_carr[7],temp_carr[8],out[13]);
efa e9(s[18],co[17],temp_carr[8],temp_carr[9],out[14]);
efa e10(pp[48],co[18],temp_carr[9],out[16],out[15]);

endmodule








module mlam_8x8(a,b,pp,comp);
input [7:0] a,b;
output [48:1] pp;
output [16:1] comp;

mlam_pp_2x2 z1(a[1:0],b[1:0],pp[3:1], comp[1]);
mlam_pp_2x2 z2(a[1:0],b[3:2],pp[6:4], comp[2]);
mlam_pp_2x2 z3(a[1:0],b[1:0],pp[9:7], comp[3]);
mlam_pp_2x2 z4(a[1:0],b[3:2],pp[12:10], comp[4]);

mlam_pp_2x2 z5(a[1:0],b[5:4],pp[15:13], comp[5]);
mlam_pp_2x2 z6(a[1:0],b[7:6],pp[18:16], comp[6]);
mlam_pp_2x2 z7(a[3:2],b[5:4],pp[21:19], comp[7]);
mlam_pp_2x2 z8(a[3:2],b[7:6],pp[24:22], comp[8]);

mlam_pp_2x2 z9(a[5:4],b[1:0],pp[27:25], comp[9]);
mlam_pp_2x2 z10(a[5:4],b[3:2],pp[30:28], comp[10]);
mlam_pp_2x2 z11(a[7:6],b[1:0],pp[33:31], comp[11]);
mlam_pp_2x2 z12(a[7:6],b[3:2],pp[36:34], comp[12]);

mlam_pp_2x2 z13(a[5:4],b[5:4],pp[39:37], comp[13]);
mlam_pp_2x2 z14(a[5:4],b[7:6],pp[42:40], comp[14]);
mlam_pp_2x2 z15(a[7:6],b[5:4],pp[45:43], comp[15]);
mlam_pp_2x2 z16(a[7:6],b[7:6],pp[48:46], comp[16]);

endmodule





module mlam_pp_2x2(a,b,out,comp);
input [1:0] a,b;
output [2:0] out;
output comp;
majority m1(a[0],b[0],1'b0,out[0]);
majority m2(a[0],b[1],1'b0,out[1]);
majority m3(a[1],b[1],1'b0,out[2]);
majority m4(a[1],b[0],1'b0,comp);
endmodule



module efa(a,b,cin,cout,sum);
input a,b,cin;
output cout,sum;
wire t0,t1,t2,t3;
assign t0 = ~cin;
majority m7(a,b,t0, t1);
majority m8(a,b,cin, t2);
assign cout = t2;
assign t3 = ~t2;
majority m9(cin,t1,t3,sum);
endmodule



//module mlac4(p,sum,carry);
//input [5:1] p;
//output sum,carry;
//wire t0,t1;
//majority m15(p[5], p[4], 1'b1,t0);
//majority m16(p[3], p[2], p[1], t1);
//majority m17(t0,1'b1, t1, carry);
//majority m18(t1,p[4],p[5], sum);
//endmodule




module mlac22(p,cout,carry,sum);
input [5:1] p;
output cout,carry,sum;
wire t0,t1,t2;
assign cout = p[1];
assign t0 = ~p[1];
majority m5(t0,p[2],p[3],t1);
assign carry = t1;
assign t2 = ~t1;
majority m6(p[5],p[4],t2,sum);
endmodule



module mlafa(a,b,cin,cout,sum);
input a,b,cin;
output cout,sum;
wire t0;
assign t0=~cin;
assign cout = cin;
majority m10(a,b,t0,sum);
endmodule


module majority(a,b,c,out);
input a,b,c;
output out;
assign out = a&b | b&c | c&a;
endmodule
