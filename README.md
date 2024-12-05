# buaa-co-2023
这是本人2023年CO个人代码。
实现了支持以下MIPS指令的五级流水线CPU
```
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
```
## 声明
请勿抄袭，本代码仅供参考
本人做到了p6及其课上。
