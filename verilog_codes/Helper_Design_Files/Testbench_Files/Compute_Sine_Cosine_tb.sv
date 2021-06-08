// Code your testbench here
// or browse Examples
module testbench();
  
  parameter n=32;
  reg reset;
  reg enable;
  reg clock;
  reg signed [n-1:0] angle_in;
  wire signed [n-1:0] cos_out;
  wire signed [n-1:0] sin_out;

  cordic_sin_cos #(.n(n)) values( reset, enable, clock, angle_in, cos_out, sin_out); // Overiding the parameter
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
    //angle_in = 32'd13176800; //45 degrees
   //angle_in=32'd0;
    //angle_in=32'd39530384; //3pi/4
	//angle_in=32'd49779008;	//170 deg
    //angle_in=32'd55635424;	//190 deg
    angle_in=32'd81988912;	//280 deg
    //angle_in=32'd102486144; //350 deg
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



