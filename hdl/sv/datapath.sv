module datapath(input  logic        clk, reset,
                input  logic[1:0]   regsrc,
		input  logic        regwrite,
		input  logic[1:0]   immsrc,
		input  logic        alusrc,
		input  logic[1:0]   alucontrol,
		input  logic        memtoreg,
		input  logic        pcsrc,
		output logic[3:0]   aluflags,
		output logic[31:0]  pc,
		input  logic[31:0]  instr,
		output logic[31:0]  aluresult, writedata,
		input  logic[31:0]  readdata);
		
logic[31:0]  pcnext, pcplus4, pcplus8;
logic[31:0]  extimm, srca, srcb, result;
logic[3:0]   ra1, ra2;

mux2 #(32)   pcmux(pcplus4, result, pcsrc, pcnext);
flopr#(32)   pcreg(clk, reset, pcnext, pc);
adder#(32)  pcadd1(pc, 32'b100, pcplus4);
adder#(32)  pcadd2(pcplus4, 32'b100, pcplus8);
mux2 #(4)   ra1mux(instr[19:16], 4'b1111, regsrc[0], ra1);
mux2 #(4)   ra2mux(instr[3:0], instr[15:12], regsrc[1], ra2);
registerfile    rf(clk, regwrite, ra1, ra2, instr[15:12], result, pcplus8, srca, writedata);
mux2 #(32)  resmux(aluresult, readdata, memtoreg, result);
extender       ext(instr[23:0], immsrc, extimm);
mux2 #(32) srcbmux(writedata, extimm, alusrc, srcb);
alu            alu(srca, srcb, alucontrol, aluresult, aluflags);

endmodule
