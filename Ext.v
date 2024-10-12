`timescale 1ns / 1ps
//////////////
module EXT(imm,EOp,ext);
	input [15:0] imm;
	input [3:0] EOp;
	output [31:0] ext;
	assign ext = (EOp == 4'b0000) ? {{17{imm[15]}},imm[14:0]}://sign
						(EOp == 4'b0001) ? {{16{1'b0}},imm[15:0]}://zero
						(EOp == 4'b0010) ? {imm[15:0],{16{1'b0}}}://lui
						31'b0;
	


endmodule

	/*always @(*)begin
		case(EOp)
			4'b0000:	ext = {{17{imm[15]}},imm[14:0]};//sign
			4'b0001:	ext = {{16{1'b0}},imm[15:0]};//zero
			4'b0010:	ext = {imm[15:0],{16{1'b0}}};//lui
			4'b0011:begin
				ext = {{15{imm[15]}},imm[14:0],{2{imm[0]}}};//beq
			end
			default:ext = ext;
		endcase
	end8*/