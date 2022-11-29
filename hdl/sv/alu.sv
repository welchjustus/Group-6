module alu(
  input  logic [31:0] a, b,
  input  logic [1:0]  alucontrol,
  output logic [31:0] result,
  output logic [3:0]  aluflags
);                                            //ALU Control decides function

  logic        neg, zero, carry, overflow;    //similar to variables, hold flags
  logic [31:0] condinvb;
  logic [32:0] sum;

  assign condinvb = alucontrol[0] ? ~b : b;   //00 is add, 01 is subtract
  assign sum = a + condinvb + alucontrol[0];  //Using alucontrol[0] to correct
  always_comb                                 //two's complement on SUB, I think
    casex (alucontrol[1:0])
      2'b0?: result = sum;                    //add and subtract
      2'b10: result = a & b;                  //AND
      2'b11: result = a | b;                  //OR
    endcase

  assign neg      = result[31];
  assign zero     = (result == 32'b0);
  assign carry    = (alucontrol[1] == 1'b0) & sum[32];
  assign overflow = (~alucontrol[1]) & ~(a[31] ^ b[31] ^ alucontrol[0]) & (a[31] ^ sum[31]);
  assign aluflags = {neg, zero, carry, overflow};
endmodule

