module cpu(clk,reset,read_data,write_data,N,V,Z,load_pc,mem_addr,mem_cmd);
input clk, reset;
input [15:0] read_data;
output reg [15:0] write_data;
output reg N, V, Z, load_pc;
output reg [8:0] mem_addr;
output reg [1:0] mem_cmd;

reg [15:0]in_ID; //reg for insturction refister and decoder
reg write,loada,loadb,asel,bsel,loadc,loads,addr_sel,reset_pc; //reg for state machine
reg [2:0] nsel;
reg [2:0] opcode, readnum, writenum; //reg for decoder
reg [1:0] op,shift,ALUop,vsel;
reg [15:0] sximm5, sximm8;
reg [8:0] PC;
reg [8:0] next_pc,in_AD;
reg [8:0] zero=9'b0;
	
instruction_register IR( //loading the insturction register
	.clk(clk),
	.load(loadir),
	.in(read_data),
	.out(in_ID)
);


instruction_decoder ID( //loading the instruction decoder
		.in(in_ID),
		.opcode(opcode),
		.readnum(readnum),
		.writenum(writenum),
		.nsel(nsel),
		.op(op),
		.shift(shift),
		.ALUop(ALUop),
		.sximm5(sximm5),
		.sximm8(sximm8)
	);

state_machine ST( //loading the statemachine
		.OP(op),
		.clk(clk),
		.reset(reset),
		.opcode(opcode),
		.load_pc(load_pc),
		.vsel(vsel),
		.write(write),
		.loada(loada),
		.loadb(loadb),
		.asel(asel),
		.bsel(bsel),
		.loadc(loadc),
		.loads(loads),
		.nsel(nsel),
		.mem_cmd(mem_cmd),
		.addr_sel(addr_sel),
		.reset_pc(reset_pc),
      .loadir(loadir),
		.load_addr(load_addr)		
	);
	
datapath DP(  //loading datapath
		.clk(clk),
		.mdata(read_data),
		.PC(PC),
		.sximm8(sximm8),
		.sximm5(sximm5),
		.write(write),
		.vsel(vsel),
		.loada(loada),
		.loadb(loadb),
		.asel(asel),
		.bsel(bsel),
		.loadc(loadc),
		.loads(loads),
		.readnum(readnum),
		.writenum(writenum),
		.shift(shift),
		.ALUop(ALUop),
		.datapath_out(write_data),
		.Z_out(Z),
		.N_out(N),
		.V_out(V)
	);
	
multiplex PC1( //multiplex for pc
	.load(reset_pc),
	.A(zero),
	.B(PC+1'b1),
	.out(next_pc)
	);

multiplex AD( //multiplex fot data adress
	.load(addr_sel),
	.A(PC),
	.B(in_AD),
	.out(mem_addr)
   );		

Program_Counter PC2( //loading the insturction register
	.clk(clk),
	.load(load_pc),
	.in(next_pc),
	.out(PC)
);

Data_Adress DA( //loading the insturction register
	.clk(clk),
	.load(load_addr),
	.in(write_data[8:0]),
	.out(in_AD)
);

	


endmodule



	