// Takes in one 2D coordinate and an angle. Outputs the new coordinates
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

module cordic_angle (clock, reset, enable, x_in, y_in, angle_out);
  
  parameter n=32;
  input clock, reset, enable;
  input signed [n-1:0] x_in, y_in;
  output reg signed [n-1:0] angle_out;
  reg done;
  integer signed count=-1;
  reg signed [n-1:0] x, y, angle;
  //reg state, state_next;
  
  //
  wire is_neg = y[31];
  assign angle_out = angle;
  //
  
  wire [n-1:0] lut [n-1:0];
      assign lut[0] = `i_0;
      assign lut[1] = `i_1;
      assign lut[2] = `i_2;
      assign lut[3] = `i_3;
      assign lut[4] = `i_4;
      assign lut[5] = `i_5;
      assign lut[6] = `i_6;
      assign lut[7] = `i_7;
      assign lut[8] = `i_8;
      assign lut[9] = `i_9;
      assign lut[10] = `i_10;
      assign lut[11] = `i_11;
      assign lut[12] = `i_12;
      assign lut[13] = `i_13;
      assign lut[14] = `i_14;
      assign lut[15] = `i_15;
      assign lut[16] = `i_16;
      assign lut[17] = `i_17;
      assign lut[18] = `i_18;
      assign lut[19] = `i_19;
      assign lut[20] = `i_20;
      assign lut[21] = `i_21;
      assign lut[22] = `i_22;
      assign lut[23] = `i_23;
      assign lut[24] = `i_24;
      assign lut[25] = `i_25;
      assign lut[26] = `i_26;
     
  
 /* always @(posedge clock, posedge reset) begin
    if(reset) begin
      x <=x_in;
      y <= y_in;
      angle <= 0;
    end
    
  end*/
  
  always @(posedge clock, posedge reset) begin 
    if(reset) begin
      if(x_in[n-1]==0) begin
      	x <=x_in;
      	y <= y_in;
      	angle <= 0;
      end
      else if(x_in[n-1]==1 && y_in[n-1]==0) begin	
      	x <=y_in;
      	y <=~x_in;
      	angle <=32'd26353584;
      end
      else if(x_in[n-1]==1 && y_in[n-1]==1) begin	
      	x <=~x_in;
      	y <= ~y_in;
      	angle <=-32'd52707184;
      end
      done<=0;
    end
    else if (done==0)begin
    if(count<=-1) begin
      x <=is_neg ? x-(y<<<(-count)) : x+(y<<<(-count));
      y<=is_neg ? y+(x<<<(-count)) : y-(x<<<(-count));
      angle<= is_neg ? angle-lut[count+1] : angle+lut[count+1];
	  count<= count + 1;

    end
    
    else if(count>=0 && count<=24) begin
      x <=is_neg ? x-(y>>>(count)) : x+(y>>>(count));
      y <=is_neg ? y+(x>>>(count)) : y-(x>>>(count));
      angle <= is_neg ? angle-lut[count+1] : angle+lut[count+1];
	  count<= count + 1;

    end

    else if (count>=24) begin
      $display("The final angle is:" ,angle_out);
      //$display("The value ofy_final is:", y_next);
      done<=1;
      //$finish;
      end
   
    end
  end
  
endmodule
