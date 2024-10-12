`timescale 1ns / 1ps
//////
module NPC(PC,F_PC,imm,PC31,nextPC,NPC,zero,op,bpj);
input [31:0] PC,F_PC;
input [25:0] imm;
input [31:0] PC31;
input [2:0] op;
input zero,bpj;
output [31:0] NPC;
output [31:0] nextPC;
	wire [15:0] offest;
	assign offest = imm[15:0];
	assign nextPC = PC + 4;
	assign NPC = (op === 3'b000) ? (F_PC + 4):
						(op === 3'b001 && zero == 1) ? PC + 4 + {{14{offest[15]}}, offest, 2'b00}:
						(op === 3'b010) ? ({PC[31:28], imm, 2'b00} - 32'h0000_3000)://jal
						(op === 3'b011) ? (PC31 - 32'h0000_3000)://jr
						(F_PC + 4);	
	
endmodule
  
  //posedge,negedge,integer
  
  /*wire [15:0] offest;
	wire [31:0] pc4;
	wire [31:0] beqpc;
	assign beqpc = PC + 4 + {{14{offest[15]}}, offest, 2'b00};
	assign offest = imm[15:0];
	assign pc4 = PC + 4;
	
	always @(*)begin
		case(op)
			3'b000:NPC = pc4;
			3'b001:NPC = zero == 0 ? beqpc:pc4;
			3'b010:NPC = {PC[31:28], imm, 2'b00};//j ,jal
			3'b011:NPC = PC31;//jr
			default:NPC = pc4;
		endcase
	end*/
