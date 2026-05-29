module lfsr (
  input     logic      clk,
  input     logic      reset,

  output    logic[3:0] lfsr_o
);

  logic [3:0] shift_reg;
  
  always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
      shift_reg <= 4'b1111; 
    end else begin
      shift_reg <= {shift_reg[2:0], shift_reg[1] ^ shift_reg[3]};
    end
  end 
    
  assign lfsr_o = shift_reg;

endmodule