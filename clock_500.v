`define rom_size 6'd8
module CLOCK_500 (
	              CLOCK,
 	              CLOCK_500,
	              DATA,
	              END,
	              RESET,
	              GO,
	              CLOCK_2
                 );
//=======================================================
//  PORT declarations
//=======================================================                
	input  		 	CLOCK;
	input 		 	END;
	input 		 	RESET;
	
	output		    CLOCK_500;
	output 	[23:0]	DATA;
	output 			GO;
	output 			CLOCK_2;

	reg  	[10:0]	COUNTER_500;
	reg  	[15:0]	ROM[`rom_size:0];
	reg  	[15:0]	DATA_A;
	reg  	[5:0]	address;

wire  CLOCK_500=COUNTER_500[9];
wire  CLOCK_2=COUNTER_500[1];
wire [23:0]DATA={8'h34,DATA_A};	
wire  GO =((address <= `rom_size) && (END==1))? COUNTER_500[10]:1;
//=========================================================
// Structural coding
//=========================================================

always @(negedge RESET or posedge END) 
	begin
		if (!RESET)
			begin
				address=0;
			end
		else if (address <= `rom_size)
				begin
					address=address+1;
				end
	end

reg [4:0] vol;
wire [6:0] volume;
always @(posedge RESET) 
	begin
		vol=vol+5;
	end
assign volume = vol+96;
always @(posedge END) 
	begin
	//	ROM[0] = 16'h1e00;
		ROM[0] = 16'h0c00;	    			 //power down
		ROM[1] = 16'h0ec2;	   		    //master
		ROM[2] = 16'h0838;	    			 //sound select
	
		ROM[3] = 16'h1000;					 //mclk
	
		ROM[4] = 16'h0017;					 //
		ROM[5] = 16'h0217;					 //
		ROM[6] = {8'h04,1'b0,volume[6:0]};//
		ROM[7] = {8'h06,1'b0,volume[6:0]};//sound vol
		ROM[`rom_size]= 16'h1201;         //active
		DATA_A=ROM[address];
	end

always @(posedge CLOCK ) 
	begin
		COUNTER_500=COUNTER_500+1;
	end

endmodule
