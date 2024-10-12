`timescale 1ns / 1ps
///////////////////////////
module ALU(A,B,ALUop,C,eq);
input [31:0] A;
input [31:0] B;
input [3:0] ALUop;
output [31:0] C;
output eq;
wire [31:0] slt,sltu;

	assign slt = ($signed(A) < $signed(B)) ?  32'b1:32'b0;
	assign sltu = (A[31:0] < B[31:0]) ? 32'b1:32'b0;
	
	assign eq = (A == B) ? 1:0;
	assign C = (ALUop == 4'b0000) ? A+B:
					(ALUop == 4'b0001) ? A - B:
					(ALUop == 4'b0010) ? A & B:
					(ALUop == 4'b0011) ? A | B:
					(ALUop == 4'b0100) ? slt:
					(ALUop == 4'b0101) ? sltu:
					32'b0;
	//A >> B:
//$signed(A) >>> B://ËãÊýX1=$signed($signed(X1)>>>X2);	
endmodule
