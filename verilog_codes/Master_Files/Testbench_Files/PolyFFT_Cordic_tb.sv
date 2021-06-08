// Code your testbench here
// or browse Examples
module testbench();
  reg clk, en, reset;
  reg signed [31:0] x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6,y7;
  wire signed [31:0] xout0,xout1,xout2,xout3,xout4,xout5,xout6,xout7,yout0,yout1,yout2,yout3,yout4,yout5,yout6,yout7;
  
  fft instance1 (clk,reset, en,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6,y7,xout0,xout1,xout2,xout3,xout4,xout5,xout6,xout7,yout0,yout1,yout2,yout3,yout4,yout5,yout6,yout7);
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
    x0=32'd10188016*2;
    x1=32'd10188016*4;
    x2=0;
    x3=0;
    x4=32'd10188016*4;
    x5=0;
    x6=0;
    x7=32'd10188016*5;
    
    y0=32'd10188016*0;
    y1=0;
    y2=0;
    y3=0;
    y4=0;
    y5=0;
    y6=0;
    y7=32'd10188016*0;
    reset =1'b1;
    en=1'b0;
    clk=1'b0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    #7 reset = 1'b1;
    #9 reset = 1'b0;
    #9 en = 1'b1;
  end
  
endmodule
