`timescale 1ns / 1ps
//////
module mips(
    input clk,
    input reset,
	 output [31:0] out_pc,
	 output [31:0] out_instr,
	 output [31:0] out_grfw,
	 output [4:0] out_grfa,
	 output [31:0] out_dm,
	 output [31:0] out_alu,
	 output [31:0] out_ext,
	 output [31:0] out_rd1,
	 output [31:0] out_rd2,
	 output [2:0] out_aluop,
	 output [2:0] out_npcop,
	 output [2:0] out_extop,
	 output [2:0] out_rwsel,
	 output [31:0] out_aluin,
	 output [2:0] out_absel
);

//Control
	wire [2:0] ALUop,NPCop,EXTop;
	wire GRFWE,DMWN;
	wire [2:0] RAsel,RWsel,ABsel;
//IFU
	wire [31:0] pc,instr;
	wire [25:0] imm26;
	wire [5:0] special,offest;
	assign special = instr[31:26];
	assign offest = instr[5:0];
	wire [4:0] rs,rt,rd;	
//NPC
	wire[31:0] npc,pc4;
//EXT 
	wire [31:0] EXTout,ALUout,DMout;
//GRF
	wire [4:0]GRFaddr;
	wire [31:0] GRFdata;
	wire [31:0] GRFrd1,GRFrd2; 
	assign GRFaddr = (RAsel == 3'b000) ? rd:
							(RAsel == 3'b001) ? rt:
							(RAsel == 3'b010) ? 5'b11111:
							5'b00000;
	assign GRFdata = (RWsel == 3'b000) ? ALUout:
							(RWsel == 3'b001) ? EXTout:
							(RWsel == 3'b010) ? DMout:
							(RWsel == 3'b011) ? pc4 + 32'h0000_3000:
							32'b0;
//ALU
	wire [31:0] ALUin;
	wire zero;
	assign ALUin = (ABsel == 3'b000) ? GRFrd2:
						(ABsel == 3'b001) ? EXTout:
						32'b0;
//print
assign out_pc = pc;
assign out_instr = instr;
assign out_grfw = GRFdata;
assign out_grfa = GRFaddr;
assign out_dm = DMout;
assign out_alu = ALUout;
assign out_ext = EXTout;
assign out_aluop = ALUop;
assign out_rd1 = GRFrd1;
assign out_rd2 = GRFrd2;
assign out_rwsel = RWsel;
assign out_aluin = ALUin;
assign out_absel = ABsel;
	Control _control(//special,offest,ALUop,EXTop,NPCop,GRFWE,DMWN,RAsel,RWsel,ABsel
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
		
    IFU _ifu(//NPC,clk,reset,PC,instr,imm,offest,rs,rt,rd
		  .NPC(npc),
        .reset(reset),
        .clk(clk),
		  
		  .PC(pc),
        .instr(instr),
		  .imm(imm26),
		  .rs(rs),
		  .rt(rt),
		  .rd(rd)
    );
	 
	 NPC _npc(//PC,imm,PC31,nextPC,NPC,zero,op
        .PC(pc),
        .imm(imm26),
        .PC31(GRFrd1),
        .op(NPCop),
		  .zero(zero),
		  
        .nextPC(pc4),
        .NPC(npc)
    );
	 
	 
	 EXT _extend(//imm,EOp,ext
			.imm(imm26[15:0]),
			.EOp(EXTop),
			
			.ext(EXTout)
	 );
	 
	 GRF _grf(//A1,A2,A3,WD,WE,WPC,clk,reset,R1,R2
			.A1(rs),
			.A2(rt),
			.A3(GRFaddr),
			.WD(GRFdata),
			.WE(GRFWE),
			.WPC(pc),
			.clk(clk),
			.reset(reset),
			
			.R1(GRFrd1),
			.R2(GRFrd2)
	 );
	 
	 
	 ALU _alu(//A,B,ALUOp,C,eq
			.A(GRFrd1),
			.B(ALUin),
			.ALUOp(ALUop),
			
			.C(ALUout),
			.eq(zero)
	 );
	 
	 
	 DM _dm(//ADDR,WD,RD,PC,clk,reset,DMen
			.ADDR(ALUout),
			.WD(GRFrd2),
			.clk(clk),
			.reset(reset),
			.DMen(DMWN),
			.PC(pc),
			
			.RD(DMout)
	);
	 
endmodule
