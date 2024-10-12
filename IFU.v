`timescale 1ns / 1ps
//////////////
module IFU(NPC,clk,reset,IFUgo,PC);
input [31:0] NPC;
input clk;
input reset;
input IFUgo;
output reg [31:0] PC;


/*reg [31:0] ROM [0:40950];
	initial begin
		$readmemh("code.txt", ROM);
		PC <= 32'h0;
	end*/
	
	always @(posedge clk)begin
		if(reset)begin
			PC <= 32'b0;
		end
		else if(IFUgo)begin
		PC <= NPC;
		end
	end
	
	/*assign instr = ROM[PC[31:2]];
	assign imm = instr[25:0];
	assign offest = instr[15:0];
	assign rs = instr[25:21];
	assign rt = instr[20:16];
	assign rd = instr[15:11];*/
endmodule
