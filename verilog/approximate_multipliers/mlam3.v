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
	
	mlam_8x8_mlac4_p10 mulR(R,R,sR);
	mlam_8x8_mlac4_p10 mulG(G,G,sG);
	mlam_8x8_mlac4_p10 mulB(B,B,sB);
	
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
		fd = $fopen("mlam3_out.txt","w");
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


module mlam_8x8_mlac4_p10(a,b,out);
input [7:0] a,b;
output [16:1] out;
wire [48:1] pp;
wire [16:1] comp;
wire [18:1] co, s;
wire [5:1] ca, sa;
wire [5:1] i0, i1, i2,i3,i4;
mlam_8x8 me1(a,b,pp,comp);
assign out[1] = pp[1];
assign out[2] = pp[2];
assign i0={pp[13], pp[6], pp[10], pp[9], pp[25]};
assign i1={pp[16], pp[15], pp[19], pp[12], co[3]};
assign i2={pp[18], pp[22], pp[21], pp[37], co[6]};
assign i3={pp[23], pp[38], pp[35], co[8], 1'b0};
assign i4={pp[24],pp[40], pp[39], pp[43], pp[36]};


mlac4 mm1(i0, sa[1], ca[1]);
mlac4 mm2(i1, sa[2], ca[2]);
mlac4 mm3(i2, sa[3], ca[3]);
mlac4 mm4(i3, sa[4], ca[4]);
mlac4 mm5(i4, sa[5], ca[5]);


mlafa zz1(pp[4],pp[3],pp[7],co[1],s[1]);
mlafa zz2(pp[5],pp[8],co[1],co[2],s[2]);
mlafa zz3(pp[14],pp[11],pp[26],co[3],s[3]);
mlafa zz4(pp[28],pp[27],pp[31],co[4],s[4]);
mlafa zz5(pp[17],pp[20],co[4],co[5],s[5]);
mlafa zz6(pp[29],pp[32],1'b0,co[6],s[6]);
mlafa zz7(pp[30],pp[34],pp[33],co[7],s[7]);
mlafa zz8(comp[13],comp[12],co[7],co[8],s[8]);
mlafa zz9(pp[41],pp[44],comp[14],co[9],s[9]);
mlafa zz10(pp[42],pp[46],pp[45],co[10],s[10]);
mlafa zz11(sa[1],co[2],1'b0,co[11],s[11]);
mlafa zz12(s[5],s[6],ca[2],co[12],s[12]);
mlafa zz13(sa[3],s[7],co[5],co[13],s[13]);
mlafa zz14(sa[4],s[8],ca[3],co[14],s[14]);
mlafa zz15(sa[5],ca[4],co[8],co[15],s[15]);
mlafa zz16(comp[15],s[9],ca[5],co[16],s[16]);
mlafa zz17(s[10],co[9],1'b0,co[17],s[17]);
mlafa zz18(pp[47],comp[16],co[10],co[18],s[18]);


assign out[4] = s[2];
assign out[5] = s[11];
assign out[3] = s[1];

wire [10:1] temp_carry;
efa ef1(s[3],ca[1],co[11],temp_carry[1],out[6]);
efa ef2(sa[2],s[4],temp_carry[1],temp_carry[2],out[7]);
efa ef3(s[12],1'b0,temp_carry[2],temp_carry[3],out[8]);
efa ef4(s[13],co[12],temp_carry[3],temp_carry[4],out[9]);
efa ef5(s[14],co[13],temp_carry[4],temp_carry[5],out[10]);
efa ef6(s[15],co[14],temp_carry[5],temp_carry[6],out[11]);
efa ef7(s[16],co[15],temp_carry[6],temp_carry[7],out[12]);
efa ef8(s[17],co[16],temp_carry[7],temp_carry[8],out[13]);
efa ef9(s[18],co[17],temp_carry[8],temp_carry[9],out[14]);
efa ef10(pp[48],co[18],temp_carry[9],temp_carry[10],out[15]);
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



module mlac4(p,sum,carry);
input [5:1] p;
output sum,carry;
wire t0,t1;
majority m15(p[5], p[4], 1'b1,t0);
majority m16(p[3], p[2], p[1], t1);
majority m17(t0,1'b1, t1, carry);
majority m18(t1,p[4],p[5], sum);
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
