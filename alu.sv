module ALU(Ain,Bin,ALUop,out,Z,V,N);
input [15:0] Ain, Bin;
input [1:0] ALUop;
output reg [15:0] out;
output reg Z,V,N;
// fill out the rest

always@(*)begin

case(ALUop) //case statement assining the values of out

	2'b00:out=Ain+Bin;
	2'b01:out=Ain-Bin;
	2'b10:out=Ain&Bin;
	2'b11:out=~Bin;
	
	default:out=1'bx;
endcase

if(out==16'b0000000000000000)begin //if else statment to assign Z
Z=1'b1;
end else begin
Z=1'b0;
end

if(out[15]==1'b1)begin
N=1'b1;
end else begin
N=1'b0;
end


if ((Ain[15]==1'b1)&&(Ain[15]==Bin[15])&&(Ain[15]!=out[15])) begin //cases to catch overflow
    V = 1'b1; 
end else if ((Ain[15]!=Bin[15])&&(Ain[15]==out[15])) begin
    V = 1'b1; 
end else begin
    V = 1'b0; 
end



end

endmodule
