`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:05:55 11/11/2023
// Design Name:   NPC
// Module Name:   D:/project/ise/p4plus/p4/npc_tb.v
// Project Name:  p4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: NPC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module npc_tb;

	// Inputs
	reg [31:0] PC;
	reg [25:0] imm;
	reg [31:0] PC31;
	reg zero;
	reg [2:0] op;

	// Outputs
	wire [31:0] nextPC;
	wire [31:0] NPC;

	// Instantiate the Unit Under Test (UUT)
	NPC uut (
		.PC(PC), 
		.imm(imm), 
		.PC31(PC31), 
		.nextPC(nextPC), 
		.NPC(NPC), 
		.zero(zero), 
		.op(op)
	);

	initial begin
		// Initialize Inputs
		PC = 0;
		imm = 0;
		PC31 = 0;
		zero = 0;
		op = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

