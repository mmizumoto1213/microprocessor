module PC_LUT #(parameter D=12)(
  input       [ 7:0] addr,	   // target 4 values
  output logic[D-1:0] target);

  always_comb begin
    case(addr)
    	8'b00000000: target = 133;
	8'b00000001: target = -24;
	8'b00000010: target = 15;
	8'b00000011: target = 56;
	8'b00000100: target = 60;
	8'b00000101: target = 50;
	8'b00000110: target = -19;
	8'b00000111: target = -56;
	8'b00001000: target = -23;
	8'b00001001: target = -105;
	8'b00001010: target = -114;
	default: target = 0;  // hold PC  
    endcase
  end
endmodule

/*

	   pc = 4    0000_0000_0100	  4
	             1111_1111_1111	 -1

                 0000_0000_0011   3

				 (a+b)%(2**12)


   	  1111_1111_1011      -5
      0000_0001_0100     +20
	  1111_1111_1111      -1
	  0000_0000_0000     + 0


  */
