module testbench();
  
  parameter n=32;
  reg reset;
  reg enable;
  reg clock;
  reg [1:0] select;
  reg signed [n-1:0] x_in, y_in, angle_in;
  wire signed [n-1:0] x_out, y_out;
  

  master_cordic inst1 (clock, reset, enable, select, x_in, y_in, angle_in, x_out, y_out);
  
  //cordic_angle instanc(clock, reset, enable, x_in, y_in, angle_out);
  
  //master_cordic instance1(clock, reset, enable, select, x_in, y_in, angle_in, log_in, angle_out, x_out, y_out, log_out, sin_out, cos_out);
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
    
    enable = 1'b0;
    clock = 1'b0;
    reset = 1'b1;
    
  //input to check sine cosine
    select = 2'b00;
    x_in = 32'd13176800; y_in = 32'd13176800;
    angle_in = 32'd16777216*0;
  //
    
    forever #5 clock = ~clock;
  end
  
  initial begin
 	reset = 1'b1;
    enable='b1;
    #9 reset = 1'b0;
 	#300
    select = 2'b10; //angle computation
  end
endmodule
