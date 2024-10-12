`timescale 1ns / 1ps
///////////////////////
module MW_REG(clk,reset,refresh,en,M_pc,M_instr,M_jump,M_alu,M_DMout,M_ext,W_pc,W_ext,W_instr,W_alu,W_DMout,W_jump);
input clk,reset,refresh,en;
input [31:0] M_alu,M_DMout,M_pc,M_instr,M_ext;
input M_jump;
output reg [31:0] W_alu,W_DMout,W_pc,W_instr,W_ext;
output reg W_jump;
initial begin
	W_instr <= 32'b0;
end
	always @(posedge clk)begin
		if(reset | refresh)begin
			W_alu <= 0;
			W_jump <= 0;
			W_DMout <= 0;
			W_pc <= 0;
			W_instr <= 0;
			W_ext <= 0;
		end
		else if(en)begin
			W_alu <= M_alu;
			W_DMout <= M_DMout;
			W_jump <= M_jump;
			W_pc <= M_pc;
			W_instr <= M_instr;
			W_ext <= M_ext;
		end
	end

endmodule
