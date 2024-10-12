`timescale 1ns / 1ps
////////
module DM(ADDR,WD,RD,PC,clk,reset,DMen);
input [31:0] ADDR;
input [31:0] WD;
input [31:0] PC;
input clk;
input reset;
input DMen;
output [31:0] RD;
	reg [31:0] mem[0:5120];
	integer i = 0;
	
	initial begin
		for(i=0;i < 5120;i = i + 1)begin
			mem[i] = 32'b0;
		end
	end
	
	wire [31:0] WPC; 
	assign WPC = PC + 32'h0000_3000;
	always @(posedge clk)begin
		if(reset)begin
			for(i=0;i < 3072;i = i + 1)begin
				mem[i] = 32'b0;
			end
		end
		else if(DMen)begin
			mem[ADDR[15:2]] = WD;
			$display("@%h: *%h <= %h", WPC, ADDR, WD);
		end
	end
	
	assign RD = mem[ADDR[13:2]];
	
endmodule
	/*case(DMOp)
                `DM_b: begin
                    `byte <= WD[7:0];
                    case(Addr[1:0])
                        2'b00: $display("@%h: *%h <= %h", PC, Addr, {mem[Addr[11:2]][31:8], WD[7:0]});
                        2'b01: $display("@%h: *%h <= %h", PC, Addr, {mem[Addr[11:2]][31:16], WD[7:0], mem[Addr[11:2]][7:0]});
                        2'b10: $display("@%h: *%h <= %h", PC, Addr, {mem[Addr[11:2]][31:24], WD[7:0], mem[Addr[11:2]][15:0]});
                        2'b11: $display("@%h: *%h <= %h", PC, Addr, {WD[7:0], mem[Addr[11:2]][23:0]});
                    endcase
                end
                `DM_h: begin
                    `half_word <= WD[15:0];
                    case(Addr[1])
                        1'b0: $display("@%h: *%h <= %h", PC, Addr, {mem[Addr[11:2]][31:16], WD[15:0]});
                        1'b1: $display("@%h: *%h <= %h", PC, Addr, {WD[15:0], mem[Addr[11:2]][15:0]});
                    endcase
                end
                `DM_w: begin
                    `word <= WD;
                    $display("@%h: *%h <= %h", PC, Addr, WD);
                end
                default: `word <= WD;
            endcase*/
/*	    assign RD = (DMOp == `DM_b) ? {{24{`byte_sign}}, `byte} :
                (DMOp == `DM_bu) ? {{24{1'b0}}, `byte} :
                (DMOp == `DM_h) ? {{16{`half_word_sign}}, `half_word} :
                (DMOp == `DM_hu) ? {{16{1'b0}}, `half_word} :
                (DMOp == `DM_w) ? `word :
                32'h0000_0000;*/