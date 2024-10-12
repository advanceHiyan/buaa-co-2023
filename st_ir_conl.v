`timescale 1ns / 1ps
///////////////////
module st_ir_conl(bpj,instr,rs,rt,GRFaddr,Drs_use,Drt_use,Euse,Muse);
input [31:0] instr;
output [4:0] rs,rt;
wire [4:0] rd;
output [4:0] GRFaddr;
output [2:0] Drs_use,Drt_use,Euse,Muse;
wire [5:0] special ,offest;
assign special = instr[31:26];
assign offest = instr[5:0]; 
input bpj;

assign rs = instr[25:21];
assign rt = instr[20:16];
assign rd = instr[15:11];
/***********************************这是在译码***************************************************/
	wire add = (special == 6'b000000 && offest == 6'b100000) ? 1 : 0;
	wire sub = (special == 6'b000000 && offest == 6'b100010) ? 1 : 0;
	wire ori = (special == 6'b001101) ? 1:0;
	wire lw = (special == 6'b100011) ? 1:0;
	wire sw = (special == 6'b101011) ? 1:0;
	wire beq = (special == 6'b000100) ? 1:0;
	wire lui = (special == 6'b001111) ? 1:0;
	wire jal = (special == 6'b000011) ? 1:0;
	wire jr = (special == 6'b000000 && offest == 6'b001000) ? 1 : 0;
	/********************************计算延迟时间*************************************************/
	assign GRFaddr = (add | sub) ? rd:
								(lw | lui | ori) ? rt:
								(jal) ? 5'b11111:
								5'b00000;


   assign Drs_use = (beq | jr) ? 3'b000:
							(lw | sw | add | sub | ori | lui) ? 3'b001 :
							3'b111;
							
	assign Drt_use = (beq) ? 3'b000:
							(add | sub) ? 3'b001:
							(sw) ? 3'b010:
							3'b111;


	assign Euse = (add | ori | sub | lui) ? 3'b001:
						(lw) ? 3'b010:
						3'b000;


	assign Muse = (lw) ? 1:0;

	assign load   = lw; // lh | lhu | lbu | lb;
    assign store  = sw; // sh | sb;  
    //assign branch_link = bltzal;                 // c-conditional 有条件链接
    //assign branch_uc_link = 0;                 // uc-unconditional 无条件链接
    assign type_add = add | sub;     // | slt | sll | sllv;
    assign type_addi = ori | lui;
    //assign md = mult | multu | div | divu;
    //assign mt = mtlo | mthi;
    //assign mf = mflo | mfhi;
    //assign shift_s  = sll;
    //assign shift_v = sllv;
	 assign j_beq = beq;// bltzal; | bne | blez | bgtz | bgez | bltz;
    assign j_jr = jr; //| jalr;
    assign j_jump = jal; //j_addr,j
    assign j_jal = jal; //| jalr;
	 		
		
			

endmodule
