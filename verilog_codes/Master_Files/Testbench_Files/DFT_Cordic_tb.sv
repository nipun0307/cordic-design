// Code your testbench here
// or browse Examples
`define init 32'd10188016
module testbench();
  
  parameter n=8;
  reg reset;
  reg enable;
  reg clock;
  reg signed[31:0]coeff_0,coeff_1,coeff_2,coeff_3,coeff_4,coeff_5,coeff_6,coeff_7;
  
  wire signed [31:0] yk_cos_out_0, yk_cos_out_1, yk_cos_out_2, yk_cos_out_3,yk_cos_out_4,yk_cos_out_5,yk_cos_out_6,yk_cos_out_7, yk_sin_out_0,yk_sin_out_1,yk_sin_out_2,yk_sin_out_3,yk_sin_out_4,yk_sin_out_5,yk_sin_out_6,yk_sin_out_7;
  


  dft_forward values(reset, enable, clock, coeff_0,coeff_1,coeff_2,coeff_3,coeff_4,coeff_5,coeff_6,coeff_7, yk_cos_out_0, yk_cos_out_1, yk_cos_out_2, yk_cos_out_3,yk_cos_out_4,yk_cos_out_5,yk_cos_out_6,yk_cos_out_7, yk_sin_out_0,yk_sin_out_1,yk_sin_out_2,yk_sin_out_3,yk_sin_out_4,yk_sin_out_5,yk_sin_out_6,yk_sin_out_7); 
  
  initial begin
    
        $dumpfile("dump.vcd");
    $dumpvars(1);
    //enter decimal input
    coeff_0=2;
    coeff_1=4;
    coeff_2=0;
    coeff_3=0;
    coeff_4=0;
    coeff_5=0;
    coeff_6=0;
    coeff_7=0;
            
    //angle_in = 32'd13176800; //45 degrees
   //angle_in=32'd0;
    //angle_in=32'd39530384; 	//3pi/4
	//angle_in=32'd49779008;	//170 deg
    //angle_in=32'd55635424;	//190 deg
    //angle_in=32'd81988912;	//280 deg
    //angle_in=32'd65883968; 	//5pi/4
    //angle_in=32'd146408896+ 32'd105414352; 	//500+360 deg
    //angle_in=32'd13176800 + 32'd105414352; //45+360 deg
    reset = 1'b0;
    enable = 1'b0;
    clock = 1'b0;
    forever #5 clock = ~clock;
	
    end
  
  initial begin
    #7 reset = 1'b1;
    #9 reset = 1'b0;
    #9 enable = 1'b1;
  end
endmodule
