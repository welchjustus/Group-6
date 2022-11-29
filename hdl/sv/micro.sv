module micro (
  input   logic         clk,
  input   logic         reset,
  output  logic [31:0]  writedata,
  output  logic [31:0]  dataadr,
  output  logic         memwrite
);

  logic   [31:0]  pc, instr, readdata;

  arm  arm(clk, reset, pc, instr, memwrite, dataadr, writedata, readdata)

  imem  imem(pc, instr);
  dmem  dmem(clk, memwrite, dataadr, writedata, readdata); 

endmodule

module arm(input  logic        clk, reset,
           output logic[31:0]  pc,
           input  logic[31:0]  instr,
           output logic        memwrite,
           output logic[31:0]  aluresult, writedata,
           input  logic[31:0]  readdata);
           
logic[3:0]   aluflags;
logic        regwrite, alusrc, memtoreg, pcsrc;
logic[1:0]   regsrc, immsrc, alucontrol;

controller c(clk, reset, instr[31:12], aluflags, regsrc, regwrite, immsrc, alusrc, alucontrol, memwrite, memtoreg, pcsrc);

datapath dp(clk, reset, regsrc, regwrite, immsrc, alusrc, alucontrol, memtoreg, pcsrc, aluflags, pc, instr, aluresult, writedata, readdata);

endmodule;
