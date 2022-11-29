module 1mem(input  logic[31:0]  a,
	    output logic[31:0]  rd);
	    
logic [31:0] ram[63:0];
initial
  $readmemh("memfile.dat", ram);
assign rd = ram[a[31:2]];
    
endmodule
