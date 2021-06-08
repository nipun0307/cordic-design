// Code your design here
`define i_0  32'd13176800  // = atan 2^0     = 0.7853981633974483
`define i_1  32'd07778720  // = atan 2^(-1)  = 0.4636476090008061
`define i_2  32'd04110064  // = atan 2^(-2)  = 0.24497866312686414
`define i_3  32'd02086336  // = atan 2^(-3)  = 0.12435499454676144
`define i_4  32'd01047216  // = atan 2^(-4)  = 0.06241880999595735
`define i_5  32'd00524112  // = atan 2^(-5)  = 0.031239833430268277
`define i_6  32'd00262128  // = atan 2^(-6)  = 0.015623728620476831
`define i_7  32'd00131072  // = atan 2^(-7)  = 0.007812341060101111
`define i_8  32'd00065536  // = atan 2^(-8)  = 0.0039062301319669718
`define i_9  32'd00032768  // = atan 2^(-9)  = 0.0019531225164788188
`define i_10 32'd00016384  // = atan 2^(-10) = 0.0009765621895593195
`define i_11 32'd00008192  // = atan 2^(-11) = 0.0004882812111948983
`define i_12 32'd00004096  // = atan 2^(-12) = 0.00024414062014936177
`define i_13 32'd00002048  // = atan 2^(-13) = 0.00012207031189367021
`define i_14 32'd00001024  // = atan 2^(-14) = 6.103515617420877e-05
`define i_15 32'd00000512  // = atan 2^(-15) = 3.0517578115526096e-05
`define i_16 32'd00000256  // = atan 2^(-16) = 1.5258789061315762e-05
`define i_17 32'd00000128  // = atan 2^(-17) = 7.62939453110197e-06
`define i_18 32'd00000064  // = atan 2^(-18) = 3.814697265606496e-06
`define i_19 32'd00000032  // = atan 2^(-19) = 1.907348632810187e-06
`define i_20 32'd00000016  // = atan 2^(-20) = 9.536743164059608e-07
`define i_21 32'd00000008  // = atan 2^(-21) = 4.7683715820308884e-07
`define i_22 32'd00000004  // = atan 2^(-22) = 2.3841857910155797e-07
`define i_23 32'd00000002  // = atan 2^(-23) = 1.1920928955078068e-07
`define i_24 32'd00000001  // = atan 2^(-24) = 5.960464477539055e-08
`define i_25 32'd00000000  // = atan 2^(-25) = 2.9802322387695303e-08

`define init 32'd10188016


///////////////////////////////////////////////////////////////////////////////

//STAGE 1: DECLARING ALL THE NETS AND REG AND CONNECTING THE WIRES

// For i=[0,31] Cordic gain An=1.646760. So, initial value of cos theta will be init = 1/An = 0.6072529350088814.
`define init 32'd10188016

// **IMPORTANT**

// IMPORT COORDIC ROTATION Module (filename: Compute_coordinate.sv , foldername: Helper_Design_Files)

// **IMPORTANT**
              
//////////////////////////////////////////////////////////////////////////////////////////////////

//Compute_sum

module compute_sum(reset, enable, clock, text, pattern, i, flag);
  
 parameter m=4;
  parameter n=16;
  input reset, enable, clock;
  input [0:n-1]text;
  input [0:m-1]pattern;
  input [31:0]i;
  output flag;
  
  reg temp_flag;
  assign flag=temp_flag;
  
  reg [31:0] text_angle [0:n-1];
  reg [31:0] pattern_angle[0:m-1];
  wire signed [31:0] cos[0:m-1];
  wire signed [31:0] sin[0:n-1];
  
  
  integer index;
  always@(text) begin //Text_angle
    
    for(index=0;index<n;index=index+1) begin
      if(text[index]==0) text_angle[index]=32'b0;  
      else text_angle[index]=32'd52707184;     
    end
    
  end
  
  always@(pattern)begin //Pattern_angle
    
    for(index=0;index<m;index=index+1) begin
      if(pattern[index]==0) pattern_angle[index]=32'b0;
      else pattern_angle[index]=32'd52707184;
    end
    
  end    
  
  wire [31:0] to_call [m-1:0];
  assign to_call[0]=i;
  assign to_call[1]=i+32'd1;
  assign to_call[2]=i+32'd2;
  assign to_call[3]=i+32'd3;
   
  genvar j;
  generate
    
    for(j=0;j<m;j=j+1)
      begin: cos_sin_j
        
        cordic_rotation compute_j(`init,0, reset, enable, clock, text_angle[to_call[j]]-pattern_angle[j]+32'd105414352, cos[j],sin[j]);
      end
  endgenerate
  
  always@(cos[0] || cos[1] || cos[2] || cos[3])begin
    $display("%0b %0b %0b %0b at i=%0d",cos[0],cos[1],cos[2], cos[3],i);
  end

        
wire signed [31:0]reg_check_cos;
  assign reg_check_cos= cos[0]+cos[1]+cos[2]+cos[3];

  always@(*) begin //To check if sum of all cos component =3 then flag=1 else flag=0 ie pattern doesn't exist at that index
    $display("%32d",reg_check_cos);
    if (reg_check_cos[26]==1 && reg_check_cos[25]==0 && reg_check_cos[24]==0 && reg_check_cos[31]==0) temp_flag=1'b1;
    else temp_flag=1'b0;
  end
  
endmodule



////////////////////////////////////////////////////////////////////////////////



      
// Pattern matching; 3 bit pattern, 7 bit text

module pattern_match( reset, enable, clock, text, pattern, flag);
  
  parameter m=4;
  parameter n=16;
  input reset, enable, clock;
  input [0:n-1]text;
  input [0:m-1]pattern;
  
  output [0:n-1]flag;
  reg [0:n-1]flag_reg;
  assign flag=flag_reg;
  always@(text) begin
    integer index;
    for(index=n-1;index>n-m;index=index-1)begin
      flag_reg[index]=1'b0;
    end
  end
          
  genvar i;
  
  // compute sum: output=flag
  
  generate
    
    for(i=0;i<=n-m;i=i+1)
      begin: check_at_index
        
        compute_sum at_i(reset, enable, clock, text, pattern, i, flag_reg[i]);
        
      end
  endgenerate
endmodule
