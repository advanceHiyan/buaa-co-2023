`timescale 1ns / 1ps
///
module Control(bpj,instr,ALUop,EXTop,NPCop,GRFWE,DMWN,RWsel,ABsel,rs,rt,rd,imm26,GRFaddr);
input [31:0] instr;
input bpj;
	wire [5:0] special;
	wire [5:0] offest;
	assign special = instr[31:26];
	assign offest = instr[5:0]; 
output [4:0] rs,rt,rd;
	assign rs = instr[25:21];
	assign rt = instr[20:16];
	assign rd = instr[15:11];
output [25:0] imm26;
	assign imm26 = instr[25:0];
output reg [2:0] ALUop;
output reg [2:0] EXTop;
output reg [2:0] NPCop;

output reg GRFWE;
output reg DMWN;

output reg [2:0] RWsel,ABsel;
output [4:0] GRFaddr;
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
		if( beq===1'b1)begin
			 NPCop = 3'b001;
		end
		else if(jal === 1'b1)begin
			 NPCop = 3'b010;
		end
		else if(jr === 1'b1)begin
			 NPCop = 3'b011;
		end
		else  NPCop = 3'b000;
		

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
		
		 GRFWE = !(sw | beq | jr |(instr == 32'b0));//!!!!!!!
		
		//DM
		 DMWN = (sw | 0);
		
	end
	assign GRFaddr = (add | sub) ? rd:
								(lw | lui | ori) ? rt:
								(jal) ? 5'b11111:
								5'b00000;

endmodule
