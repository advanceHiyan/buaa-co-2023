`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////
module FD_REG(clk,reset,refresh,en,F_pc,F_instr,D_instr,D_pc);
input clk,reset,refresh,en;
input [31:0] F_pc,F_instr;
output reg [31:0] D_pc,D_instr;
initial begin
	D_instr <= 32'b0;
end
	always @(posedge clk)begin
		if(reset | refresh)begin
			D_instr <= 32'b0;
			D_pc <= 32'b0;//用0执行
		end
		else if(en)begin//不截断后续指令
			D_pc <= F_pc;
			D_instr <= F_instr;
		end
	end

endmodule
