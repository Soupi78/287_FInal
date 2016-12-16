module keytr (
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
input            key1;
input	         clock;

output	            ON;
output           KEYON;
output  [9:0]  counter;


reg     [9:0]  counter;

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
  else if (delay==15'd4096) //modify the value here for a better debounce
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
///debounce over
//////////////
always@(negedge clock)
begin
  D1<=flag;
  D2<=D1;
end
assign KEYON = (D1 | !D2);
endmodule	