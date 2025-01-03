module multiplex(load,A,B,out);
input load;
input [8:0] A,B;
output reg [8:0] out;


always@(*)begin
case(load)
	1'b0:out=B;
	1'b1:out=A;
	default:out=1'bx;
endcase
end

endmodule

