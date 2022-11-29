module controller(input  logic        clk, reset,
                  input  logic[31:12] instr,
		  input  logic[3:0]   aluflags,
		  output logic[1:0]   regsrc,
		  output logic        regwrite,
		  output logic[1:0]   immsrc,
		  output logic        alusrc,
		  output logic[1:0]   alucontrol,
		  output logic        memwrite, memtoreg,
		  output logic        pcsrc);
		  
logic[1:0]    flagw;
logic         pcs, regw, memw;

decoder dec(instr[27:26], instr[25:20], instr[15:12], flagw, pcs, regw, memw, memtoreg, alusrc, immsrc, regsrc, alucontrol);

condlogic cl(clk, reset, instr[31:28], aluflags, flagw, pcs, regw, memw, pcsrc, regwrite, memwrite);

endmodule
