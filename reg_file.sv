// cache memory/register file
// default address pointer width = 4, for 16 registers
module reg_file #(parameter pw=4)(

  input[7:0] dat_in,
  input[3:0] addr,
  input      clk,
  input      wr_en,           // write enable
  output logic[7:0] datA_out, // read data
                    datB_out,
		    reg14,
		    reg15);

  logic[7:0] core[16];    // 2-dim array  8 wide  16 deep

// reads are combinational
  //assign datA_out = core[0];
  assign datB_out = core[addr];
  assign reg14    = core[14];
  assign reg15    = core[15];
  //assign reg9     = core[9];

// writes are sequential (clocked)
  always_ff @(posedge clk) begin
    //$display("Accum:%d  R1:%d  R2:%d  R3:%d  R14:%d",core[0], core[1], core[2], core[3], core[14]);
    core[0] <= dat_in;
    if(wr_en) begin				   // anything but stores or no ops
      //$display("write is enabled for registers");
      core[addr] <= core[0]; 
    end
    
    //datB_out = core[addr];
  end

endmodule
/*
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
*/