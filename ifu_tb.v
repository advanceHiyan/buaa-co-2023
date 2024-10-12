`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:59:47 11/11/2023
// Design Name:   IFU
// Module Name:   D:/project/ise/p4plus/p4/ifu_tb.v
// Project Name:  p4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: IFU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ifu_tb;

	// Inputs
	reg [31:0] NPC;
	reg clk;
	reg reset;

	// Outputs
	wire [31:0] PC;
	wire [31:0] instr;
	wire [25:0] imm;
	wire [5:0] offest;
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;

	// Instantiate the Unit Under Test (UUT)
	IFU uut (
		.NPC(NPC), 
		
		.clk(clk), 
		.reset(reset), 
		
		.PC(PC), 
		.instr(instr), 
		.imm(imm), 
		.offest(offest), 
		.rs(rs), 
		.rt(rt), 
		.rd(rd)
	);

	initial begin
		// Initialize Inputs
		NPC = 32'h0;
		clk = 0;
		reset = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	always #10 begin clk = ~clk;
	            NPC <= PC + 2;
	end
      
endmodule

