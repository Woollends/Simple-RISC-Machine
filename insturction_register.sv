module instruction_register(clk,load,in,out);
input clk,load;
input [15:0] in;
output reg [15:0] out;

always_ff@(posedge clk)begin //ff for load

	if(load==1'b1)begin
	out=in;
	end else begin
	out=out;
end end

endmodule