`timescale 1ns / 1ps
//////
module mips(
    input clk,
    input reset,
	input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3 :0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
);

//Control
	wire [2:0] E_ALUop,D_NPCop,D_EXTop;
	wire W_GRFWE,M_DMWN;
	wire [2:0] E_RWsel,M_RWsel,W_RWsel;
	wire[2:0] E_ABsel;
//IFU
	wire [31:0] F_pc,D_pc,E_pc,M_pc,W_pc,F_instr,D_instr,E_instr,M_instr,W_instr;
	wire [25:0] F_imm26,D_imm26;
	wire [4:0] F_rs,D_rs,E_rs,M_rs,W_rs,F_rt,D_rt,E_rt,M_rt,W_rt,F_rd,D_rd,E_rd,M_rd,W_rd;	
//NPC
	wire[31:0] NPC;
//EXT 
	wire [31:0] E_ALUout,M_alu,W_alu;
	wire [31:0] D_EXTout,E_ext,M_ext,W_ext;
	wire [31:0] M_DMout, W_DMout;
//GRF
	wire [4:0] E_GRFaddr,M_GRFaddr,W_GRFaddr;
	wire [31:0] E_GRFdata,M_GRFdata,W_GRFdata;
	wire [31:0] D_GRFrd1,D_GRFrd2,D_rd1,D_rd2,E_GRFrd1,E_GRFrd2,E_rd1,E_rd2,M_GRFrd2; 

	wire [31:0] E_ALUin;

	wire putoff;
	wire D_bpj,E_bpj,M_bpj,W_bpj;
/*************************************�����ӳٿ��Ʋ�**********************************************/
	 STOP stop_control(
			.D_instr(D_instr),
			.E_instr(E_instr),
			.M_instr(M_instr),
			
			.D_bpj(D_bpj),
			.E_bpj(E_bpj),
			.M_bpj(M_bpj),
			
			.putoff(putoff)
	 );

/****************************************����F��*************************************************/
	 IFU F_ifu(//NPC,clk,reset,PC,instr,imm,rs,rt,rd
		  .NPC(NPC),
        .reset(reset),
        .clk(clk),
		  .IFUgo(!putoff),//
		  
		  .PC(F_pc),
        .instr(F_instr)
    );
	 
	 
	 FD_REG FD_reg(//clk,reset,refresh,en,F_pc,F_instr,D_instr,D_pc
			.clk(clk),
			.reset(reset),
			.refresh(0),
			.en(!putoff),
			
			.F_pc(F_pc),
			.F_instr(F_instr),
			
			.D_instr(D_instr),
			.D_pc(D_pc)
	 );
	 
/*******************************************����D��**********************************************/
	Control D_control(//instr,ALUop,EXTop,NPCop,GRFWE,DMWN,RAsel,RWsel,ABsel,rs,rt,rt
		.instr(D_instr),
		.bpj(D_bpj),

		.EXTop(D_EXTop),
		.NPCop(D_NPCop),
		
		.rs(D_rs),
		.rt(D_rt),
		.imm26(D_imm26)
	);
	
	CMP D_cmp(
		.GR1(D_rd1),
		.GR2(D_rd2),
		.op(),
		
		.jump(D_jump),
		.bpj(D_bpj)
	);
	
	NPC D_Npc(//PC,imm,PC31,nextPC,NPC,zero,op
        .PC(D_pc),
		  .F_PC(F_pc),
        .imm(D_imm26),
        .PC31(D_rd1),//????
        .op(D_NPCop),
		  .zero(D_jump),//
		  .bpj(D_bpj),

        .NPC(NPC)
    );
	
	 EXT D_extend(//imm,EOp,ext
			.imm(D_imm26[15:0]),
			.EOp(D_EXTop),
			
			.ext(D_EXTout)
	 );

	 GRF DW_grf(//A1,A2,A3,WD,WE,WPC,clk,reset,R1,R2
			.A1(D_rs),
			.A2(D_rt),
			.A3(W_GRFaddr),
			.WD(W_GRFdata),
			.WE(W_GRFWE),
			.WPC(W_pc),
			.clk(clk),
			.reset(reset),
			
			.R1(D_GRFrd1),
			.R2(D_GRFrd2)
	 );
	assign D_rd1 = (D_rs === E_GRFaddr && D_rs != 0) ? E_GRFdata:
						(D_rs === M_GRFaddr && D_rs != 0) ? M_GRFdata:
						(D_rs === W_GRFaddr && D_rs != 0) ? W_GRFdata:
						D_GRFrd1;
	assign D_rd2 = (D_rt === E_GRFaddr && D_rt != 0) ? E_GRFdata:
						(D_rt === M_GRFaddr && D_rt != 0) ? M_GRFdata:
						(D_rt === W_GRFaddr && D_rt != 0) ? W_GRFdata:
						D_GRFrd2;	 
						
	 DE_REG DE_reg(//clk,reset,refresh,en,D_instr,D_pc,D_ext,D_rd1,D_rd2,D_jump,E_instr,E_pc,E_ext,E_rd1,E_rd2,E_jump
			.clk(clk),
			.reset(reset),
			.refresh(putoff),
			.en(1),
			
			.D_instr(D_instr),
			.D_pc(D_pc),
			.D_ext(D_EXTout),
			.D_rd1(D_rd1),
			.D_rd2(D_rd2),
			.D_jump(D_bpj),
			
			.E_instr(E_instr),
			.E_pc(E_pc),
			.E_ext(E_ext),
			.E_rd1(E_GRFrd1),
			.E_rd2(E_GRFrd2),
			.E_jump(E_bpj)
	 );
	
/*******************************************����E��**********************************************/
	Control E_control(//instr,ALUop,EXTop,NPCop,GRFWE,DMWN,RAsel,RWsel,ABsel,rs,rt,rt
		.instr(E_instr),
		.bpj(E_bpj),
		
		.ALUop(E_ALUop),
		.ABsel(E_ABsel),
		.RWsel(E_RWsel),
		.GRFaddr(E_GRFaddr),
		
		.rs(E_rs),
		.rt(E_rt),
		.rd(E_rd)
	);
	assign E_rd1 = (E_rs === M_GRFaddr && E_rs != 0) ? M_GRFdata:
						(E_rs === W_GRFaddr && E_rs != 0) ? W_GRFdata:
						E_GRFrd1;
	assign E_rd2 = (E_rt === M_GRFaddr && E_rt != 0) ? M_GRFdata:
						(E_rt === W_GRFaddr && E_rt != 0) ? W_GRFdata:
						E_GRFrd2;
	
	assign E_ALUin = (E_ABsel == 3'b000) ? E_rd2:
						(E_ABsel == 3'b001) ? E_ext:
						32'b0;
	assign E_GRFdata = (E_RWsel == 3'b000) ? E_ALUout:
							(E_RWsel == 3'b001) ? E_ext:
							//(E_RWsel === 3'b010) ? W_DMout:
							(E_RWsel == 3'b011) ? E_pc + 32'h0000_3000 + 8:
							32'b0;
	
	ALU E_alu(//A,B,ALUOp,C,eq
			.A(E_rd1),//GRFrd1
			.B(E_ALUin),//ALUin
			.ALUOp(E_ALUop),
			
			.C(E_ALUout)
	 );
	 
	 EM_REG EM_reg(//clk,reset,refresh,en,E_pc,E_instr,E_ALUout,E_rt_rd,E_ext,E_jump,
			.clk(clk),
			.reset(reset),
			.refresh(0),
			.en(1),
			
			.E_pc(E_pc),
			.E_instr(E_instr),
			.E_ALUout(E_ALUout),
			.E_rt_rd(E_rd2),
			.E_ext(E_ext),
			.E_jump(E_bpj),
			
			.M_pc(M_pc),
			.M_instr(M_instr),
			.M_ALUout(M_alu),
			.M_rt_rd(M_GRFrd2),
			.M_ext(M_ext),
			.M_jump(M_bpj)
	 );
	 
/*******************************************����M��**********************************************/ 
	 Control M_control(//instr,ALUop,EXTop,NPCop,GRFWE,DMWN,RAsel,RWsel,ABsel,rs,rt,rt
			.instr(M_instr),
			.bpj(M_bpj),
			
			.RWsel(M_RWsel),
			.GRFaddr(M_GRFaddr),
			.DMWN(M_DMWN),
			.rt(M_rt)
	);
	
	 DM M_dm(//ADDR,WD,RD,PC,clk,reset,DMen
			.ADDR(M_alu),//ALUout
			.WD(M_GRFrd2),//GRFrd2
			.clk(clk),
			.reset(reset),
			.DMen(M_DMWN),
			.PC(M_pc),
			
			.RD(M_DMout)
	);
	assign M_GRFdata = (M_RWsel == 3'b000) ? M_alu:
							(M_RWsel == 3'b001) ? M_ext:
							(M_RWsel == 3'b010) ? M_DMout:
							(M_RWsel == 3'b011) ? M_pc + 32'h0000_3000 + 8:
							32'b0;
	
	MW_REG MW_reg(//clk,reset,refresh,en,M_jump,M_alu,M_DMen,W_alu,W_DMen,W_jump);
			.clk(clk),
			.reset(reset),
			.refresh(0),
			.en(1),
			
			.M_pc(M_pc),
			.M_instr(M_instr),
			.M_jump(M_bpj),
			.M_alu(M_alu),
			.M_DMout(M_DMout),
			.M_ext(M_ext),
			
			.W_pc(W_pc),
			.W_instr(W_instr),
			.W_alu(W_alu),
			.W_DMout(W_DMout),
			.W_ext(W_ext),
			.W_jump(W_bpj)
	);
	
/*******************************************����W��**********************************************/ 
	Control W_control(//instr,ALUop,EXTop,NPCop,GRFWE,DMWN,RAsel,RWsel,ABsel,rs,rt,rt
			.instr(W_instr),
			.bpj(W_bpj),
			
			.GRFWE(W_GRFWE),
			.GRFaddr(W_GRFaddr),
			.RWsel(W_RWsel),
			
			.rt(W_rt),
			.rd(W_rd)
	);
	assign W_GRFdata = (W_RWsel == 3'b000) ? W_alu:
							(W_RWsel == 3'b001) ? W_ext:
							(W_RWsel == 3'b010) ? W_DMout:
							(W_RWsel == 3'b011) ? W_pc + 32'h0000_3000 + 8:
							32'b0;
endmodule
