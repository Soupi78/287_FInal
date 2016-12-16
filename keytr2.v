`define  OUT_BIT  9
module keytr2 (
				key,
				key1,
				ON,
				clock,
				KEYON,
				counter	
			 );

//=======================================================
//  PORT declarations
//=======================================================			 
input	           key;
input           key1;
input	         clock;

output	           ON;
output           KEYON;
output  [9:0]  counter;


reg     [9:0]  counter;
reg              KEYON;
wire ON =((counter[`OUT_BIT]==1) && (key==0))?0:1; 
//=============================================================================
// Structural coding
//=============================================================================
always @(negedge ON or posedge clock) 
	begin
		if (!ON)
			begin
				counter=0;
			end 
		else if (counter[`OUT_BIT]==0)
				begin
					counter=counter+1;
				end	
	end

always @(posedge clock) 
	begin
		if  ((counter>=1) && (counter <5))
			begin
				KEYON=0;
			end
		else begin	
				KEYON=1;
			 end
	end
///debounce starts
reg [3:0] sw;
reg flag,D1,D2;
reg [15:0] delay;
//falling edge detect,
always@(negedge clock)
begin
  if (flag)
     sw<={key,sw[3:1]};
end
assign falling_edge = (sw==4'b0011)?1'b1:1'b0;
////////////
always@(posedge clock,negedge key1)
begin
  if (!key1)
     flag<=1'b1;
  else if (delay==15'd4096)////modify the value here for a better debounce effect when using a high clock frequency; 4096
     flag<=1'b1;
  else if (falling_edge)
     flag<=1'b0;
end
//
always@(posedge clock)
begin
  if (!key)
     delay<=delay+1;
  else
     delay<=15'd0;
end
///debounce over!
/////////////////////////////////////////
///////////?????
always@(negedge clock)
begin
  D1<=flag;
  D2<=D1;
end
//assign KEYON = (D1 | !D2);
endmodule	