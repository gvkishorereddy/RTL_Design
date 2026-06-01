module parallel_to_serial (
  input  logic       clk,
  input  logic       reset,
  input  logic [3:0] parallel_i,

  output logic       serial_o,
  output logic       valid_o,
  output logic       empty_o
);

  logic [3:0] shift_reg;
  logic [3:0] nxt_shift;

  logic [2:0] bit_cnt;
  logic [2:0] nxt_cnt;

  logic       busy;

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      shift_reg <= '0;
      bit_cnt   <= '0;
    end else begin
      shift_reg <= nxt_shift;
      bit_cnt   <= nxt_cnt;
    end
  end

  always_comb begin
    nxt_shift = shift_reg;
    nxt_cnt   = bit_cnt;

    if (empty_o) begin
      if (parallel_i != 4'b0000) begin
        nxt_shift = parallel_i;
        nxt_cnt   = 3'd4;
      end
    end
    else begin
      nxt_shift = {shift_reg[2:0], 1'b0};
      nxt_cnt   = bit_cnt - 1'b1;
    end
  end

  assign busy     = (bit_cnt != 3'd0);
  assign empty_o  = !busy;
  assign valid_o  = busy;
  assign serial_o = shift_reg[3];

endmodule