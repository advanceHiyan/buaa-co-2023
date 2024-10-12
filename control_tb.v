`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:52:05 11/11/2023
// Design Name:   Control
// Module Name:   D:/project/ise/p4plus/p4/control_tb.v
// Project Name:  p4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Control
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module control_tb;

	// Inputs
	reg [5:0] special;
	reg [5:0] offest;

	// Outputs
	wire [2:0] ALUop;
	wire [2:0] EXTop;
	wire [2:0] NPCop;
	wire GRFWE;
	wire DMWN;
	wire [2:0] RAsel;
	wire [2:0] RWsel;
	wire [2:0] ABsel;

	// Instantiate the Unit Under Test (UUT)
	Control uut (
		.special(special), 
		.offest(offest), 
		.ALUop(ALUop), 
		.EXTop(EXTop), 
		.NPCop(NPCop), 
		.GRFWE(GRFWE), 
		.DMWN(DMWN), 
		.RAsel(RAsel), 
		.RWsel(RWsel), 
		.ABsel(ABsel)
	);

	initial begin
		// Initialize Inputs
		special = 0;
		offest = 0;
		#5;
		special = 6'b000000;
		offest = 6'b100000;
		// Wait 100 ns for global reset to finish
		#5;
        special = 6'b000000;
		offest = 6'b100010;
		// Add stimulus here
			#5;
        special = 6'b001101;
	
			#5;
        special = 6'b100011;
		  #5;
        special = 6'b101011;
		  #5;
		  special = 6'b000100;
		  #5;
		  special = 6'b001111;
		  #10;
		  special = 6'b000011;
		  #10;
		  special = 0;
		  offest = 6'b001000;
		  #10;

	end
      
endmodule

