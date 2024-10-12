`timescale 1ns / 1ps
////////
module WM(ADDR,WD,DMen,Wdata,byte_en);
input [31:0] ADDR;
input [31:0] WD;
input DMen;

output [31:0] Wdata;
output [3:0] byte_en;
	
endmodule
	