// Code your design here
// Representation [32 24]

module fft(clk,reset, en,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6,y7,xout0,xout1,xout2,xout3,xout4,xout5,xout6,xout7,yout0,yout1,yout2,yout3,yout4,yout5,yout6,yout7);
  
  parameter n=32;
  input clk,en, reset;
  input signed [31:0] x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6,y7;
  output signed [31:0] xout0,xout1,xout2,xout3,xout4,xout5,xout6,xout7,yout0,yout1,yout2,yout3,yout4,yout5,yout6,yout7;
  
  wire signed [31:0] we [0:10];
  wire signed [31:0] ime [0:10];
  
  //wo[0]=we[4].... wo[3]=we[7]
  //imo[0]=ime[4];
  
  assign we[0]=x0+x2+x4+x6;
  assign ime[0]=y0+y2+y4+y6;
  assign we[4]=x1+x3+x5+x7;
  assign ime[4]=y1+y3+y5+y7;
  assign we[1]=x0-x4; //same as we3_1
  assign ime[1]=y0-y4;	//same as ime3_1
  assign we[2]=x2-x6;	//same as we3_2
  assign ime[2]=y2-y6;
  assign we[5]=x1-x5;	//same as wo3_1
  assign ime[5]=y1-y5;
  assign we[6]=x3-x7;	//same as wo3_2
  assign ime[6]=y3-y7;
  assign we[3]=x0-x2+x4-x6;
  assign ime[3]=y0-y2+y4-y6;
  assign we[7]=x1-x3+x5-x7;
  assign ime[7]=y1-y3+y5-y7;
  assign we[8]=x2-x6;
  assign ime[8]=y2-y6;
  assign we[9]=x1-x5;	//same as wo3_1
  assign ime[9]=y1-y5;
  assign we[10]=x3-x7;	//same as wo3_2
  assign ime[10]=y3-y7;
  
  wire signed [31:0] store_angle [0:10]; //only 4 angles have to be stored
  /*
  assign store_angle[0]=32'd92237568;	//(w_8)^1 = -pi/4= 7pi/4
  assign store_angle[1]=32'd79060768;	//(w_8)^2= -pi/2 = 3pi/2
  assign store_angle[2]=32'd65883968;	//(w_8)^3= -3pi/4 =5pi/4
  assign store_angle[3]=32'd39530384;	//(w_8)^(-3)=3pi/4
  */
  assign store_angle[0]=0;	//(w_8)^1 = -pi/4= 7pi/4
  assign store_angle[1]=0;
  assign store_angle[2]=32'd79060768;
  assign store_angle[3]=0;
  assign store_angle[4]=0;	//(w_8)^2= -pi/2 = 3pi/2
  assign store_angle[5]=32'd92237568;
  assign store_angle[6]=32'd65883968;
  assign store_angle[7]=32'd79060768;
  assign store_angle[8]=32'd79060768;
  assign store_angle[9]=32'd65883968;	//(w_8)^3= -3pi/4 =5pi/4
  assign store_angle[10]=32'd39530384;
  
  
  //sets of wire that do the rotation
  integer i=0;
  wire done;
  reg signed [31:0] rot_x [0:10];
  reg signed [31:0] rot_y [0:10];
  wire signed [31:0] outx, outy;
  

  always @(done)
  begin
    if (done==1) begin
  i<=i+1;
  rot_x[i]<=outx;
  rot_y[i]<=outy;
      end
    $display(i, rot_x[i], rot_y[i]);
  end
  
cordic_rotation ins1 (we[i], ime[i], reset, en, clk, store_angle[i], outx, outy, done);
  
  
//>1; 0->2; 1->5; 2->6; 9->3; 3->7; 4->8 
  assign xout0=rot_x[0]+rot_x[4];
  assign yout0=rot_y[0]+rot_y[4];
  //X(1)
  assign xout1=rot_x[1]+rot_x[2]+rot_x[5]+rot_x[6];
  assign yout1=rot_y[1]+rot_y[2]+rot_y[5]+rot_y[6];
  //X(2)
  assign xout2=rot_x[3]+rot_x[7];
  assign yout2=rot_y[3]+rot_y[7];
  //X(3)
  assign xout3=rot_x[1]-rot_x[8]+rot_x[9]-rot_x[10];
  assign yout3=rot_y[1]-rot_y[8]+rot_y[9]-rot_y[10];
  //X(4)
  assign xout4=rot_x[0]-rot_x[4];
  assign yout4=rot_y[0]-rot_y[4];
  //X(5)
  assign xout5=rot_x[1]+rot_x[0]-rot_x[5]-rot_x[7];
  assign yout5=rot_y[1]+rot_y[0]-rot_y[5]-rot_y[7];
  //X(6)
  assign xout6=rot_x[3]-rot_x[7];
  assign yout6=rot_y[3]-rot_y[7];
  //X(7)
  assign xout7=rot_x[1]-rot_x[8]-rot_x[9]+rot_x[10];
  assign yout7=rot_y[1]-rot_y[8]-rot_y[9]+rot_y[10];
  
  
endmodule

/////////////////////////////////////////////////////////////////////////////
// Code your design here
// Code your design here

