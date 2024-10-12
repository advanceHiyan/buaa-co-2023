`timescale 1ns / 1ps
///
module Control(special,offest,ALUop,EXTop,NPCop,GRFWE,DMWN,RAsel,RWsel,ABsel);
input [5:0] special;
input [5:0] offest;

output reg [2:0] ALUop;
output reg [2:0] EXTop;
output reg [2:0] NPCop;

output reg GRFWE;
output reg DMWN;

output reg [2:0] RAsel,RWsel,ABsel;

	wire add = (special == 6'b000000 && offest == 6'b100000) ? 1 : 0;
	wire sub = (special == 6'b000000 && offest == 6'b100010) ? 1 : 0;
	wire ori = (special == 6'b001101) ? 1:0;
	wire lw = (special == 6'b100011) ? 1:0;
	wire sw = (special == 6'b101011) ? 1:0;
	wire beq = (special == 6'b000100) ? 1:0;
	wire lui = (special == 6'b001111) ? 1:0;
	wire jal = (special == 6'b000011) ? 1:0;
	wire jr = (special == 6'b000000 && offest == 6'b001000) ? 1 : 0;
	
	//ALU
	always @(*)begin
		if(add | sub | beq )begin
			 ABsel = 3'b000;//rd2
		end
		else if(sw | lw | lui | ori)begin
			 ABsel = 3'b001;//ext
		end
		else  ABsel = 3'b000;
		
		if((add | lw | sw))begin
			 ALUop = 3'b000;//+
		end
		else if(sub | beq)begin
			 ALUop = 3'b001;//-
		end
		else if(ori)begin
			 ALUop = 3'b011;// |
		end
		else  ALUop = 3'b000;
		
		//EXT
		if((lw | sw))begin
			 EXTop = 3'b000;//sign
		end
		else if(0 | ori)begin
			 EXTop = 3'b001;//zero
		end
		else if(lui)begin
			 EXTop = 3'b010;//lui
		end
		else  EXTop = 3'b000;
		
		//NPC
		if( beq)begin
			 NPCop = 3'b001;
		end
		else if(jal)begin
			 NPCop = 3'b010;
		end
		else if(jr)begin
			 NPCop = 3'b011;
		end
		else  NPCop = 3'b000;
		
		//GRF
		if(add | sub )begin
			 RAsel = 3'b000;//rd
		end
		else if(lw | lui | ori )begin
			 RAsel = 3'b001;//rt
		end
		else if(jal)begin
			 RAsel = 3'b010;//31 
		end
		else begin
			 RAsel = 3'b000;
		end

		if(add | sub | ori)begin
			 RWsel = 3'b000;//alu
		end
		else if(lui)begin
			 RWsel = 3'b001;//EXT
		end
		else if(lw)begin
			 RWsel = 3'b010;//dm
		end
		else if(jal)begin
			 RWsel = 3'b011;//pc4
		end
		else  RWsel = 3'b000;
		
		 GRFWE = !(sw | beq | jr );//!!!!!!!
		
		//DM
		 DMWN = (sw | 0);
		
	end
endmodule
