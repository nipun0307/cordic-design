// Uses the helper files to do all the work based on a regulating 2 bit wire that determines the function


// **IMPORTANT** Make sure that you have downloaded the helper files before running this file or you will run into major errors

module master_cordic(clock, reset, enable, select, x_in, y_in, angle_in, x_out, y_out);
  
  parameter n=32;
  input reset, enable, clock;
  input [1:0] select;
  reg en_reg [0:3];
  wire en [0:3];
  input [n-1:0] x_in, y_in, angle_in;
  reg [n-1:0] x_out_reg, y_out_reg, sin_out_reg, cos_out_reg, angle_out_reg, log_out_reg, x_out_f, y_out_f;
  output [n-1:0] x_out, y_out;
  
  assign x_out=x_out_f;
  assign y_out=y_out_f;
  
  assign en[0]=en_reg[0];
  assign en[1]=en_reg[1];
  assign en[2]=en_reg[2];
  assign en[3]=en_reg[3];
  
  computelog ins1 (.clk(clock), .en(en[3]),.arg(angle_in), .log_out(log_out_reg), .reset(reset));
  
  cordic_angle ins2 (clock, reset,en[2], x_in,y_in, angle_out_reg);
  
  cordic_rotation ins3 ( x_in, y_in, reset, en[1], clock, angle_in, x_out_reg, y_out_reg);
  
  cordic_sin_cos ins4 ( reset, en[0], clock, angle_in, cos_out_reg, sin_out_reg);
  
  always @(posedge clock, posedge reset)
    begin
      if (reset)
        begin
          en_reg[0]<=0;
          en_reg[1]<=0;
          en_reg[2]<=0;
          en_reg[3]<=0;
          x_out_f<=0;
          y_out_f<=0;
        end
      else if (enable==1) begin
        if (select==3)	//LOG
          begin
            en_reg[3]<=1;
            x_out_f<=log_out_reg;
            y_out_f<='bx;
          end
        else if (select==2)	//ANGLE COMPUTATION
          begin
            en_reg[2]<=1;
            x_out_f<=angle_out_reg;
            y_out_f<='bx;
          end
        else if (select==1)	//COORDINATE ROTATION
          begin
            en_reg[1]<=1;
            x_out_f<=x_out_reg;
            y_out_f<=y_out_reg;
          end
        else if (select ==0)	//SINE COSINE 
          begin
          	en_reg[0]<=1;
          	x_out_f<=cos_out_reg;
            y_out_f<=sin_out_reg;
          end
        else
          begin
            x_out_f<='bz;
            y_out_f<='bz;
          end
      end
    end
  
  //if en==0; do nothing
  // now there will be many registers=> 4 en registers, 4 en wires 
  /*
 en is dependent on the select line
 
 The input is fed to ALL the modules
 
 Declare 6 output registers + 2 final output registers
 
 These 6 registers will be assigned to the modules
 and these final 2 regs will be assigned wrt select
 
 these 3 regs are assigned to the wires.
  */
  
endmodule

//THE WRITING AND READING FORMAT IS SIGNED [32 24]

`define i_0  32'd18574864  // = atan 2^(1)
`define i_1  32'd13176800  // = atan 2^0     = 0.7853981633974483
`define i_2  32'd07778720  // = atan 2^(-1)  = 0.4636476090008061
`define i_3  32'd04110064  // = atan 2^(-2)  = 0.24497866312686414
`define i_4  32'd02086336  // = atan 2^(-3)  = 0.12435499454676144
`define i_5  32'd01047216  // = atan 2^(-4)  = 0.06241880999595735
`define i_6  32'd00524112  // = atan 2^(-5)  = 0.031239833430268277
`define i_7  32'd00262128  // = atan 2^(-6)  = 0.015623728620476831
`define i_8  32'd00131072  // = atan 2^(-7)  = 0.007812341060101111
`define i_9  32'd00065536  // = atan 2^(-8)  = 0.0039062301319669718
`define i_10 32'd00032768  // = atan 2^(-9)  = 0.0019531225164788188
`define i_11 32'd00016384  // = atan 2^(-10) = 0.0009765621895593195
`define i_12 32'd00008192  // = atan 2^(-11) = 0.0004882812111948983
`define i_13 32'd00004096  // = atan 2^(-12) = 0.00024414062014936177
`define i_14 32'd00002048  // = atan 2^(-13) = 0.00012207031189367021
`define i_15 32'd00001024  // = atan 2^(-14) = 6.103515617420877e-05
`define i_16 32'd00000512  // = atan 2^(-15) = 3.0517578115526096e-05
`define i_17 32'd00000256  // = atan 2^(-16) = 1.5258789061315762e-05
`define i_18 32'd00000128  // = atan 2^(-17) = 7.62939453110197e-06
`define i_19 32'd00000064  // = atan 2^(-18) = 3.814697265606496e-06
`define i_20 32'd00000032  // = atan 2^(-19) = 1.907348632810187e-06
`define i_21 32'd00000016  // = atan 2^(-20) = 9.536743164059608e-07
`define i_22 32'd00000008  // = atan 2^(-21) = 4.7683715820308884e-07
`define i_23 32'd00000004  // = atan 2^(-22) = 2.3841857910155797e-07
`define i_24 32'd00000002  // = atan 2^(-23) = 1.1920928955078068e-07
`define i_25 32'd00000001  // = atan 2^(-24) = 5.960464477539055e-08
`define i_26 32'd00000000  // = atan 2^(-25) = 2.9802322387695303e-08

    
