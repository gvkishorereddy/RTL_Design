// Odd counter

module Odd_counter (
  input     logic        clk,
  input     logic        reset,

  output    logic[7:0]  cnt_o
);

  // Write your logic here...
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      cnt_o <= 8'h01;
    end
    else begin
      cnt_o <= cnt_o + 8'h02;
    end
  end

endmodule
