// Code your testbench here
// or browse Examples
module textbench;
  
  parameter width=32;
  reg clk, reset;
  reg signed [width-1:0] arg;
  wire signed [width-1:0] hyperbolic;
  
  computelog instance1 (.clk(clk), .arg(arg), .hyperbolic(hyperbolic), .reset(reset));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
    reset='b1;
    //$display(,,,,"arg	",,"	y_reg	",,"x_reg	",,"	y_next	",,"angle_next	",,"d	",,"	hyperbolic	",,"count");
    //format for input is [32 24]; 7 bits are there for integer (6 bits for magnitude)
    //format for decimal 1.00=32'd16777216
    //this can be conviniently multiplied with any integer for the input
    arg= 32'd1677721600;	//arg=100
	
    //arg=32'd8388608; //arg=0.5
    clk=1'b0;
    forever #5 clk=~clk;
  end
  
  initial begin
  	#11 reset='b0;
    //$monitor("%d %h %h",$time,, hyperbolic,, angle);
    
  end

endmodule
