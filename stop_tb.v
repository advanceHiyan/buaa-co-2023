`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:59:01 11/24/2023
// Design Name:   STOP
// Module Name:   D:/project/ise/p4plus/p5/stop_tb.v
// Project Name:  p5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: STOP
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module stop_tb;

	// Inputs
	reg [31:0] D_instr;
	reg [31:0] E_instr;
	reg [31:0] M_instr;

	// Outputs
	wire putoff;

	// Instantiate the Unit Under Test (UUT)
	STOP uut (
		.D_instr(D_instr), 
		.E_instr(E_instr), 
		.M_instr(M_instr), 
		.putoff(putoff)
	);

	initial begin
		// Initialize Inputs
		D_instr = 0;
		E_instr = 0;
		M_instr = 0;

		// Wait 100 ns for global reset to finish
		#100;
			D_instr = 32'b000000_11111_11111_11111_11111_001000;
         E_instr = 32'b000000_00000_00000_00000_00000_100000;
		  #110;
		  D_instr = 32'bx;
		  E_instr = 32'bx;
		  M_instr = 32'bx;
		// Add stimulus here

	end
      
endmodule

