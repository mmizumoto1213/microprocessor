// combinational -- no clock
// sample -- change as desired
module alu(    // ALU instructions
  input[8:0] mach_code,
  input[7:0] inB,	 // 8-bit wide data path, inA is the accumulator
	     mem_data,
  input      sc_i,       // shift_carry in
	     ALUSrc,	 // switch to turn on and off ALU
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
	       MemWrite,
	       Memread,
	       RegWrite,
	       relj,
               pari     // reduction XOR (output)
//			   zero      // NOR (output)
);
logic[3:0] alu_cmd;
always_comb begin 
  alu_cmd = mach_code[7:4];
  rslt = 'b0;            
  sc_o = 'b0;  
  MemWrite = 'b0;  
  Memread = 'b0;
  RegWrite = 'b0;
  relj = 'b0;
//  zero = !rslt;
  pari = ^rslt;
  if(ALUSrc) begin
    rslt = mach_code[7:0];
  end else begin
    case(alu_cmd)
	4'b0000: // and: bitwise AND
	  {rslt} = rslt & inB;
	4'b0001: // add: Add 2 8-bit unsigned; automatically makes carry-out
	  {sc_o,rslt} = rslt + inB + sc_i;
	4'b0010: // sub: subtract
	  {sc_o,rslt} = rslt - inB + sc_i;
	4'b0011: // xor: XOR
	  rslt = rslt ^ inB;
	4'b0100: // shr: logical right shift
	  {rslt,sc_o} = {sc_o,rslt};
	4'b0101: // shr: logical right shift
	  {sc_o,rslt} = {rslt,sc_o};
	4'b0110: // sw: store
	  MemWrite = 'b1;
	4'b0111: begin// lw: load
	  Memread = 'b1;
	  rslt = mem_data;
	end
	4'b1000: // mov: move
	  RegWrite = 'b1;
	4'b1001: begin// beq: branch equal
	  if (rslt == inB)
	    relj = 'b1;
	end
	4'b1010: begin// bne: branch not equal
	  if (rslt != inB)
	    relj = 'b1;
	end
	4'b1011: begin// bgt: branch greater than
	  if (rslt > inB)
	    relj = 'b1;
	end
	4'b1100: begin// bge: branch greater equal
	  if (rslt >= inB)
	    relj = 'b1;
	end
	4'b1101: begin// beq: branch less than
	  if (rslt < inB)
	    relj = 'b1;
	end
	4'b1110: // sbr: shift barrel right
	  rslt = {rslt[0],rslt[7:1]};
	4'b1111: // sbl: shift barrel left
	  rslt = {rslt[6:0],rslt[7]};
	
	  
/*  
    3'b000: // add 2 8-bit unsigned; automatically makes carry-out
      {sc_o,rslt} = inA + inB + sc_i;
	3'b001: // left_shift
	  {sc_o,rslt} = {inA, sc_i};
*/
      /*begin
		rslt[7:1] = ina[6:0];
		rslt[0]   = sc_i;
		sc_o      = ina[7];
      end*/
/*
    3'b010: // right shift (alternative syntax -- works like left shift
	  {rslt,sc_o} = {sc_i,inA};
    3'b011: // bitwise XOR
	  rslt = inA ^ inB;
	3'b100: // bitwise AND (mask)
	  rslt = inA & inB;
	3'b101: // left rotate
	  rslt = {inA[6:0],inA[7]};
	3'b110: // subtract
	  {sc_o,rslt} = inA - inB + sc_i;
	3'b111: // pass A
	  rslt = inA;
*/
    endcase
  end
end
   
endmodule