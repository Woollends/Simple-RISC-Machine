module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
input [3:0] KEY;
input [9:0] SW;
output reg [9:0] LEDR;
output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

`define MREAD 2'b11 //states for mem_cmd
`define MWRITE 2'b01
`define MNONE 2'b00

reg clk, reset,mred,enable,write,mwrite,msel; //all signals
reg [15:0] read_data;
wire [15:0] write_data,dout, ir;
wire N, V, Z, load_pc;
wire [8:0] mem_addr;
wire [1:0] mem_cmd;


cpu CPU( //inistaing CPU
	.clk(clk),
   .reset(reset),
   .read_data(read_data),
	.write_data(write_data),
	.N(N),
	.V(V),
	.Z(Z),
	.load_pc(load_pc),
	.mem_addr(mem_addr),
	.mem_cmd(mem_cmd)
	);

RAM MEM( //inistiating RAM
	.clk(clk),
	.read_address(mem_addr[7:0]),
	.write_address(mem_addr[7:0]),
	.write(write),
	.din(write_data),
	.dout(dout)
);
 
 
 assign HEX5[0] = ~Z; //assinging states
  assign HEX5[6] = ~N;
  assign HEX5[3] = ~V;
  
always@(*)begin

	clk=~KEY[0];
	reset=~KEY[1];
	
	if(mem_addr[8]==1'b1)begin //msel equal
	msel=1'b0;
	end else
	msel=1'b1;
	
	if(mem_cmd==`MREAD)begin //mred equal
	mred=1'b1;
	end else
	mred=1'b0;
	
	if(mem_cmd==`MWRITE)begin //mrite equal
	mwrite=1'b1;
	end else
	mwrite=1'b0;
	
	if(mred==1'b1&&msel==1'b1)begin //and gate for read
	enable=1'b1;
	end else
	enable=1'b0;
	
	if(mwrite==1'b1&&msel==1'b1)begin //and gate for write
	write=1'b1;
	end else
	write=1'b0;
 
 
 
end



  




assign read_data = enable ? dout : ir; //tristate invertor


input_iface IN(~KEY[0], SW, ir); //input iface

sseg H0(read_data[3:0],   HEX0);
  sseg H1(read_data[7:4],   HEX1); //segs
  sseg H2(read_data[11:8],  HEX2);
  sseg H3(read_data[15:12], HEX3);
  assign HEX4 = 7'b1111111;
  assign {HEX5[2:1],HEX5[5:4]} = 4'b1111; // disabled

always_ff@(posedge clk)begin //ff for load

	if(enable==1'b1)begin
	LEDR={1'b0,write_data[7:0]};
	end 
	end
 

endmodule
//
// 1. "Example 12-11: Verilog Single Clock Simple Dual-Port Synchronous RAM 
//     with Old Data Read-During-Write Behavior" 
// 2. "Example 12-29: Verilog HDL RAM Initialized with the readmemb Command"

//1101000000000010
//0110000000100000
//1101001000000011
//1000001000100000
//1110000000000000

module RAM(clk,read_address,write_address,write,din,dout); //from slideset
  parameter data_width = 16; 
  parameter addr_width = 8;
  parameter filename = "data.txt";

  input clk;
  input [addr_width-1:0] read_address, write_address;
  input write;
  input [data_width-1:0] din;
  output [data_width-1:0] dout;
  reg [data_width-1:0] dout;

  reg [data_width-1:0] mem [2**addr_width-1:0];

  initial $readmemb(filename, mem);

  always @ (posedge clk) begin
    if (write)
      mem[write_address] <= din;
    dout <= mem[read_address]; // dout doesn't get din in this clock cycle 
                               // (this is due to Verilog non-blocking assignment "<=")
  end 
endmodule

module input_iface(clk, SW, ir); //assinging a values for IR
  input clk;
  input [9:0] SW;
  output reg [15:0] ir;
 
  always@(*)begin
ir={8'b0,SW[7:0]};
end
 
endmodule 

module vDFF(clk,D,Q);
  parameter n=1;
  input clk;
  input [n-1:0] D;
  output [n-1:0] Q;
  reg [n-1:0] Q;
  always @(posedge clk)
    Q <= D;
endmodule 

module sseg(in,segs);
  input [3:0] in;
  output reg [6:0] segs;

  // NOTE: The code for sseg below is not complete: You can use your code from
  // Lab4 to fill this in or code from someone else's Lab4.  
  //
  // IMPORTANT:  If you *do* use someone else's Lab4 code for the seven
  // segment display you *need* to state the following three things in
  // a file README.txt that you submit with handin along with this code: 
  //
  //   1.  First and last name of student providing code
  //   2.  Student number of student providing code
  //   3.  Date and time that student provided you their code
  //
  // You must also (obviously!) have the other student's permission to use
  // their code.
  //
  // To do otherwise is considered plagiarism.
  //
  // One bit per segment. On the DE1-SoC a HEX segment is illuminated when
  // the input bit is 0. Bits 6543210 correspond to:
  //
  //    0000
  //   5    1
  //   5    1
  //    6666
  //   4    2
  //   4    2
  //    3333
  //
  // Decimal value | Hexadecimal symbol to render on (one) HEX display
  //             0 | 0
  //             1 | 1
  //             2 | 2
  //             3 | 3
  //             4 | 4
  //             5 | 5
  //             6 | 6
  //             7 | 7
  //             8 | 8
  //             9 | 9
  //            10 | A
  //            11 | b
  //            12 | C
  //            13 | d
  //            14 | E
  //            15 | F

  
always @(*) begin
    case (in)
        4'b0000: segs = 7'b1000000;
        4'b0001: segs = 7'b1111001;
        4'b0010: segs = 7'b0100100;
        4'b0011: segs = 7'b0110000;
        4'b0100: segs = 7'b0011001;
        4'b0101: segs = 7'b0010010;
        4'b0110: segs = 7'b0000010;
        4'b0111: segs = 7'b1111000;
        4'b1000: segs = 7'b0000000;
        4'b1001: segs = 7'b0010000;
        4'b1010: segs = 7'b0001000;
        4'b1011: segs = 7'b0000011;
        4'b1100: segs = 7'b1000110;
        4'b1101: segs = 7'b0100001;
        4'b1110: segs = 7'b0000110;
        4'b1111: segs = 7'b0001110;
        default: segs = 7'b1000000;  // Default to 0 if input is out of range
    endcase
end  // this will output "F" 

endmodule
       
