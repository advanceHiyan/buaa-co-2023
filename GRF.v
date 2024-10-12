`timescale 1ns / 1ps
/////////////////////////
module GRF(A1,A2,A3,WD,WE,WPC,clk,reset,R1,R2);
input [4:0] A1;
input [4:0] A2;
input [4:0] A3;
input [31:0] WD;
input WE;
input [31:0] WPC;
input clk;
input reset;
output [31:0] R1;
output [31:0] R2;

	reg [31:0] Reg[0:31];
	reg [31:0] WData;
	reg [5:0] Waddr;
	
	integer i;
	initial begin	
		for(i = 0;i<32;i = i + 1)begin
			Reg[i] = 32'b0;
		end
	end
	assign R1 = Reg[A1];
	assign R2 = Reg[A2];
	wire [31:0] OPC;
	assign OPC = WPC + 32'h0000_3000;
	
	always@(posedge clk)begin
		if(reset)begin
			for(i = 0;i < 32;i = i + 1)begin
				Reg[i] = 32'b0;
			end
		end	
		else if(A3 == 5'b00000)begin
			
		end
		else if(WE)begin
			WData = 32'b00000;
			if(A3 != 5'b00000)begin
			WData = WD;
			end
			
			Waddr = A3;
			Reg[A3] = WData;
			$display("%d@%h: $%d <= %h", $time,OPC, Waddr, WData);
		end
	end

endmodule
