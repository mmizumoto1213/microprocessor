// sample top level design
module top_level(
  input        clk, reset, req, 
  output logic done);
  parameter D = 12,             // program counter width
    A = 3;             		  // ALU command bit width
  wire[D-1:0] target, 			  // jump 
              prog_ctr;
  wire        RegWrite;
  wire[7:0]   Accum,datB,reg14,reg15,track64,track65,		  // from RegFile
              muxB, 
	      dat_in,
			  rslt,               // alu output
	      dat_out,
	      //regfile_dat,
              immed;
  logic sc_in,   				  // shift/carry out from/to ALU
   		pariQ,              	  // registered parity flag from ALU
		zeroQ;                    // registered zero flag from ALU 
  wire  relj;                     // from control to PC; relative jump enable
  wire  pari,
        zero,
		sc_clr,
		sc_en,
        MemWrite,
	Memread,
	move,
        ALUSrc;		              // immediate switch
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[3:0] rd_adrB;    // address pointers to reg_file
  wire[3:0] addr;
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
         .clk              ,
		 .reljump_en (relj),
		 .target           ,
		 .prog_ctr          );

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 (.addr  (reg14),
         .target          );   

// contains machine code

  instr_ROM ir1(.prog_ctr,
               .mach_code);


// control decoder
/*
  Control ctl1(.instr(),
  .RegDst  (), 
  .Branch  (relj)  , 
  .MemWrite , 
  .ALUSrc   , 
  .RegWrite   ,     
  .MemtoReg(),
  .ALUOp());
*/
  //assign rd_addrA = mach_code[2:0];
  assign addr     = mach_code[3:0];

  assign ALUSrc   = mach_code[8];

  reg_file #(.pw(4)) rf1(.dat_in (Accum),
	      .addr        ,
	      .clk         , // loads, most ops
              .wr_en   (RegWrite),
              //.rd_addrA(rd_addrA),
              //.rd_addrB(rd_addrB),
                    // in place operation
              .datA_out(),
              .datB_out(datB),
	      .reg14,
	      .reg15); 

  alu alu1(
		 .mach_code  ,
		 .inB    (datB),
		 .mem_data (dat_out),
		 .sc_i   (sc),   // output from sc register
		 .ALUSrc     ,
		 .rslt   (Accum),
		 .sc_o   (sc_o), // input to sc register
		 .MemWrite   ,
		 .Memread    ,
		 .RegWrite   ,
		 .relj       ,
		 .pari  );  

//  assign Accum = rslt;
//  assign regfile_dat = Accum;

  dat_mem dm(.dat_in(rslt)  ,  // from reg_file
             .clk           ,
			 .wr_en  (MemWrite), // stores
			 .Memread  ,
			 .addr   (reg15),
			 .track64,
			 .track65,
             .dat_out () );

//  assign Accum = Memread ? dat_out : Accum;

// registered flags from ALU
  always_ff @(posedge clk) begin
    pariQ <= pari;
	zeroQ <= zero;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end

  assign done = prog_ctr >= 160;
 
endmodule