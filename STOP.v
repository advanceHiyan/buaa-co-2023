`timescale 1ns / 1ps
//////////////////////////////
module STOP(D_instr,E_instr,M_instr,D_bpj,E_bpj,M_bpj,putoff);
input [31:0] D_instr,E_instr,M_instr;
input D_bpj,E_bpj,M_bpj;
output putoff;
wire [4:0] D_rs,D_rt,E_add,M_add;
wire [2:0] Drs_use,Drt_use,Euse,Muse;

	st_ir_conl D_irconl(//instr,load,store,type_add,type_addi,j_beq,j_jr,j_jump,j_jal
			.instr(D_instr),
			.bpj(D_bpj),
			
			.rs(D_rs),
			.rt(D_rt),
			
			.Drs_use(Drs_use),
			.Drt_use(Drt_use)
	);
	


	
	st_ir_conl E_irconl(//instr,load,store,type_add,type_addi,j_beq,j_jr,j_jump,j_jal
			.instr(E_instr),
			.bpj(E_bpj),
			
			.GRFaddr(E_add),
			.Euse(Euse)
	);

	
	st_ir_conl M_irconl(//instr,load,store,type_add,type_addi,j_beq,j_jr,j_jump,j_jal
			.instr(M_instr),
			.bpj(M_bpj),
			
			.GRFaddr(M_add),
			.Muse(Muse)
	);
	wire f1,f2,f3,f4;
	assign f1 = (E_add === D_rs && D_rs!=0 && E_add!=0 && Euse > Drs_use);
	assign f2 = (E_add === D_rt && D_rt!=0 && E_add!=0 && Euse > Drt_use);
	assign f3 = (M_add === D_rs && D_rs!=0 && M_add!=0 && Muse > Drs_use);
	assign f4 = (M_add === D_rt && D_rt!=0 && M_add!=0 && Muse > Drt_use);
assign putoff = (f1 | f2 | f3 | f4 | 0);
	
endmodule
