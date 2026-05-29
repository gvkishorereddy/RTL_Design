module bin_to_one_hot #(
  parameter BIN_W       = 4,
  //since parameter b depends on parameter a
  parameter int ONE_HOT_W = 1 << BIN_W
)(
  input   logic[BIN_W-1:0]     bin_i,
  output  logic[ONE_HOT_W-1:0] one_hot_o
);

  assign one_hot_o = ONE_HOT_W'(1) << bin_i; // to match width of one_hot_o
                               
endmodule
