module TEST (
				BCLK,
				ADC,
				DAC
			 );
//=======================================================
input	           BCLK;
input            ADC;

reg  			     tmp;
output	        DAC;

always@(negedge BCLK)
begin
tmp = ADC;
  if (ADC == 1)
     tmp <= tmp + ADC;
  else
	  tmp <= ADC + tmp;
  tmp <= DAC;
end
endmodule