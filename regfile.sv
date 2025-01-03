module regfile(data_in,writenum,write,readnum,clk,data_out);
input [15:0] data_in;
input [2:0] writenum, readnum;
input write, clk;
output reg [15:0] data_out;
// fill out the rest
reg [7:0] writenum_dec,readnum_dec;
reg B0,B1,B2,B3,B4,B5,B6,B7;
reg [15:0] R0,R1,R2,R3,R4,R5,R6,R7;

always@(*)begin
writenum_dec=1'b0;		//assinging the onehot code for writenum
	case(writenum)
	
	
	3'b000:writenum_dec[0]=1'b1;
	3'b001:writenum_dec[1]=1'b1;
	3'b010:writenum_dec[2]=1'b1;
	3'b011:writenum_dec[3]=1'b1;
	3'b100:writenum_dec[4]=1'b1;
	3'b101:writenum_dec[5]=1'b1;
	3'b110:writenum_dec[6]=1'b1;
	3'b111:writenum_dec[7]=1'b1;
	
	default:writenum_dec=1'b0;
	endcase
end

always@(*)begin  //assinging the onehot code for readnum
readnum_dec=1'b0;
	case(readnum)
	
	3'b000:readnum_dec[0]=1'b1;
	3'b001:readnum_dec[1]=1'b1;
	3'b010:readnum_dec[2]=1'b1;
	3'b011:readnum_dec[3]=1'b1;
	3'b100:readnum_dec[4]=1'b1;
	3'b101:readnum_dec[5]=1'b1;
	3'b110:readnum_dec[6]=1'b1;
	3'b111:readnum_dec[7]=1'b1;
	
	default:readnum_dec=1'b0;
	endcase
end

always@(*)begin //case statement for wire on/off

	case(write)
		
		1'b1:{B7,B6,B5,B4,B3,B2,B1,B0}=writenum_dec;
		
		default :{B0,B1,B2,B3,B4,B5,B6,B7}=1'b0;
	endcase
end

always@(*)begin	//always block for updating the data_out of the regfile

data_out=1'sb0;

	if(readnum_dec[0]==1'b1)begin
		data_out=R0;
		end
	
	if(readnum_dec[1]==1'b1)begin
	data_out=R1;
	end
	
	if(readnum_dec[2]==1'b1)begin
	data_out=R2;
	end
	
	if(readnum_dec[3]==1'b1)begin
	data_out=R3;
	end
	
	if(readnum_dec[4]==1'b1)begin
	data_out=R4;
	end
	
	if(readnum_dec[5]==1'b1)begin
	data_out=R5;
	end
	
	if(readnum_dec[6]==1'b1)begin
	data_out=R6;
	end
	
	if(readnum_dec[7]==1'b1)begin
	data_out=R7;
	end
	
	
end	

always_ff@(posedge clk)begin
{R0,R1,R2,R3,R4,R5,R6,R7}={R0,R1,R2,R3,R4,R5,R6,R7};  //updating values of R0 to R7 on the clock

	if(B0==1'b1)begin
		R0=data_in;
	end
	
	if(B1==1'b1)begin
		R1=data_in;
	end
	
	if(B2==1'b1)begin
		R2=data_in;
	end
	
	if(B3==1'b1)begin
		R3=data_in;
	end
	
	if(B4==1'b1)begin
		R4=data_in;
	end
	
	if(B5==1'b1)begin
		R5=data_in;
	end
	
	if(B6==1'b1)begin
		R6=data_in;
	end
	
	if(B7==1'b1)begin
		R7=data_in;
	end
end	



	
	
endmodule