// Code for theta in [-pi/2,pi/2]
//LUT for 32 values of atan 2^(-i)

//THE WRITING AND READING FORMAT IS SIGNED [32 24]

///////////////////////////////////////////////////////////////////////////////

// Code your design here
// Code your design here

// Code for theta in [-pi/2,pi/2]
//LUT for 32 values of atan 2^(-i)

//THE WRITING AND READING FORMAT IS SIGNED [32 24]

///////////////////////////////////////////////////////////////////////////////

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


///////////////////////////////////////////////////////////////////////////////

//STAGE 1: DECLARING ALL THE NETS AND REG AND CONNECTING THE WIRES

// For i=[0,31] Cordic gain An=1.646760. So, initial value of cos theta will be init = 1/An = 0.6072529350088814.
`define init 32'd10188016

module cordic_rotation( x_in, y_in, reset, enable, clock, angle_in, x_out, y_out,done_w);
  
  //Since LUT has maximum n=32 enteries
  parameter n=32;
  input reset,enable,clock;
  input signed [n-1:0]angle_in, x_in, y_in;
  output signed [n-1:0] x_out, y_out;
  output done_w;
  reg done;
  reg signed [n-1:0] x,y,angle; // Register holding next and present values of cos, sine and angle respectively
  integer count=0;
  integer state=0;
  integer inp=1;
  // Connecting the output wires to re    
  assign x_out = x;   
  assign y_out = y;
  assign done_w= done;
  reg [n-1:0] var1, var2;
  // Initializing and connecting the intermediate wires
          
 //To check whether the angle in current state is positive or negative          
          wire is_neg = angle[31];
 // To do arithmetic shifts we need the msb to be equivalent to msb of current cos or sin. Since the maximum value by which it will be shifted =n, so we assign an internal wire (vector) of size n. Then the shifted cos (or sin) value will be n bits sign bit of cos concatenated with n bits present cos (or sin) and the whole 2n bits shifted right (ie divided by 2) by count (count max = n-1). And the lsb 32 bits of these 64 bits shall be considered as the shifted_cos (or shifted_sin) to be used in computation of next iteration stage. 

        
// Now to carry the values of the LUT we need a set of n wires 'lut' whose each wire can carry n bits.
  reg signed [n-1:0]x_prev=32'b0;
  reg signed [n-1:0]y_prev=32'b0;
  reg signed [n-1:0]angle_prev=32'b0;
  
  
  //initial $monitor(state);
  wire signed [n-1:0] lut [25:0];
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
          

          
////////////////////////////////////////////////////////////////////////////////
          
// STAGE 3: COMPUTATION PART
  always@(posedge clock, posedge reset)
    begin
     // $display("x, y, angle: ", x,y,angle);
    if (state==0) begin
      if (reset) begin
        x<=x_in;
        y<=y_in;
      	angle<=angle_in;
        //$display("Input angles are: ", angle_in);
      done<=0;
      end
      else if (!reset) begin
        if(inp==1) begin
          if(x_prev==x_in && y_prev==y_in && angle_prev==angle_in) begin
            //$display("Everything is same; so don't calculate again");
            done<=1;
          end
          else begin
            //$display("I got new input :)");
          x_prev<=x_in;
           y_prev<=y_in;
          angle_prev<=angle_in;
          x<=x_in;
          y<=y_in;
          angle<=angle_in;
          inp<=0;
          done<=0;
          //$display("angluar input: ", angle);
          end
        end
        
      else if (inp==0) begin
          
        if (angle>=32'd105414352)
          	angle<=angle-32'd105414352;

        //2nd quad
        else if(angle>=32'd26353584 && angle<32'd52707184) begin
                y<=x;
                x<=~y;
                angle<=angle-32'd26353584;
          		state<=1;
              end
              //1st quad
        else if(angle<32'd26353584 && angle>=32'd0) begin     
          	   x <= x;
               y <= y;
          	   state<=1;
              end
              
              //3rd quad
        else if(angle>=32'd52707184 && angle<32'd79060784) begin
                x <= ~x;
              	y <= ~y;
              	angle<= angle-32'd52707184;
                state<=1;
              end
              
              //4th quad
        else if(angle<32'd105414352 && angle>=32'd79060784)
                begin
                y <= ~x;
              	x <= y;
              	angle <= angle-32'd79060784;
                state<=1;
              end
        
      		end
    	  end 
    	end
  
      else if(state)
      begin 
       	 if(enable==1) begin
        if(count<25) begin
          x<=is_neg? x+(y>>>count) : x-(y>>>count);
          y<=is_neg? y-(x>>>count) : y+(x>>>count);
          angle<=is_neg? angle+lut[count] : angle-lut[count];
          count<=count+1;
          //$display(" y,x, angle are: ",y, x, angle, count);
     
        end
           //if (count==24) done<=1;
           if(count==25) begin
          //$display("HI I AM HERE");
          done<=1;
          state<=0;
          count<=0;
          inp<=1;
             #15
             done<=0;
          //$hold;
          //$finish;
          $display("the final x,y are: ", x_out, y_out);
          //$display("final angle: ", done);
          //$finish;
        end
      end
    end
    end

endmodule
              
////////////////////////////////////////////////////////////////////////////////
              

            
