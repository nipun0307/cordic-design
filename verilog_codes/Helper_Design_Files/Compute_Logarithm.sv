// Outputs the logarithmic value of the input on a 32 bit bus
// Code your design here

//Natural Logarithm using CORDIC (expanded inverse hyperbolic algorithm)

module computelog(clk, arg, hyperbolic, reset);
  
  //Inputs
  parameter width=32;
  input clk;
  input signed [width-1:0] arg;
  input reset;
  wire signed [width-1:0] angle;
  wire signed [width-1:0] x, y;
  //log(arg)=2*arctanh((arg-1)/(arg+1))
  assign y=arg-32'd16777216;
  assign x=arg+32'd16777216;
  
  //Output
  output signed [width-1:0] hyperbolic;
  
  //The LUT comprises of hyperbolic inverse values
  wire signed [width-1:0] lut [0:31]; //There are 21 values in LUT with each having width 32
  
  //For values of lut [00] to lut[04], the values are for arctanh(1-2^(i-2)) where i ranges from -4 to 0
  //Post lut[03] (excluding) the values correspond to arctanh(2^(-i)) where i ranges from 1 to 20 including
  //The format is [32 24]
  
  assign lut[00]=32'd40635984;
  assign lut[01]=32'd34755136;
  assign lut[02]=32'd28806368;
  assign lut[03]=32'd22716768;
  assign lut[04]=32'd16323472;
  assign lut[05]=32'd09215824;
  assign lut[06]=32'd04285120;
  assign lut[07]=32'd02108176;
  assign lut[08]=32'd01049952;
  assign lut[09]=32'd00524464;
  assign lut[10]=32'd00262160;
  assign lut[11]=32'd00131072;
  assign lut[12]=32'd00065536;
  assign lut[13]=32'd00032768;
  assign lut[14]=32'd00016384;
  assign lut[15]=32'd00008192;
  assign lut[16]=32'd00004096;
  assign lut[17]=32'd00002048;
  assign lut[18]=32'd00001024;
  assign lut[19]=32'd00000512;
  assign lut[20]=32'd00000256;
  assign lut[21]=32'd00000128;
  assign lut[22]=32'd00000064;
  assign lut[23]=32'd00000032;
  assign lut[24]=32'd00000016;

  
  reg signed [width-1:0] angle_reg, x_reg, y_reg;
  integer signed count=-4;
  
  always@(*)
    if (arg<=32'h0) begin
      $display("invalid");
      $finish;
         end
  
  
  wire d;	//d determines the rotation
  assign d=y_reg[width-1];	//the rotation depends on sign of y
  
  assign hyperbolic=angle_reg<<<1;
  
  initial begin
    angle_reg<=angle;
    x_reg<=x;
    y_reg<=y;
  end
  
 // initial begin
  //  $monitor($time,,arg,,y_reg,,x_reg,, y_next,, angle_next,, d,,hyperbolic,, count);
  //end
  
  
  always@(posedge clk,posedge reset)
    if (reset)
        begin
          x_reg<=x;
          y_reg<=y;
          angle_reg<=0;
        end
    else begin
     
      if (count<=0)
        begin
          x_reg<=~d? x_reg-y_reg+(y_reg>>>(-count+2)) : x_reg+y_reg-(y_reg>>>(-count+2));
          y_reg<=~d? y_reg-x_reg+(x_reg>>>(-count+2)) : y_reg+x_reg-(x_reg>>>(-count+2));
          angle_reg<=~d? angle_reg+lut[count+4] : angle_reg-lut[count+4];
          count<=count+1;
        end
      else if (count>0 && count<=20)
        begin
          x_reg<=~d? x_reg-(y_reg>>>count) : x_reg+(y_reg>>>count);
          y_reg<=~d? y_reg-(x_reg>>>count) : y_reg+(x_reg>>>count);
          angle_reg<=~d? angle_reg+lut[count+4] : angle_reg-lut[count+4];
          count<=count+1;
        end
      if(count>=20) begin
        $display("The CORDIC Logarithm value is: %d", hyperbolic);
        $finish;
      end
    
    end
  
  
  
endmodule
