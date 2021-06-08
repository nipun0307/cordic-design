module testbench();
  
  parameter n=32;
  reg reset;
  reg enable;
  reg clock;
  reg signed [n-1:0] x_in, y_in;
  wire signed [n-1:0] angle_out;
  
  cordic_angle instanc(clock, reset, enable, x_in, y_in, angle_out);
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
    //x=3, y=4
    //rep [32 24]
    //decimal 1.00 = 32'd16777216
    x_in = 32'd16777216*3;
    y_in = 32'd16777216*3;
    
    enable = 1'b0;
    clock = 1'b0;
    reset = 1'b0;
   
    
    forever #5 clock = ~clock;
  end
  
  initial begin
 	#7 reset = 1'b1;
    #9 reset = 1'b0;
    #9 enable=1'b1;
  end
  
  
  
endmodule
