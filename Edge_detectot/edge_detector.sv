//Combinational Design
module edge_detector (
  input     logic    clk,
  input     logic    reset, 
  input     logic    a_i,

  output    logic    rising_edge_o,
  output    logic    falling_edge_o
);

  logic a_previous; 
  
  // Sequential logic to store the history
  always_ff @(posedge clk or negedge reset) begin
    if (!reset) begin
      a_previous <= 1'b0; 
    end else begin
      a_previous <= a_i; 
    end
  end
 
  // Combinational logic for immediate output
  assign rising_edge_o  = a_i & (~a_previous);
  assign falling_edge_o = (~a_i) & a_previous; 

endmodule
//Sequential Design
module edge_detector (
  input     logic    clk,
  input     logic    reset, 
  input     logic    a_i,

  output    logic    rising_edge_o,
  output    logic    falling_edge_o
);

  logic a_previous; 
  
  always_ff @(posedge clk or negedge reset) begin
    if (!reset) begin
      a_previous     <= 1'b0; 
      rising_edge_o  <= 1'b0;
      falling_edge_o <= 1'b0;
    end else begin
      a_previous     <= a_i; 
      rising_edge_o  <= a_i & (~a_previous);
      falling_edge_o <= (~a_i) & a_previous;     
    end
  end
 
endmodule
