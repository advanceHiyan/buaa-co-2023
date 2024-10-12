`timescale 1ns / 1ps
module EM_REG(clk,reset,refresh,en,E_mdu,E_pc,E_instr,E_ALUout,E_rt_rd,E_ext,E_jump,M_mdu,M_pc,M_instr,M_ALUout,M_rt_rd,M_ext,M_jump);
    input clk;
    input reset;
    input refresh;
    input en;

    input [31:0] E_pc;
    input [31:0] E_instr;
    input [31:0] E_ALUout;
    input [31:0] E_rt_rd;
    input [31:0] E_ext;
	 input [31:0] E_mdu;
    input E_jump;

    output reg [31:0] M_pc;
    output reg [31:0] M_instr;
    output reg [31:0] M_ALUout;
    output reg [31:0] M_rt_rd;
    output reg [31:0] M_ext;
	 output reg [31:0] M_mdu;
    output reg M_jump;
initial begin
	M_instr <= 32'b0;
end
    always @(posedge clk) begin
        if(reset | refresh) begin
            M_pc <= 0;
            M_instr <= 0;
            M_ALUout <= 0;
            M_rt_rd <= 0;
            M_ext <= 0;
            M_jump <= 0;
				M_mdu <= 0;
        end else if(en) begin
            M_pc <= E_pc;
            M_instr <= E_instr;
            M_ALUout <= E_ALUout;
            M_rt_rd <= E_rt_rd;
            M_ext <= E_ext;
            M_jump <= E_jump;
				M_mdu <= E_mdu;
        end
    end

endmodule