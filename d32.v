`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:59:11 11/08/2023 
// Design Name: 
// Module Name:    d32 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module d32( d, we, q, clk, reset ) ;
	input [31:0] d ; 
	input we ;
	output [31:0] q ;
	input clk, reset;
	reg [31:0] r ;
	assign q = r ;
	always @( posedge clk )
	if(reset)
		r <= 32'b0;
	else if ( we )
		r <= d ;
endmodule
