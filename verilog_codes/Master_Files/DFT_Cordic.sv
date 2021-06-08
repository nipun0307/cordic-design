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


//**IMPORTANT**

// IMPORT THE CORDIC ROTATION MODULE (filename: Compute_Coordinates.sv, Folder: Helper_Design_Files)

//**IMPORTANT**              
              
              
////////////////////////////////////////////////////////////////////////////////

// Angle LUT for computing dft.

`define kj_0  32'b0  //Product of k and j =0;
`define kj_1  32'b0_110010010000111111100000
`define kj_2  32'b01_100100100001111110110000
`define kj_3  32'b010_010110110010111110010000
`define kj_4  32'b011_001001000011111101110000
`define kj_5  32'b011_111011010100111101000000
`define kj_6  32'b0100_101101100101111100100000
`define kj_7  32'b0101_011111110110111100000000
`define kj_8  32'b0110_010010000111111011010000
`define kj_9  32'b0111_000100011000111010110000
`define kj_10 32'b0111_110110100101110100000000
`define kj_12  32'b01001_011011001011111001000000
`define kj_14  32'b01010_111111101101110111110000
`define kj_15  32'b01011_110001111110110111010000
`define kj_16  32'b01100_100100010001010101000000
`define kj_18  32'b01110_001000110001110101100000
`define kj_20  32'b01111_101101010011110100010000
`define kj_21  32'b010000_011111100100110011110000
`define kj_24  32'b010010_110110010111110010000000
`define kj_25  32'b010011_101000101000110001100000
`define kj_28  32'b010101_111111011011101111110000
`define kj_30  32'b010111_100011111101101110100000
`define kj_35  32'b011011_011111010010101011100000
`define kj_36  32'b011100_010001100011101011000000
`define kj_42  32'b0100000_111111001001100111100000
`define kj_49  32'b0100110_011111000000100011100000


