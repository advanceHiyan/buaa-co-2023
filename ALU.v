`timescale 1ns / 1ps
///////////////////////////
module ALU(A,B,ALUOp,C,eq);
input [31:0] A;
input [31:0] B;
input [2:0] ALUOp;
output [31:0] C;
output eq;
	assign eq = (A == B) ? 1:0;
	assign C = (ALUOp == 3'b000) ? A+B:
					(ALUOp == 3'b001) ? A - B:
					(ALUOp == 3'b010) ? A & B:
					(ALUOp == 3'b011) ? A | B:
					(ALUOp == 3'b100) ? A >> B:
					(ALUOp == 3'b101) ? $signed(A) >>> B://หใสý
					32'b0;
					
endmodule
