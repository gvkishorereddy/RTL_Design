// Odd counter

module Odd_counter (
  input     logic        clk,
  input     logic        reset,

  output    logic[7:0]  cnt_o
);

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      cnt_o <= 8'h01;
    end
    else begin
      cnt_o <= cnt_o + 8'h02;
    end
  end

endmodule

//combinational
module Odd_counter (
  input     logic        clk,
  input     logic        reset,
  output    logic [7:0]  cnt_o
);

  logic [7:0] nxt_cnt;

  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      cnt_o <= 8'h01;
    else
      cnt_o <= nxt_cnt;
  end

  assign nxt_cnt = cnt_o + 8'h02;

endmodule
