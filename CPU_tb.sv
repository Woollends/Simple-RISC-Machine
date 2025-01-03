module cpu_tb();
reg clk, reset;
reg [15:0] in;
wire [15:0] out;
wire N, V, Z, w;
wire [8:0] mem_addr;
wire [1:0] mem_cmd;

reg err;

cpu DUT(
		.clk(clk),
		.reset(reset),
		.read_data(in),
		.write_data(out),
		.N(N),
		.V(V),
		.Z(Z),
		.load_pc(w),
		.mem_addr(mem_addr),
		.mem_cmd(mem_cmd)
		
		);
	
task test;
input [15:0] out; //test to test all internal signals
input N,V,Z,w;
begin
	err=1'b0;
	if(cpu_tb.DUT.write_data!=out)begin
	err=1'b1;
	end
	
	if(cpu_tb.DUT.N!=N)begin
	err=1'b1;
	end
	
	if(cpu_tb.DUT.V!=V)begin
	err=1'b1;
	end
	
	if(cpu_tb.DUT.Z!=Z)begin
	err=1'b1;
	end
	
	if(cpu_tb.DUT.load_pc!=w)begin
	err=1'b1;
	end
	
	
end 
endtask 

	initial begin
clk=1'b0;
#2
forever begin
clk=1'b1;
#1;
clk=1'b0;
#1;
end
end

initial begin
reset=1'b1;
#4;
test(1'sbx,1'bx,1'bx,1'bx,1'b1); //testing reset
reset=1'b0;

err=1'b0; in=16'b1101000000000010; //testing mov 2 into register 0

#6

test(1'sbx,1'bx,1'bx,1'bx,1'b1); //mov command should be completed number 2 in R0


err=1'b0; in=16'b11010_111_00000111; //testing mov 7 into register 7

#10
test(1'sbx,1'bx,1'bx,1'bx,1'b1); //mov command should be completed number 7 in R7

 in=16'b1101000100000011; //testing mov 3 into register 1


#10
test(1'sbx,1'bx,1'bx,1'bx,1'b1); //mov command should be completed number 3 in R1

 in=16'b101_00_000_010_00_001; //adding 2 and 3 storing in r2

#10
test(1'sbx,1'bx,1'bx,1'bx,1'b1);



 //add command should be completed 5 stored in r2

 in=16'b101_00_111_101_00_001; 
 

#10

test(16'b0000_0000_0000_0101,1'bx,1'bx,1'bx,1'b0);

#16
test(16'b0000_0000_0000_1010,1'bx,1'bx,1'bx,1'b0); //add command should be completed 10 stored in R5

 in=16'b101_00_111_110_01_101;//adding 7 and 10 shifted left 1 storing in r6


#16
test(16'b0000_0000_0001_1011,1'bx,1'bx,1'bx,1'b0); //add command should be completed 27 stored in R6

 in=16'b101_10_010_011_01_001; //testing and command 5&3, 3 shifted left


#16
test(16'b0000_0000_0000_0100,1'bx,1'bx,1'bx,1'b0); //and command should be completed 4 stored in R3
 in=16'b101_10_101_101_10_011; //testing and command 4&7, 4 shifted right


#16
test(16'b0000_0000_0000_0010,1'bx,1'bx,1'bx,1'b0); //and command should be completed 2 stored in R5

 in=16'b101_10_001_101_00_101; //testing and command 2&3


#16
test(16'b0000_0000_0000_0010,1'bx,1'bx,1'bx,1'b0); //and command should be completed 2 stored in R5


 in=16'b101_11_000_100_00_010; //testing MVN for 5


#16
test(16'b1111_1111_1111_1010,1'bx,1'bx,1'bx,1'b0); //MVN command should be completed -5 stored in R4
 in=16'b101_11_000_100_01_100; //testing MVN for 5 shifted left from same register


#16
test(16'b0000_0000_0000_1011,1'bx,1'bx,1'bx,1'b0); //MVN command should be completed 11 stored in R4

 in=16'b101_11_000_100_01_011; //testing MVN for 4 shifted left

#16
test(16'b1111_1111_1111_0111,1'bx,1'bx,1'bx,1'b0); //MVN command should be completed


 in=16'b101_01_000_000_00_000; //testing CMP when equal


#16
test(1'sb0,1'b0,1'b0,1'b1,1'b0); //CMP command should be completed same value


 in=16'b101_01_000_000_00_100;//testing CMP when less than 2 and -5, causes overflow


#16
test(16'b0000_0000_0000_1011,1'b0,1'b1,1'b0,1'b0); //CMP command should be completed


 in=16'b101_01_100_000_00_000; //testing CMP when greater than


#16
test(16'b1111111111110101,1'b1,1'b1,1'b0,1'b0); //CMP command should be completed

 in=16'b110_00_000_000_00_010; //tesing mov register to other register

#16
test(16'b0000_0000_0000_0101,1'b1,1'b1,1'b0,1'b0); //and command should be completed


 in=16'b110_00_000_000_00_000; //tesing mov register to other register

#16
test(16'b0000_0000_0000_0101,1'b1,1'b1,1'b0,1'b0); //and command should be completed


 in=16'b110_00_000_000_01_100; //tesing mov register to other register

#16
test(16'b1111_1111_1110_1110,1'b1,1'b1,1'b0,1'b0); //and command should be completed


$stop;
end
endmodule




