// 8-bit wide, 256-word (byte) deep memory array
module dat_mem (
  input[7:0] dat_in,
  input      clk,
  input      wr_en,	          // write enable
  input      Memread,
  input[7:0] addr,		      // address pointer
  output logic[7:0] track64, track65, dat_out);

  logic[7:0] core[256];       // 2-dim array  8 wide  256 deep

// reads are combinational; no enable or clock required
//  assign dat_out = Memread ? core[addr] : dat_in;
  always_comb
    dat_out = Memread ? core[addr] : dat_in;


// writes are sequential (clocked) -- occur on stores or pushes 
  always_ff @(posedge clk) begin
    if(wr_en)				  // wr_en usually = 0; = 1 		
      core[addr] <= dat_in; 
  end
endmodule