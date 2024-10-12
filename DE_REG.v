`timescale 1ns / 1ps
///////////////////////////
module DE_REG(clk,reset,refresh,en,D_instr,D_pc,D_ext,D_rd1,D_rd2,D_jump,E_instr,E_pc,E_ext,E_rd1,E_rd2,E_jump);
input clk,reset,refresh,en;
input [31:0] D_instr,D_pc,D_ext,D_rd1,D_rd2;
input D_jump;
output reg [31:0] E_instr,E_pc,E_ext,E_rd1,E_rd2;
output reg E_jump;
initial begin
	E_instr <= 32'b0;
end
	 always @(posedge clk) begin
        if(reset | refresh) begin
            E_pc <= 32'd0;
            E_instr <= 32'd0;
            E_rd1 <= 32'd0;
            E_rd2 <= 32'd0;
            E_ext <= 32'd0;
            E_jump <= 0;
        end else if(en) begin
            E_pc <= D_pc;
            E_instr <= D_instr;
            E_rd1 <= D_rd1;
            E_rd2 <= D_rd2;
            E_ext <= D_ext;
            E_jump <= D_jump;
        end
    end

endmodule
