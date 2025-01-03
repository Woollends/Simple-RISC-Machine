module state_machine(OP,clk,reset,opcode,nsel,loada,loadb,loadc,loads,asel,bsel,vsel,write,load_pc,mem_cmd,addr_sel,reset_pc,loadir,load_addr);
input clk,reset;
input [1:0] OP;
input [2:0] opcode;
output reg write,loada,loadb,asel,bsel,loadc,loads,addr_sel,loadir,load_addr,load_pc,reset_pc;
output reg [1:0]vsel, mem_cmd;
output reg [2:0] nsel;


`define SW 4  //defining states
`define SR 4'b0000 //reset state
`define IF1 4'b0111 //states for Mread
`define IF2 4'b1111
`define UpdatePC 4'b1001 //state to update PC
`define SA 4'b0011 //states for loada
`define SB 4'b0100 //state for loadb
`define SC 4'b0101 //state for loadc
`define SDC 4'b0001 //decode state
`define SWN 4'b0010 //state for writereg
`define Swrite 4'b1010 //state for writereg from output
`define HALT 4'b1011 //state for halt
`define SDA 4'b1100  //state for data address

`define SWR 4'b1101 //state for writing to ram
`define SMR 4'b1110 //state for writing to register using msel
`define SRR 4'b0110 //state for reading ram
`define Sx 4'b1111 //exrta
`define MREAD 2'b11
`define MWRITE 2'b01
`define MNONE 2'b00

