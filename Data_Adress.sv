module Data_Adress(clk,load,in,out);
input clk,load;
input [8:0] in;
output reg [8:0] out;

always_ff@(posedge clk)begin 

	if(load==1'b1)begin
	out=in;
	end else begin
	out=out;
end end

endmodule
