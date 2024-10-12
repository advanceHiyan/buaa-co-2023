`timescale 1ns / 1ps
//////////////////////////////
module STOP(D_instr,E_instr,M_instr,D_bpj,E_bpj,M_bpj,putoff,E_start,E_busy,f5);
input [31:0] D_instr,E_instr,M_instr;
input D_bpj,E_bpj,M_bpj,E_start,E_busy;
output putoff;
output f5;
wire [4:0] D_rs,D_rt,E_add,M_add;
wire [2:0] Drs_use,Drt_use,Enew,Mnew;
wire D_start,D_mt,D_mf;

	Control D_irconl(//instr,load,store,type_add,type_addi,j_beq,j_jr,j_jump,j_jal
			.instr(D_instr),
			.bpj(D_bpj),
			
			.rs(D_rs),
			.rt(D_rt),
			
			.start(D_start),
			.mt(D_mt),
			.mf(D_mf),
			
			.Drs_use(Drs_use),
			.Drt_use(Drt_use)
	);
	


	
	Control E_irconl(//instr,load,store,type_add,type_addi,j_beq,j_jr,j_jump,j_jal
			.instr(E_instr),
			.bpj(E_bpj),
			
			.GRFaddr(E_add),
			.Enew(Enew)
	);

	
	Control M_irconl(//instr,load,store,type_add,type_addi,j_beq,j_jr,j_jump,j_jal
			.instr(M_instr),
			.bpj(M_bpj),
			
			.GRFaddr(M_add),
			.Mnew(Mnew)
	);
	wire f1,f2,f3,f4;
	assign f1 = (E_add === D_rs && D_rs!=0 && E_add!=0 && Enew > Drs_use);
	assign f2 = (E_add === D_rt && D_rt!=0 && E_add!=0 && Enew > Drt_use);
	assign f3 = (M_add === D_rs && D_rs!=0 && M_add!=0 && Mnew > Drs_use);
	assign f4 = (M_add === D_rt && D_rt!=0 && M_add!=0 && Mnew > Drt_use);
	assign f5 = ((D_start | D_mf | D_mt) && (E_start | E_busy) );
assign putoff = (f1 | f2 | f3 | f4 | f5 |0);
	
endmodule
