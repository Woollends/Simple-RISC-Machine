module datapath_tb();
reg clk,err;
reg [15:0] datapath_in,sximm5,mdata;
reg write, loada, loadb, asel, bsel, loadc, loads;
reg[1:0] vsel;
reg [2:0] readnum, writenum;
reg [1:0] shift, ALUop;
reg [8:0] PC;

wire [15:0] datapath_out;
wire Z_out,N_out,V_out;

datapath DUT(  //instantiation of datapath
		.clk(clk),
		.sximm8(datapath_in),
		.PC(PC),
		.mdata(mdata),
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
		.datapath_out(datapath_out),
		.Z_out(Z_out),
		.V_out(V_out),
		.N_out(N_out)
	);
	
task test;  //test to check if there is an error in datapath
input[15:0] expected_out;
input expected_z;

	begin
	if(datapath_tb.DUT.datapath_out!=expected_out)begin
	err=1'b1;
	end
	if(datapath_tb.DUT.Z_out!=expected_z)begin
	err=1'b1;
	end
	end
endtask

initial begin //clk cylce
	clk=1'b0; #3;
		forever begin
		clk=1'b1; #3;
		clk=1'b0; #3;
		end
end

initial begin
//initializing everything with ideal output, the output after 3 clk cycles should be input
datapath_in=1'sb1; vsel=2'b10; writenum=3'b100; write=1'b1; readnum=3'b100;err=1'b0;
loada=1'b1; loadb=1'b0; shift=2'b00; bsel=1'b1; asel=1'b1; ALUop=2'b00; loadc=1'b1; loads=1'b1;
mdata=1'b0; sximm5=1'sb1;
#27
test(1'sb1,1'b0);
//testing bsel, asel
bsel=1'b1;asel=1'b1;
#7
test(1'sb1,1'b0);
//testing loadb,loada,zout
loadb=1'b1;loada=1'b1;bsel=1'b0;
#18;
test(16'b1111111111111111,1'b0);
//testing zout and loadc
loada=1'b1;loadb=1'b1;loads=1'b0;loadc=1'b0;
#18
test(16'b1111111111111111,1'b0);
loadc=1'b1;loads=1'b1;
#18
test(16'b1111111111111111,1'b0);
//testing vsel
vsel=2'b00;
#1
datapath_in=1'b0;
#18
test(1'sb1,1'b0);


//test from slideset add register values R5 and R3, store in R2
vsel=1'b10; datapath_in=6'b101010; write=1'b1; writenum=2'b11;
#12;
datapath_in=4'b1101; writenum=3'b101;
#12;
write=1'b0; loadb=1'b1; loada=1'b0; readnum=2'b11;
#6;
loadb=1'b0; loada=1'b1; readnum=3'b101;
#6;
shift=2'b00; asel=1'b0; bsel=1'b0; ALUop=2'b00; loadc=1'b1;
#6;
test(16'b1111_1111_1111_1110,1'b0);
vsel=1'b0; write=1'b1; writenum=2'b10;
#6;

//test from slideset moving register value R3 into R7
write=1'b0; readnum=2'b11; loadb=1'b1;
#6;
asel=1'b0;shift=2'b00;bsel=1'b0;ALUop=2'b00;loadc=1'b1;loads=1'b1;
#6;
test(16'b1111_1111_1111_1110,1'b0);
writenum=3'b111; write=1'b1; vsel=2'b00;
#6;
readnum=3'b111; loadb=1'b1; asel=1'b0; bsel=1'b0;loadb=1'b1;
#18;
test(16'b1111_1111_1111_1100,1'b0);

#327;
$stop;
end
endmodule

