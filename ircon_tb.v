`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:15:21 11/24/2023
// Design Name:   st_ir_conl
// Module Name:   D:/project/ise/p4plus/p5/ircon_tb.v
// Project Name:  p5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: st_ir_conl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ircon_tb;

	// Inputs
	reg [31:0] instr;

	// Outputs
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] GRFaddr;
	wire [2:0] Drs_use;
	wire [2:0] Drt_use;
	wire [2:0] Euse;
	wire [2:0] Muse;

	// Instantiate the Unit Under Test (UUT)
	st_ir_conl uut (
		.instr(instr), 
		.rs(rs), 
		.rt(rt), 
		.GRFaddr(GRFaddr), 
		.Drs_use(Drs_use), 
		.Drt_use(Drt_use), 
		.Euse(Euse), 
		.Muse(Muse)
	);

	initial begin
		// Initialize Inputs
		instr = 0;

		// Wait 100 ns for global reset to finish
		#100;
        instr = 32'bx;
		// Add stimulus here

	end
      
endmodule

