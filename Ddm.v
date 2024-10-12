`timescale 1ns / 1ps
///////////////////////////
module Ddm(A,Din,op,Dout);
input [1:0] A;
input [31:0] Din;
input [2:0] op;
output [31:0] Dout;

wire [15:0] half_word;
wire [7:0] byte_word;
wire h_sign,b_sign;

assign half_word = Din[(16 * A[1] + 15) -: 16];
assign byte_word = Din[(8 * A[1:0] + 7) -: 8];

assign h_sign =  Din[16 * A[1] + 15];
assign b_sign = Din[8 * A[1:0] + 7];

assign Dout =  (op == 3'b000) ? Din://lw
					(op == 3'b001) ? {{16{h_sign}}, half_word}://lh
					(op == 3'b010) ? {{24{b_sign}}, byte_word}://lb
					32'b0;
endmodule