module compute_yk(reset, enable, clock, coeff_0,coeff_1,coeff_2,coeff_3,coeff_4,coeff_5,coeff_6,coeff_7,k, cos_out, sin_out);
  parameter n=8;
  
  input reset, enable, clock;
  input [31:0] k;
  input signed[31:0]coeff_0,coeff_1,coeff_2,coeff_3,coeff_4,coeff_5,coeff_6,coeff_7;
  
  output signed [31:0]cos_out, sin_out;
  
  
  wire signed [31:0]temp_y [n-1:0];
  wire signed [31:0]temp_x [n-1:0];
  
  genvar j;
  
  
  //LOGIC: Make angle lut of size j*k. Then call cos,sin fn k times with angle (2*pi*j/n)*k. Mulitply coeff(k) with that sin, cos value and at last add all these terms.
 
  // Angle_lut
  
  wire signed [31:0] angle_lut [49:0];
  assign angle_lut[0] = `kj_0;
  assign angle_lut[1] = `kj_1;
  assign angle_lut[2] = `kj_2;
  assign angle_lut[3] = `kj_3;
  assign angle_lut[4] = `kj_4;
  assign angle_lut[5] = `kj_5;
  assign angle_lut[6] = `kj_6;
  assign angle_lut[7] = `kj_7;
  assign angle_lut[8] = `kj_8;
  assign angle_lut[9] = `kj_9;
  assign angle_lut[10] = `kj_10;
  assign angle_lut[12] = `kj_12;
  assign angle_lut[14] = `kj_14;
  assign angle_lut[15] = `kj_15;
  assign angle_lut[16] = `kj_16;
  assign angle_lut[18] = `kj_18;
  assign angle_lut[20] = `kj_20;
  assign angle_lut[21] = `kj_21;
  assign angle_lut[24] = `kj_24;
  assign angle_lut[25] = `kj_25;
  assign angle_lut[28] = `kj_28;
  assign angle_lut[30] = `kj_30;
  assign angle_lut[35] = `kj_35;
  assign angle_lut[36] = `kj_36;
  assign angle_lut[42] = `kj_42;
  assign angle_lut[49] = `kj_49;
  
  wire signed [31:0] coeff_lut [0:7];
  assign coeff_lut[0] = coeff_0 ;
  assign coeff_lut[1] = coeff_1 ;
  assign coeff_lut[2] = coeff_2 ;
  assign coeff_lut[3] = coeff_3 ;
  assign coeff_lut[4] = coeff_4 ;
  assign coeff_lut[5] = coeff_5 ;
  assign coeff_lut[6] = coeff_6 ;
  assign coeff_lut[7] = coeff_7 ;
  
  wire [31:0] index [7:0];
  assign index[0] = 32'b0;
  assign index[1] = k;
  assign index[2] = index[1]+k;
  assign index[3] = index[2]+k;
  assign index[4] = index[3]+k;
  assign index[5] = index[4]+k;
  assign index[6] = index[5]+k;
  assign index[7] = index[6]+k;
  
  
  
  //parameter indexes[8]= {'b0, 'b
  
  // COMPUTATION PART
  
  generate
    for(j=0;j<n;j=j+1) 
      begin: add_coeff
        cordic_rotation term_j( coeff_lut[j]*`init, 32'b0, reset, enable, clock, 32'd105414352-angle_lut[index[j]], temp_x[j], temp_y[j]); // angle_in = 360 degree+neg angle
        
      end
  endgenerate
  
   assign cos_out = temp_x[0]+temp_x[1]+temp_x[2]+temp_x[3]+temp_x[4]+temp_x[5]+temp_x[6]+temp_x[7];
  assign sin_out = temp_y[0]+temp_y[1]+temp_y[2]+temp_y[3]+temp_y[4]+temp_y[5]+temp_y[6]+temp_y[7];
  
// Then return this to main fn: dft_forward  
        
endmodule  

////////////////////////////////////////////////////////////////////////////////
      
module dft_forward( reset, enable, clock, coeff_0,coeff_1,coeff_2,coeff_3,coeff_4,coeff_5,coeff_6,coeff_7, yk_cos_out_0, yk_cos_out_1, yk_cos_out_2, yk_cos_out_3,yk_cos_out_4,yk_cos_out_5,yk_cos_out_6,yk_cos_out_7, yk_sin_out_0,yk_sin_out_1,yk_sin_out_2,yk_sin_out_3,yk_sin_out_4,yk_sin_out_5,yk_sin_out_6,yk_sin_out_7);
  
  parameter n=8;
  input reset, enable, clock;
  input signed[31:0]coeff_0,coeff_1,coeff_2,coeff_3,coeff_4,coeff_5,coeff_6,coeff_7;
  
  wire [31:0]index [7:0];
  assign index[0]= 32'd0;
  assign index[1]= 32'd1;
  assign index[2]= 32'd2;
  assign index[3]= 32'd3;
  assign index[4]= 32'd4;
  assign index[5]= 32'd5;
  assign index[6]= 32'd6;
  assign index[7]= 32'd7;
  
  
  output signed[31:0] yk_cos_out_0, yk_cos_out_1, yk_cos_out_2, yk_cos_out_3,yk_cos_out_4,yk_cos_out_5,yk_cos_out_6,yk_cos_out_7, yk_sin_out_0,yk_sin_out_1,yk_sin_out_2,yk_sin_out_3,yk_sin_out_4,yk_sin_out_5,yk_sin_out_6,yk_sin_out_7;
  
  wire [31:0] cos_output_wires [7:0];
  assign yk_cos_out_0= cos_output_wires[0];
  assign yk_cos_out_1= cos_output_wires[1];
  assign yk_cos_out_2= cos_output_wires[2];
  assign yk_cos_out_3= cos_output_wires[3];
  assign yk_cos_out_4= cos_output_wires[4];
  assign yk_cos_out_5= cos_output_wires[5];
  assign yk_cos_out_6= cos_output_wires[6];
  assign yk_cos_out_7= cos_output_wires[7];
  
  wire [31:0] sin_output_wires [7:0];
  assign yk_sin_out_0= sin_output_wires[0];
  assign yk_sin_out_1= sin_output_wires[1];
  assign yk_sin_out_2= sin_output_wires[2];
  assign yk_sin_out_3= sin_output_wires[3];
  assign yk_sin_out_4= sin_output_wires[4];
  assign yk_sin_out_5= sin_output_wires[5];
  assign yk_sin_out_6= sin_output_wires[6];
  assign yk_sin_out_7= sin_output_wires[7];
 
  
   
  
  genvar k;
  generate 
  for(k=0;k<n;k=k+1) 
    begin: fft_transform
    
      compute_yk yk(reset, enable, clock, coeff_0,coeff_1,coeff_2,coeff_3,coeff_4,coeff_5,coeff_6,coeff_7,index[k], cos_output_wires[k], sin_output_wires[k]);
      
      
    end
  endgenerate
  
  
  
endmodule
      
////////////////////////////////////////////