reg [`SW-1:0] state;

always_ff@(negedge clk)begin
if(reset==1'b1)begin
state=`SR; //state A, waiting for S
end else begin
	case(state)
	
		`SR:state=`IF1; 
		`IF1:state=`IF2;
		`IF2:state=`UpdatePC;
		`UpdatePC:state=`SDC;
		`SA:state=`SB; //4 states to assign datapath
		`SB:state=`SC;
		
		`Swrite:state=`IF1; 
		`SWN:state=`IF1; //state to write move
		`SMR:state=`IF1;
		`SWR:state=`IF1;
		`SRR:state=`SMR;
		
		
		`SDC:if(opcode==3'b110&&OP==2'b10)begin //SDC contorls which path we use afterpc
			state=`SWN;
		end else if (opcode==3'b101||opcode==3'b110||opcode==3'b011||opcode==3'b100) begin
			state=`SA; //state for full datapath
		end else if(opcode==3'b111)begin
			state=`HALT;
			end 
			
		`SC:if(opcode==3'b011||opcode==3'b100)begin //sc leads to 2 diffrent outcomes
			state=`SDA; 
		end else begin
			state=`Swrite;
		end
		
		`SDA:if(opcode==3'b100)begin //sda changes for LDR or SDR
			state=`SWR;
		end else begin
			state=`SRR;
		end
		
		`HALT:state=`HALT; //halt loops to halt
			
		
		
		
	default:state=`SR;
endcase
end
end

always@(*)begin

	case(state)
	
	`SR:begin //values for sr
    nsel = 3'b000;
    vsel = 2'b00;
    write = 1'b0;
	 loada=1'b0;
	 loadb=1'b0;
	 loadc=1'b0;
	 asel=1'b0;
	 bsel=1'b0;
	 load_pc=1'b1;
	 loads=1'b0;
	 mem_cmd=`MNONE;
	 reset_pc=1'b1;
	 load_addr=1'b0;
	 loadir=1'b0;
	 addr_sel=1'b0;
   end
	
	`IF1:begin //values for if1
	  nsel = 3'b000;
    vsel = 2'b00;
    write = 1'b0;
	 loada=1'b0;
	 loadb=1'b0;
	 loadc=1'b0;
	 asel=1'b0;
	 bsel=1'b0;
	 load_pc=1'b0;
	 loads=1'b0;
	 mem_cmd=`MREAD;
	 reset_pc=1'b0;
	 load_addr=1'b0;
	 loadir=1'b0;
	 addr_sel=1'b1;
	 end
	
	`IF2:begin //values for if2
	nsel = 3'b000;
    vsel = 2'b00;
    write = 1'b0;
	 loada=1'b0;
	 loadb=1'b0;
	 loadc=1'b0;
	 asel=1'b0;
	 bsel=1'b0;
	 load_pc=1'b0;
	 loads=1'b0;
	 mem_cmd=`MREAD;
	 reset_pc=1'b0;
	 load_addr=1'b0;
	 loadir=1'b1;
	 addr_sel=1'b1;
	end
	
	`UpdatePC:begin //values for updatepc
	nsel = 3'b000;
    vsel = 2'b00;
    write = 1'b0;
	 loada=1'b0;
	 loadb=1'b0;
	 loadc=1'b0;
	 asel=1'b0;
	 bsel=1'b0;
	 load_pc=1'b1;
	 loads=1'b0;
	 mem_cmd=`MNONE;
	 reset_pc=1'b0;
	 load_addr=1'b0;
	 loadir=1'b0;
	 addr_sel=1'b0;
	end
	
	`SDC:begin //values for sdc
	nsel = 3'b000;
    vsel = 2'b00;
    write = 1'b0;
	 loada=1'b0;
	 loadb=1'b0;
	 loadc=1'b0;
	 asel=1'b0;
	 bsel=1'b0;
	 load_pc=1'b0;
	 loads=1'b0;
	 mem_cmd=`MNONE;
	 reset_pc=1'b0;
	 load_addr=1'b0;
	 loadir=1'b0;
	 addr_sel=1'b0;
	end
	
	`SA:begin //values for sa
	nsel = 3'b100;
    vsel = 2'b00;
    write = 1'b0;
	 loada=1'b1;
	 loadb=1'b0;
	 loadc=1'b0;
	 asel=1'b0;
	 bsel=1'b0;
	 load_pc=1'b0;
	 loads=1'b0;
	 mem_cmd=`MNONE;
	 reset_pc=1'b0;
	 load_addr=1'b0;
	 loadir=1'b0;
	 addr_sel=1'b0;
	end
	
	`SB:begin //values for sb
	if(opcode==3'b100)begin
	nsel=3'b010;
	end else begin
	nsel = 3'b001;
	end;
    vsel = 2'b00;
    write = 1'b0;
	 loada=1'b0;
	 loadb=1'b1;
	 loadc=1'b0;
	 asel=1'b0;
	 bsel=1'b0;
	 load_pc=1'b0;
	 loads=1'b0;
	 mem_cmd=`MNONE;
	 reset_pc=1'b0;
	 load_addr=1'b0;
	 loadir=1'b0;
	 addr_sel=1'b0;
	end
	
	`SC:begin //values for sc
	
	if(opcode==3'b110)begin
	asel=1'b1;
	end else begin
	asel=1'b0;
	end
	
	nsel = 3'b001;
    vsel = 2'b00;
    write = 1'b0;
	 loada=1'b0;
	 loadb=1'b0;
	 loadc=1'b1;
	 load_pc=1'b0; 
	 
	 if(OP==2'b01)begin
	loads=1'b1;
	end else begin
	loads=1'b0;
	end
	
	if(opcode==3'b011||opcode==3'b100)begin
	bsel=1'b1;
	end else begin
	bsel=1'b0;
	end
	
	 mem_cmd=`MNONE;
	 reset_pc=1'b0;
	 load_addr=1'b0;
	 loadir=1'b0;
	 addr_sel=1'b0;
	end
	
	`Swrite:begin //values for Swrite
	nsel = 3'b010;
    vsel = 2'b00;
	 
	 if(OP==2'b01)begin
	 write=1'b0;
	 end else begin
	 write=1'b1;
	 end
	 
    loadc = 1'b0;
	 loada=1'b0;
	 loadb=1'b0;
	 asel=1'b0;
	 bsel=1'b0;
	 load_pc=1'b0;
	 loads=1'b0;
	 mem_cmd=`MNONE;
	 reset_pc=1'b0;
	 load_addr=1'b0;
	 loadir=1'b0;
	 addr_sel=1'b0;
	end
	
	
	`SWN:begin   //values for SWN
	nsel = 3'b100;
    vsel = 2'b10;
    write = 1'b1;
	 loada=1'b0;
	 loadb=1'b0;
	 loadc=1'b0;
	 asel=1'b0;
	 bsel=1'b0;
	 load_pc=1'b0;
	 loads=1'b0;
	 mem_cmd=`MNONE;
	 reset_pc=1'b0;
	 load_addr=1'b0;
	 loadir=1'b0;
	 addr_sel=1'b0;
	end
	
	`HALT:begin //values for HALT
	nsel = 3'b000;
    vsel = 2'b00;
    write = 1'b0;
	 loada=1'b0;
	 loadb=1'b0;
	 loadc=1'b0;
	 asel=1'b0;
	 bsel=1'b0;
	 load_pc=1'b0;
	 loads=1'b0;
	 mem_cmd=`MNONE;
	 reset_pc=1'b0;
	 load_addr=1'b0;
	 loadir=1'b0;
	 addr_sel=1'b0;
	end
	
	`SDA:begin  //values for sda
	nsel = 3'b000;
    vsel = 2'b00;
    write = 1'b0;
	 loada=1'b0;
	 loadb=1'b0;
	 load_pc=1'b0;
	 loads=1'b0;
	 mem_cmd=`MNONE;
	 reset_pc=1'b0;
	 load_addr=1'b1;
	 loadir=1'b0;
	 addr_sel=1'b0;
	 if(opcode==3'b100)begin
	 bsel=1'b0;
	 asel=1'b1;
	 loadc=1'b1;
	 end else begin
	  bsel=1'b0;
	 asel=1'b0;
	 loadc=1'b0;
	 end
	 
	end
	
	`SWR:begin //values for swr
	nsel = 3'b000;
    vsel = 2'b00;
    write = 1'b0;
	 loada=1'b0;
	 loadb=1'b0;
	 loadc=1'b0;
	 asel=1'b0;
	 bsel=1'b0;
	 load_pc=1'b0;
	 loads=1'b0;
	 mem_cmd=`MWRITE;
	 reset_pc=1'b0;
	 load_addr=1'b0;
	 loadir=1'b0;
	 addr_sel=1'b0;
	end
	
	`SRR:begin //values for srr
	nsel = 3'b100;
    vsel = 2'b00;
    write = 1'b0;
	 loada=1'b0;
	 loadb=1'b0;
	 loadc=1'b0;
	 asel=1'b0;
	 bsel=1'b0;
	 load_pc=1'b0;
	 loads=1'b0;
	 mem_cmd=`MREAD;
	 reset_pc=1'b0;
	 load_addr=1'b0;
	 loadir=1'b0;
	 addr_sel=1'b0;
	end
	
	
	`SMR:begin //values for smr
	nsel = 3'b010;
    vsel = 2'b11;
    write = 1'b1;
	 loada=1'b0;
	 loadb=1'b0;
	 loadc=1'b0;
	 asel=1'b0;
	 bsel=1'b0;
	 load_pc=1'b0;
	 loads=1'b0;
	 mem_cmd=`MREAD;
	 reset_pc=1'b0;
	 load_addr=1'b0;
	 loadir=1'b0;
	 addr_sel=1'b0;
	end
	
	default:begin //assinging values for default
	nsel = 3'b000;
    vsel = 2'b00;
    write = 1'b0;
	 loada=1'b0;
	 loadb=1'b0;
	 loadc=1'b0;
	 asel=1'b0;
	 bsel=1'b0;
	 load_pc=1'b0;
	 loads=1'b0;
	 mem_cmd=`MNONE;
	 reset_pc=1'b0;
	 load_addr=1'b0;
	 loadir=1'b0;
	 addr_sel=1'b0;
	end
	
	
	

	endcase
end
endmodule	