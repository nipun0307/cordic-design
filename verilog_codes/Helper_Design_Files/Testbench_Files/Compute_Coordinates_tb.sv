// Code your testbench here
// or browse Examples
`define init 32'd10188016
module testbench();
  
  parameter n=32;
  reg reset;
  reg enable;
  reg clock;
  reg signed [n-1:0] angle_in, x_in, y_in,xo,yo;
  wire signed [n-1:0] x_out, y_out;
  wire done;


  cordic_rotation #(.n(n)) values( x_in, y_in,reset, enable, clock, angle_in, x_out, y_out,done); // Overiding the parameter
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
    //enter decimal input
    xo=1;
    yo=1;
    x_in=32'd10188016*xo;
    y_in=32'd10188016*yo;
    //angle_in = 32'd13176800; //45 degrees
   //angle_in=32'd0;
    //angle_in=32'd39530384; 	//3pi/4
	//angle_in=32'd49779008;	//170 deg
    //angle_in=32'd52707184+32'd13176800; //180+45 degrees
    //angle_in=32'd55635424;	//190 deg
    //angle_in=32'd81988912;	//280 deg
    //angle_in=32'd65883968; 	//5pi/4
    //angle_in=32'd146408896; 	//500+360 deg
    angle_in=32'd1317_6800 + 32'd1_0541_4352; //45+360 deg
    reset = 1'b0;
    enable = 1'b0;
    clock = 1'b0;
    forever #5 clock = ~clock;
	
    end
  
  initial begin
    #7 reset = 1'b1;
    #9 reset = 1'b0;
    #9 enable = 1'b1;
    #400
    x_in=32'd10188016*1;
    y_in=0;
    
    angle_in = 32'd13176800; //45 degrees
    #100
    x_in=32'd10188016*1;
    y_in=32'd10188016*1;
    angle_in = 32'd1317_6800 + 32'd1_0541_4352;
  end
endmodule
