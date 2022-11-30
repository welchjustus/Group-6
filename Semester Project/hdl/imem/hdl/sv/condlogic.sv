module condlogic(input  logic        clk, reset,
                 input  logic[3:0]   cond,
	         input  logic[3:0]   aluflags,
	         input  logic[1:0]   flagw,
	         input  logic        pcs, regw, memw,
	         output logic        pcsrc, regwrite, memwrite);
		 
logic[1:0]  flagwrite;
logic[3:0]  flags;
logic       condex;

flopenr #(2)flagreg1(clk, reset, flagwrite[1], aluflags[3:2], flags[3:2]);
flopenr #(2)flagreg0(clk, reset, flagwrite[0], aluflags[1:0], flags[1:0]);

condcheck cc(cond, flags, condex);
assign    flagwrite = flagw & {2{condex}};
assign    regwrite  = regw  & condex;
assign    memwrite  = memw  & condex;
assign    pcsrc     = pcs   & condex;

endmodule


module condcheck(input  logic[3:0]   cond,
                 input  logic[3:0]   flags,
		 output logic        condex);
		 
logic    neg, zero, carry, overflow, ge;
assign  (neg, zero, carry, overflow) = flags;
assign   ge = (neg == overflow);

always_comb
    
    case(cond)
    
        4'0000: condex = zero;
	4'0001: condex = ~zero;
	4'0010: condex = carry;
	4'0011: condex = ~carry;
	4'0100: condex = neg;
	4'0101: condex = ~neg;
	4'0110: condex = overflow;
	4'0111: condex = ~overflow;
	4'1000: condex = carry & ~zero;
	4'1001: condex = ~(carry & ~zero);
	4'1010: condex = ge;
	4'1011: condex = ~ge;
	4'1100: condex = ~zero & ge;
	4'1101: condex = ~(~zero & ge);
	4'1110: condex = 1'b1;
	default: condex = 1'bx;
	
    endcase
    
endmodule
