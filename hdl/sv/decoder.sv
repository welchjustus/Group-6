module decoder(input  logic[1:0]   op,
               input  logic[5:0]   funct,
	       input  logic[3:0]   rd,
	       output logic[1:0]   flagw,
	       output logic        pcs, regw, memw,
	       output logic        memtoreg, alusrc,
	       output logic[1:0]   immsrc, regsrc, alucontrol);
	       
logic[9:0]    controls;
logic         branch, aluop;

always_comb
    casex(op)
        
	2'b00:    if(funct[5])  controls = 10'b0000101001;  //data immediate
	          else          controls = 10'b0000001001;  //data register
		  
	2'b01:    if(funct[0])  controls = 10'b0001111000;  //LDR
	          else          controls = 10'b1001110100;  //STR
		  
        2'b10:                  controls = 10'b0110100010;  //B
	
	default:                controls = 10'bx;           //Invalid
    
    endcase

assign (regsrc, immsrc, alusrc, memtoreg, regw, memw, branch, aluop) = controls;

always_comb
  if (aluop) begin
  
    case(funct[4:1])
        
	4'b0100:    alucontrol = 2'b00;  //ADD
	4'b0010:    alucontrol = 2'b01;  //SUB
	4'b0000:    alucontrol = 2'b10;  //AND
	4'b1100:    alucontrol = 2'b11;  //ORR
	default:    alucontrol = 2'bx;   //Invaild
	
    endcase
    
    flagw[1] = funct[0];
    flagw[0] = funct[0] & (alucontrol == 2'b00 | alucontrol == 2'b01);
    
  end
  
  else begin
      
      alucontrol = 2'b00;
      flagw      = 2'b00;
      
  end
  
assign pcs = ((rd == 4'b1111) & regw) | branch;

endmodule
