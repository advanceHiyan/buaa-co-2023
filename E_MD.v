`timescale 1ns / 1ps
////////////////////////////////////////////////
`define E_mult    4'b0000
`define E_multu   4'b0001
`define E_div     4'b0010
`define E_divu    4'b0011
`define E_mfhi    4'b0100
`define E_mflo    4'b0101
`define E_mthi    4'b0110
`define E_mtlo    4'b0111

/////////////////////////////////////////////////////////////////
module E_MDU(
    input clk,
    input reset,

	 input Start,
    input [31:0] D1,
    input [31:0] D2,
	 input [3:0] op,

    output reg busy,
    output [31:0] MDUout
    );
	 
	reg [31:0] HI,LO,cycle,temp_HI,temp_LO;
	
	assign MDUout = (op == `E_mfhi) ? HI:
						 (op == `E_mflo) ? LO:
						 32'b0;
	
	initial begin
		HI <= 0;
		LO <= 0;
		temp_HI <= 0;
		temp_LO <= 0;
		cycle <= 0;
	end
	 
	always @(posedge clk)begin
		if(reset)begin
			cycle <= 0;
			busy <= 1'b0;
			HI <= 32'd0;
			LO <= 32'd0;
		end		
		else begin
			if(cycle == 0)begin
				if(op == `E_mult)begin
					busy <= 1;
					cycle <= 5;
					{temp_HI, temp_LO} <= $signed(D1) * $signed(D2);
				end
				else if(op == `E_multu)begin
					busy <= 1;
					cycle <= 5;
					{temp_HI, temp_LO} <= D1 * D2;
				end
				else if(op == `E_div)begin
					busy <= 1;
					cycle <= 10;
					temp_HI = $signed(D1) % $signed(D2);
					temp_LO = $signed(D1) / $signed(D2);
				end
				else if(op == `E_divu)begin
					busy <= 1;
					cycle <= 10;
					temp_HI = D1 % D2;
					temp_LO = D1 / D2;
				end
			end//cy == 0
			else if(cycle == 1)begin
				LO <= temp_LO;
				HI <= temp_HI;
				busy <= 1'b0;
				cycle <= 0;
			end//cy == 1
			else begin
				cycle <= cycle - 1;
			end
		end//no reset	
	end//always
	always @(posedge clk)begin
		if(op == `E_mthi) HI <= D1;
				else if(op == `E_mtlo) LO <= D1;
			
	end
endmodule
