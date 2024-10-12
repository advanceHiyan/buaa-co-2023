`timescale 1ns / 1ps
///
`define E_mult    4'b0000
`define E_multu   4'b0001
`define E_div     4'b0010
`define E_divu    4'b0011
`define E_mfhi    4'b0100
`define E_mflo    4'b0101
`define E_mthi    4'b0110
`define E_mtlo    4'b0111

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Control(bpj,instr,ALUop,EXTop,start,mf,mt,Mwop,Mdop,NPCop,Emdop,GRFWE,DMWN,RWsel,ABsel,rs,rt,rd,imm26,GRFaddr,Drs_use,Drt_use,Enew,Mnew);
input [31:0] instr;
input bpj;
	wire [5:0] special,offest;
	assign special = instr[31:26];
	assign offest = instr[5:0]; 
	
output [4:0] rs,rt,rd;
	assign rs = instr[25:21];
	assign rt = instr[20:16];
	assign rd = instr[15:11];
output [25:0] imm26;
	assign imm26 = instr[25:0];
	
output reg [3:0] ALUop,EXTop,NPCop;
output reg GRFWE,DMWN;
output reg [2:0] RWsel,ABsel;

output [2:0] Drs_use,Drt_use,Enew,Mnew,Mwop,Mdop;
output [4:0] GRFaddr;
output [3:0] Emdop;
output start,mt,mf;
/****************************************Decoder******************************************************/
	wire add = (special == 6'b000000 && offest == 6'b100000) ? 1 : 0;
	wire sub = (special == 6'b000000 && offest == 6'b100010) ? 1 : 0;
	wire AND = (special == 6'b000000 && offest == 6'b100100) ? 1 : 0;
	wire slt = (special == 6'b000000 && offest == 6'b101010) ? 1 : 0;
	wire sltu = (special == 6'b000000 && offest == 6'b101011) ? 1 : 0;
	wire OR = (special == 6'b000000 && offest == 6'b100101) ? 1 : 0;
	
	wire mult = (special == 6'b000000 && offest == 6'b011000) ? 1 : 0;
	wire multu = (special == 6'b000000 && offest == 6'b011001) ? 1 : 0;
	wire div = (special == 6'b000000 && offest == 6'b011010) ? 1 : 0;
	wire divu = (special == 6'b000000 && offest == 6'b011011) ? 1 : 0;
	wire mfhi = (special == 6'b000000 && offest == 6'b010000) ? 1 : 0;
	wire mflo = (special == 6'b000000 && offest == 6'b010010) ? 1 : 0;
	wire mthi = (special == 6'b000000 && offest == 6'b010001) ? 1 : 0;
	wire mtlo = (special == 6'b000000 && offest == 6'b010011) ? 1 : 0;
	
	wire ori = (special == 6'b001101) ? 1:0;
	wire lui = (special == 6'b001111) ? 1:0;
	wire addi = (special == 6'b001000) ? 1:0;
	wire andi = (special == 6'b001100) ? 1:0;
	
	
	wire lw = (special == 6'b100011) ? 1:0;
	wire lb = (special == 6'b100000) ? 1:0;
	wire lh = (special == 6'b100001) ? 1:0;
	wire sw = (special == 6'b101011) ? 1:0;
	wire sb = (special == 6'b101000) ? 1:0;
	wire sh = (special == 6'b101001) ? 1:0;
	
	wire beq = (special == 6'b000100) ? 1:0;
	wire bne = (special == 6'b000101) ? 1:0;
	wire jal = (special == 6'b000011) ? 1:0;
	wire jr = (special == 6'b000000 && offest == 6'b001000) ? 1 : 0;
/*****************************************************************************************************/
assign start = (mult | multu | div | divu);
assign mt = (mthi | mtlo);
assign mf = (mfhi | mflo);
wire type_add = (add | sub | OR | AND | slt | sltu);
wire type_addi = ( ori | addi | andi);
wire type_l = (lw | lb | lh);
wire type_s = (sw | sb | sh);
/*****************************************always@()!!!!!**********************************************/
	//ALUin
	always @(*)begin
		if( beq | bne | type_add )begin
			 ABsel = 3'b000;//rd2
		end
		else if(type_l | type_s | lui | type_addi)begin
			 ABsel = 3'b001;//ext
		end
		else  ABsel = 3'b000;
	//ALUop
		if((type_l | type_s | addi))begin
			 ALUop = 4'b0000;//+
		end
		else if(sub | beq)begin
			 ALUop = 4'b0001;//-
		end
		else if(AND| andi )begin
			ALUop = 4'b0010;//&
		end
		else if(ori | OR)begin
			 ALUop = 4'b0011;// |
		end
		else if(slt)begin
			ALUop = 4'b0100;
		end
		else if(sltu)begin
			ALUop = 4'b0101;
		end
		else  ALUop = 4'b0000;
		
		//EXTop
		if((type_l | type_s | addi))begin
			 EXTop = 4'b0000;//sign
		end
		else if(0 | ori | andi )begin
			 EXTop = 4'b0001;//zero
		end
		else if(lui)begin
			 EXTop = 4'b0010;//lui
		end
		else  EXTop = 4'b0000;
		
		//NPCop
		if( beq===1'b1)begin
			 NPCop = 4'b0001;
		end
		else if(jal === 1'b1)begin
			 NPCop = 4'b0010;
		end
		else if(jr === 1'b1)begin
			 NPCop = 4'b0011;
		end
		else if(bne === 1'b1)begin
			NPCop = 4'b0100;
		end
		else  NPCop = 4'b0000;
		
		//GRFdata_sel
		if(type_add | type_addi)begin
			 RWsel = 3'b000;//alu
		end
		else if(lui)begin
			 RWsel = 3'b001;//EXT
		end
		else if(type_l )begin
			 RWsel = 3'b010;//dm
		end
		else if(jal)begin
			 RWsel = 3'b011;//pc4
		end
		else if(mf)begin
			RWsel = 3'b100;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		end
		else  RWsel = 3'b000;
		//GRFWE
		 GRFWE = !(type_s | mt |start | beq | bne | jr |(instr == 32'b0));//!!!!!!!
		
		//DMen
		 DMWN = ( type_s | 0);
		
	end
/******************************************assign()sl*******************************************************/
assign Mwop = (sw) ? 3'b000:
					(sh) ? 3'b001:
					(sb) ? 3'b010:
					3'b111;
					
assign Mdop = (lw) ? 3'b000:
					(lh) ? 3'b001:
					(lb) ? 3'b010:
					3'b111;
assign Emdop = (mult) ? `E_mult:
					(multu) ? `E_multu:
					(div) ? `E_div:
					(divu) ? `E_divu:
					(mfhi) ? `E_mfhi:
					(mflo) ? `E_mflo:
					(mthi) ? `E_mthi:
					(mtlo) ? `E_mtlo:
					4'b1111;
/******************************************assign()stall*****************************************************/
	
	
	//GRFaddr
	assign GRFaddr = (type_add | mf) ? rd:
								(type_l | lui | type_addi ) ? rt:
								(jal) ? 5'b11111:
								5'b00000;
	
   assign Drs_use = (beq  | bne | jr) ? 3'b000:
							(type_l | type_s| type_add | type_addi | lui | mt | start) ? 3'b001 :
							3'b111;
							
	assign Drt_use = (beq | bne ) ? 3'b000:
							(type_add | start) ? 3'b001:
							(type_s ) ? 3'b010:
							3'b111;


	assign Enew = (type_add | type_addi | lui | mf) ? 3'b001:
						(type_l) ? 3'b010:
						3'b000;


	assign Mnew = (type_l) ? 1:0;

endmodule
