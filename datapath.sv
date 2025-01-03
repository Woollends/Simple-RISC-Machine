module datapath(clk,mdata,PC,sximm8,sximm5,write,vsel,loada,loadb,asel,bsel,loadc,loads,readnum,writenum,shift,ALUop,datapath_out,Z_out,V_out,N_out);

  input clk;
  input [15:0] mdata,sximm8,sximm5;
  input write, loada, loadb, asel, bsel, loadc, loads;
  input [2:0] readnum, writenum;
  input [1:0] shift, vsel, ALUop;
	input [8:0] PC;
  output reg [15:0] datapath_out;
  output reg Z_out,V_out,N_out;
 

reg [15:0] data_in; 
reg [15:0] data_out;
reg [15:0] LOADA;
reg [15:0] in;
reg [15:0] out;
reg [15:0] sout;
reg [15:0] Ain;
reg [15:0] Bin;
reg Z,V,N;

  regfile REGFILE ( //instantiation of regfile
    .data_in(data_in),
    .writenum(writenum),
    .readnum(readnum),
    .write(write),
    .clk(clk),
    .data_out(data_out)
  );
  
  
  shifter SHIFTER ( //instantiation of shifter
	  .in(in),
	  .shift(shift),
	  .sout(sout)
  );
 
  ALU alu(  //instantiation of ALU
	  .Ain(Ain),
	  .Bin(Bin),
	  .ALUop(ALUop),
	  .out(out),
	  .Z(Z),
	  .V(V),
	  .N(N)
  );


 
 always@(*)begin  //mux for vsel, Ain, Bin

	case(vsel)
	2'b11:data_in=mdata;
	2'b10:data_in=sximm8;
	2'b01:data_in={7'b0,PC};
	2'b00:data_in=datapath_out;
	default:data_in=16'bx;
endcase

	case(asel)
	
	1'b1:Ain=16'b0;
	1'b0:Ain=LOADA;
	default:Ain=16'bx;
endcase

	case(bsel)
		
		1'b1:Bin=sximm5;
		1'b0:Bin=sout;
		default:Bin=16'bx;
	endcase

end

wire [15:0] LOADA_nxt = loada ? data_out:LOADA; //ff for loada
VDFF #(16) loadA(clk,LOADA_nxt,LOADA);

wire [15:0] LOADB_nxt = loadb ? data_out:in; //ff for loadb
VDFF #(16) loadB(clk,LOADB_nxt,in);

wire [15:0] LOADC_nxt = loadc ? out:datapath_out; //ff for loadc
VDFF #(16) loadC(clk,LOADC_nxt,datapath_out);

wire LOADS_nxtZ = loads ? Z:Z_out; //ff for loads
VDFF #(1) loadZ(clk,LOADS_nxtZ,Z_out);

wire LOADS_nxtN = loads ? N:N_out; //ff for loads
VDFF #(1) loadN(clk,LOADS_nxtN,N_out);

wire LOADS_nxtV = loads ? V:V_out; //ff for loads
VDFF #(1) loadV(clk,LOADS_nxtV,V_out);




endmodule

module VDFF(clk,D,Q); //flip flop module
  parameter n=1;
  input clk;
  input [n-1:0] D;
  output [n-1:0] Q;
  reg [n-1:0] Q;

  always @(posedge clk)
    Q <= D;
endmodule

