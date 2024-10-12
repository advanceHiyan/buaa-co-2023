`timescale 1ns / 1ps
///////////////////////////////////////
module WM(ADDR,WD,op,Wdata,byte_en);
input [31:0] ADDR;
input [31:0] WD;
input [2:0] op;

output [31:0] Wdata;
output [3:0] byte_en;

	wire [1:0] A;
	wire [15:0] half_word;
	wire [7:0] byte_word;
	assign A = ADDR[1:0];
	assign half_word = WD[15:0];
	assign byte_word = WD[7:0];
	
	wire [31:0] sh,sb;
	assign sh = (A[1] == 0) ? {16'b0,half_word}:
					{half_word,16'b0};
	assign sb = (A == 2'b00) ? {24'b0,half_word}:
					(A == 2'b01) ? {16'b0,half_word,8'b0}:
					(A == 2'b10) ? {8'b0,half_word,16'b0}:
					{half_word,24'b0};
					
	wire [3:0] sh_en,sb_en;
	assign sh_en = (A[1] == 0) ? 4'b0011 :
						4'b1100;
	assign sb_en = (A == 2'b00) ? {4'b0001}:
						(A == 2'b01) ? {4'b0010}:
						(A == 2'b10) ? {4'b0100}:
						{4'b1000};
	
assign Wdata = (op == 3'b000) ? WD:
					(op == 3'b001) ? sh:
					(op == 3'b010) ? sb:
					32'b0;
					
assign byte_en =  (op == 3'b000) ? 4'b1111:
						(op == 3'b001) ? sh_en:
						(op == 3'b010) ? sb_en:
						4'b0;
	
endmodule
	
