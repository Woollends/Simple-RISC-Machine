module lab7_tb;
  reg [3:0] KEY;
  reg [9:0] SW;
  wire [9:0] LEDR; 
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  reg err;

  lab7_top DUT(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

  initial forever begin
    KEY[0] = 0; #1;
    KEY[0] = 1; #1;
  end

  initial begin
    err = 0;
    KEY[1] = 1'b0; // reset asserted
    
    #2;

    KEY[1] = 1'b1; // reset de-asserted
	 

    #2; // waiting for RST state to cause reset of PC

    
    if (DUT.CPU.PC !== 9'b0) begin err = 1; $display("FAILED: PC is not reset to zero.");  end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
    if (DUT.CPU.PC !== 9'h1) begin err = 1; $display("FAILED: PC should be 1.");  end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
    if (DUT.CPU.PC !== 9'h2) begin err = 1; $display("FAILED: PC should be 2.");  end
    if (DUT.CPU.DP.REGFILE.R0 !== 16'h2) begin err = 1; $display("FAILED: R0 should be 2.");  end  // because MOV R0, X should have occurred
//MOV R0, #2
    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
    if (DUT.CPU.PC !== 9'h3) begin err = 1;  end
    if (DUT.CPU.DP.REGFILE.R7 !== 16'h7) begin err = 1;   end
//MOV R7, #7
    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
    if (DUT.CPU.PC !== 9'h4) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R1 !== 16'h3) begin err = 1;  end
//MOV R1, #3
    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'h5) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R2 !== 16'h5) begin err = 1; end
//ADD R3,R0,R1
    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'h6) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R5 !== 16'hA) begin err = 1; end
//ADD R5,R7,R1	 
	  @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'h7) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R6 !== 16'h1B) begin err = 1; end
//ADD R6,R7,R5 LSL #1	 
	  @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'h8) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R3 !== 16'b0000_0000_0000_0100) begin err = 1; end
//AND R3,R2,R1 LSL #1	 
	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'h9) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R5 !== 16'b0000_0000_0000_0010) begin err = 1; end
//AND R5,R5,R3 LSR #1	 
	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'hA) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R5 !== 16'b0000_0000_0000_0010) begin err = 1; end
//AND R5,R1,R5	 
	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'hB) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R4 !== 16'b1111_1111_1111_1010) begin err = 1; end
//MVN R4,R2	 
	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'hC) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R4 !== 16'b0000_0000_0000_1011) begin err = 1; end

//MVN R4,R4 LSL #1	 
	  @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'hD) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R4 !== 16'b1111_1111_1111_0111) begin err = 1; end
//MVN R4,R3 LSL #1	 
	  @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'hE) begin err = 1; end
    if (DUT.CPU.DP.Z !== 1'b1) begin err = 1; end
//CMP R0,R0	 
	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'hF) begin err = 1; end
    if (DUT.CPU.DP.Z !== 1'b0) begin err = 1; end
//CMP R0,R4	 
	  @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'h10) begin err = 1; end
    if (DUT.CPU.DP.Z !== 1'b0) begin err = 1; end
//CMP R4,R0	 
	  @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'h11) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R0 !== 16'b0000_0000_0000_0101) begin err = 1; end
//MOV R0,R2	 
	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'h12) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R0 !== 16'b0000_0000_0000_0101) begin err = 1; end
//MOV R0,R0	 
	  @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'h13) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R0 !== 16'b1111_1111_1110_1110) begin err = 1; end
//MOV R0,R4 LSL #1	 
	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'h14) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R0 !== 16'h1C) begin err = 1; end
//MOV R0,X
     @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
	 
	 if (DUT.CPU.PC !== 9'h15) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R1 !== 16'h1D) begin err = 1; end
//MOV R1,Y	 
	  @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
	 
	 if (DUT.CPU.PC !== 9'h16) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R2 !== 16'h1E) begin err = 1; end
//MOV R2,Z	 
	  @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
	 
	 if (DUT.CPU.PC !== 9'h17) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R3 !== 16'b1010101111001101) begin err = 1; end
//LDR R3,X	 
	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
	 
	 if (DUT.CPU.PC !== 9'h18) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R4 !== 16'b1011101010111110) begin err = 1; end
//LDR R4,X+#1	 
	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
	 
	 if (DUT.CPU.PC !== 9'h19) begin err = 1; end
    if (DUT.CPU.DP.REGFILE.R5 !== 16'b1101111010101101) begin err = 1; end
//LDR R5,Z	 
	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
	 
	 if (DUT.CPU.PC !== 9'h1A) begin err = 1; end
    if (DUT.MEM.mem[31] !== 16'b1010101111001101) begin err = 1; end
//STR R3,X+#3	 
	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
	 
	 if (DUT.CPU.PC !== 9'h1B) begin err = 1; end
    if (DUT.MEM.mem[32] !== 16'b1011101010111110) begin err = 1; end
//STR R4,Y+#3	 
	  @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
	 
	 if (DUT.CPU.PC !== 9'h1C) begin err = 1; end
    if (DUT.MEM.mem[33] !== 16'b1101111010101101) begin err = 1; end
//STR R5,Z+#3
//HALT
    if (~err) $display("INTERFACE OK");
	 
    $stop;
  end
endmodule
