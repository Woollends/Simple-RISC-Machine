module instruction_decoder(in,ALUop,sximm5,sximm8,shift,readnum,writenum,opcode,op,nsel);
input [15:0] in;
input [2:0] nsel;
output reg [2:0] opcode, readnum, writenum;
output reg [1:0] op,shift,ALUop;
output reg [15:0] sximm5, sximm8;




always@(*)begin //always block to assign values from input
opcode={in[15],in[14],in[13]};
op={in[12],in[11]};
shift={in[4],in[3]};
sximm8={8'b0,in[7],in[6],in[5],in[4],in[3],in[2],in[1],in[0]};
sximm5={13'b0,in[4],in[3],in[2],in[1],in[0]};
ALUop={in[12],in[11]};


case(nsel) //case statement for nsel, assinging read and write num
	
	3'b001:readnum={in[2:0]};
	3'b010:readnum={in[7],in[6],in[5]};
	3'b100:readnum={in[10],in[9],in[8]};
	default:readnum=3'b000;
endcase
writenum=readnum;
end
endmodule
