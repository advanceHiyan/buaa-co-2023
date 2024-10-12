///////////////////////////////////
`timescale 1ns / 1ps
//////
module FNPC(PC,nextPC);
input [31:0] PC;

output [31:0] nextPC;

assign nextPC = PC + 4;
endmodule