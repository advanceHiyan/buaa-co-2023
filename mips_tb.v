`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:12:49 11/11/2023
// Design Name:   mips
// Module Name:   D:/project/ise/p4plus/p4/mips_tb.v
// Project Name:  p4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mips_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [31:0] out_pc;
	wire [31:0] out_instr;
	wire [31:0] out_grfw;
	wire [4:0] out_grfa;
	wire [31:0] out_dm;
	wire [31:0] out_alu; 
	wire [31:0] out_ext;
	wire [2:0] rwsel;
	wire [31:0] aluin;
	wire [2:0] absel;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk),  
		.reset(reset), 
		.out_pc(out_pc), 
		.out_instr(out_instr), 
		.out_grfw(out_grfw), 
		.out_grfa(out_grfa), 
		.out_dm(out_dm), 
		.out_alu(out_alu),
		.out_ext(out_ext),
		.out_rwsel(rwsel),
		.out_aluin(aluin),
		.out_absel(absel)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
       
		// Add stimulus here

	end
	
    always #5 begin 
		clk = ~clk;
	end
endmodule

