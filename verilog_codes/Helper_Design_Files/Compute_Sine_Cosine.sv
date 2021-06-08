// A readian angle is fed as input on a 32 bit bus and the output is the sine and cosine of the input
// Code your design here
// Code your design here

// Code for theta in [-pi/2,pi/2]
//LUT for 32 values of atan 2^(-i)

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

module cordic_sin_cos#( parameter n)( reset, enable, clock, angle_in, cos_out, sin_out);
  
  //Since LUT has maximum n=32 enteries
  
  input reset,enable,clock;
  input signed [n-1:0]angle_in;
  output signed [n-1:0] cos_out, sin_out;
  
  reg signed [n-1:0] cos_next,cos,sin_next,sin,angle_next,angle; // Register holding next and present values of cos, sine and angle respectively
          reg [4:0] count,count_next; //To keep a count of no. of iterations; size should be log (n) base 2.
  reg state,state_next;  //System will be in two states: State 0: Idle state
              //                                State 1: Computational state
 
  // Connecting the output wires to registers        
  assign cos_out = cos_next;   
  assign sin_out = sin_next;
 
  // Initializing and connecting the intermediate wires
          
 //To check whether the angle in current state is positive or negative          
          wire is_neg = angle[31];
 // To do arithmetic shifts we need the msb to be equivalent to msb of current cos or sin. Since the maximum value by which it will be shifted =n, so we assign an internal wire (vector) of size n. Then the shifted cos (or sin) value will be n bits sign bit of cos concatenated with n bits present cos (or sin) and the whole 2n bits shifted right (ie divided by 2) by count (count max = n-1). And the lsb 32 bits of these 64 bits shall be considered as the shifted_cos (or shifted_sin) to be used in computation of next iteration stage. 
  wire signed [n-1:0]shifted_cos = cos >>> count;
  wire signed [n-1:0]shifted_sin = sin >>> count;
        
// Now to carry the values of the LUT we need a set of n wires 'lut' whose each wire can carry n bits.
          
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
          
///////////////////////////////////////////////////////////////////////////////
          
// STAGE 2: INITIALIZING AND UPDATING THE PRESENT STATE
          
          always@(posedge clock, posedge reset) begin
            
            if (reset) begin
              cos<=0;
              sin<=0;
              angle<=0;
              state<=0;  //To initialize or hold the values
              count<=0;
            end
            
            else begin
              cos<=cos_next;
              sin<=sin_next;
              angle<=angle_next;
              state<=state_next;
              count<=count_next;
            end
          end
          
////////////////////////////////////////////////////////////////////////////////
          
// STAGE 3: COMPUTATION PART
          
          always@(*) begin
            
            if(state == 1 && enable == 1) begin // Computational mode
              cos_next <= cos + (is_neg ? shifted_sin : -shifted_sin);
              sin_next <= sin + (is_neg ? -shifted_cos : shifted_cos);
              angle_next <= angle + (is_neg ? lut[count] : -lut[count]);
              
              count_next <= count + 1;
              
              if (count== 25) begin
// Hold the values and stop computation ie system is in idle mode
                $display("The final sine and cosine outputs are: ",sin_out, cos_out);
                state_next = 0;
                //$display(" The final outputs are sine: %0h cosine: %0h ",sin_out, cos_out);
                $finish;
              end
            end
            
            
            else if(state==0 && enable == 1) begin // Initializing mode
// To ensure that at the next posedge when computation begins and the new present states will be assigned values of 'previous next stage' the previous values are already present.          
             /* cos_next = `init;
              sin_next = 0;
              angle_next = angle_in;
              state_next = 1;
              count_next = 0;*/
              
              //2nd quad
              if(angle_in>32'd26353584 && angle_in<32'd52707184) begin
                sin_next<=`init;
                cos_next<=0;
                state_next<=1;
                count_next<=0;
                angle_next<=angle_in-32'd26353584;
              end
              //1st quad
              if(angle_in<32'd26353584) begin
                cos_next <= `init;
              	sin_next <= 0;
              	angle_next <= angle_in;
              	state_next <= 1;
              	count_next <= 0;
              end
              
              //3rd quad
              if(angle_in>32'd52707184 && angle_in<32'd79060784) begin
                cos_next <= -`init;
              	sin_next <= 0;
              	angle_next <= angle_in-32'd52707184;
              	state_next <= 1;
              	count_next <= 0;
              end
              
              //4th quad
              if(angle_in<32'd105414352 && angle_in>32'd79060784)
                begin
                sin_next <= -`init;
              	cos_next <= 0;
              	angle_next <= angle_in-32'd79060784;
              	state_next <= 1;
              	count_next <= 0;
              end
              
            end
            
           // Else when enable ==0 then irrespective of the state, we need to hold the values
            
          end
          endmodule
              
////////////////////////////////////////////////////////////////////////////////
