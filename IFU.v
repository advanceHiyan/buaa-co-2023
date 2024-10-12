`timescale 1ns / 1ps
//////////////
module IFU(NPC,clk,reset,PC,instr,imm,offest,rs,rt,rd);
input [31:0] NPC;
input clk;
input reset;
output reg [31:0] PC;
output [31:0] instr;
output [25:0] imm;
output [5:0] offest;
output [4:0] rs,rt,rd;

	reg [31:0] ROM [0:4095];
	initial begin
		$readmemh( "code.txt", ROM, 0);
		PC = 32'h0;
	end
	
	always @(posedge clk)begin
		if(reset)begin
			PC = 32'h0;
		end
		else begin
		PC = NPC;
		end
	end
	
	assign instr = ROM[PC[15:2]];
	assign imm = instr[25:0];
	assign offest = instr[15:0];
	assign rs = instr[25:21];
	assign rt = instr[20:16];
	assign rd = instr[15:11];
endmodule
