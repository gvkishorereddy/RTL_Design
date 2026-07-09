module freq_divider
  (input  logic clk,
   input  logic reset,
   output logic result);
  
  // 50MHz to 50KHz total cycles = 1000
  // To get a 50% duty cycle, we must toggle every half-period (1000 / 2 = 500 cycles)
  parameter int NO_OF_DELAYS = 500;
  
  logic [31:0] count;
  
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      result <= 1'b0;
      count  <= 32'b0;
    end 
    else if (count == NO_OF_DELAYS - 1) begin
      result <= ~result;  
      count  <= 32'b0;
    end 
    else begin
      count  <= count + 1'b1;
    end
  end
endmodule
