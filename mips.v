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
	wire [3:0] E_ALUop,D_NPCop,D_EXTop;
	wire W_GRFWE,M_DMWN;
	wire [2:0] E_RWsel,M_RWsel,W_RWsel;
	wire[2:0] E_ABsel;
//IFU
	wire [31:0] F_pc,D_pc,E_pc,M_pc,W_pc,F_instr,D_instr,E_instr,M_instr,W_instr;
	wire [25:0] F_imm26,D_imm26;
	wire [4:0] F_rs,D_rs,E_rs,M_rs,W_rs,F_rt,D_rt,E_rt,W_rt,F_rd,D_rd,E_rd,M_rd,W_rd;	
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
//DM
   wire [31:0] M_DMin,M_DMaddr;
	wire [3:0] M_byte_en;
	wire [2:0] M_wop,M_dop;
//
	wire [3:0] E_mduop;
	wire E_start,E_busy;
	wire [31:0] E_MDUout,M_mdu,W_mdu;
	wire f5;
/*************************************this is putoff**********************************************/
	 STOP stop_control(
			.D_instr(D_instr),
			.E_instr(E_instr),
			.M_instr(M_instr),
			
			.D_bpj(D_bpj),
			.E_bpj(E_bpj),
			.M_bpj(M_bpj),
			
			.E_start(E_start),
			.E_busy(E_busy),
			
			.f5(f5),
			.putoff(putoff)
	 );

/********************************************F******************************************************/
	 IFU F_ifu(
		  .NPC(NPC),
        .reset(reset),
        .clk(clk),
		  .IFUgo(!putoff),//
		  
		  .PC(F_pc)
        //.instr(F_instr)
    );
	 
	 assign F_instr = i_inst_rdata;
	 FD_REG FD_reg(
			.clk(clk),
			.reset(reset),
			.refresh(0),
			.en(!putoff),
			
			.F_pc(F_pc),
			.F_instr(F_instr),
			
			.D_instr(D_instr),
			.D_pc(D_pc)
	 );
	 
/****************************************************D***************************************************/
	Control D_control(
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
	
	NPC D_Npc(
        .PC(D_pc),
		  .F_PC(F_pc),
        .imm(D_imm26),
        .PC31(D_rd1),//????
        .op(D_NPCop),
		  .zero(D_jump),//
		  .bpj(D_bpj),

        .NPC(NPC)
    );
	
	 EXT D_extend(
			.imm(D_imm26[15:0]),
			.EOp(D_EXTop),
			
			.ext(D_EXTout)
	 );

	 GRF DW_grf(
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
						
	 DE_REG DE_reg(
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
	
/***************************************************E************************************************/
	Control E_control(
		.instr(E_instr),
		.bpj(E_bpj),
		
		.ALUop(E_ALUop),
		.ABsel(E_ABsel),
		.RWsel(E_RWsel),
		.GRFaddr(E_GRFaddr),
		
		.start(E_start),
		.Emdop(E_mduop),
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
							(E_RWsel == 3'b100) ? E_MDUout:
							32'b0;
	//wire [3:0] E_mduop;
//	wire E_start,E_busy;
	//wire [31:0] E_MDUout;
	
	E_MDU E_mdu(
		.clk(clk),
		.reset(reset),
		.D1(E_rd1),
		.D2(E_rd2),
		.op(E_mduop),
		
		.busy(E_busy),
		.MDUout(E_MDUout)
	);
	
	ALU E_alu(
			.A(E_rd1),
			.B(E_ALUin),
			.ALUop(E_ALUop),
			
			.C(E_ALUout)
	 );
	 
	 
	 
	 EM_REG EM_reg(
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
			.E_mdu(E_MDUout),
			
			.M_pc(M_pc),
			.M_instr(M_instr),
			.M_ALUout(M_alu),
			.M_rt_rd(M_GRFrd2),
			.M_ext(M_ext),
			.M_jump(M_bpj),
			.M_mdu(M_mdu)
	 );
	 
/************************************************M****************************************************/ 
	 Control M_control(
			.instr(M_instr),
			.bpj(M_bpj),
			
			.RWsel(M_RWsel),
			.GRFaddr(M_GRFaddr),
			.Mwop(M_wop),
			.Mdop(M_dop)
	);
	
	assign M_DMaddr = M_alu;
	
	 WM M_W(
			.ADDR(M_alu),
			.WD(M_GRFrd2),//pre_DMin
			.op(M_wop),
			
			.Wdata(M_DMin),//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			.byte_en(M_byte_en)
	);
	
	Ddm M_D(
			.A(M_alu[1:0]),
			.Din(m_data_rdata),//pre_DMout
			.op(M_dop),
			
			.Dout(M_DMout)
	);
	
	assign M_GRFdata = (M_RWsel == 3'b000) ? M_alu:
							(M_RWsel == 3'b001) ? M_ext:
							(M_RWsel == 3'b010) ? M_DMout:
							(M_RWsel == 3'b011) ? M_pc + 32'h0000_3000 + 8:
							(M_RWsel == 3'b100) ? M_mdu:
							32'b0;
	
	MW_REG MW_reg(
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
			.M_mdu(M_mdu),
			
			.W_pc(W_pc),
			.W_instr(W_instr),
			.W_alu(W_alu),
			.W_DMout(W_DMout),
			.W_ext(W_ext),
			.W_jump(W_bpj),
			.W_mdu(W_mdu)
	);
	
/************************************************W**************************************************/ 
	Control W_control(
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
							(W_RWsel == 3'b100) ? W_mdu:
							32'b0;


//? ??????????????????????????????????????????????????????????????????????
assign i_inst_addr = F_pc + 32'h3000;
assign m_data_addr = M_DMaddr;
assign m_data_wdata = M_DMin;
assign m_data_byteen = M_byte_en;
assign m_inst_addr = M_pc+ 32'h3000;
assign w_grf_we = W_GRFWE;
assign w_grf_addr = W_GRFaddr;
assign w_grf_wdata = W_GRFdata;
assign w_inst_addr = W_pc+ 32'h3000;

endmodule

