// Code your testbench here
// or browse Examples
module testbench();
  
  parameter m=4;
  parameter n=16;
  reg reset;
  reg enable;
  reg clock;
  reg [0:n-1]text;
  reg [0:m-1]pattern;
  wire [0:n-1]flag;
  
  pattern_match values( reset, enable, clock, text, pattern, flag ); 
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(1);
    
    text=16'b1111_1111_1111_1111;
    pattern=4'b1111;
    reset = 1'b0;
    enable = 1'b0;
    clock = 1'b0;
    forever #5 clock = ~clock;
	
    end
  
  initial begin
    #7 reset = 1'b1;
    #9 reset = 1'b0;
    #9 enable = 1'b1;
  end
endmodule

