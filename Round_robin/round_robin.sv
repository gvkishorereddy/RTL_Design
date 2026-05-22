module round_robin #(parameter N=4)(
    input  logic       clk,
    input  logic       reset,
    input  logic [N-1:0] req,    
    output logic [N-1:0] grant   
);

  logic [N-1:0] last_grant;
  logic [N-1:0] unmasked_grant;

  // req & ~(req - 1'b1)
// isolates rightmost set bit
  //Normal priority calculation
  assign unmasked_grant = req & ~(req - 1'b1);

  logic [N-1:0] mask;
  logic [N-1:0] mask_req;
  logic [N-1:0] masked_grant;

  //makes all bits to the right of set bit to 1
  assign mask = ~(last_grant - 1'b1) & ~last_grant;

  assign mask_req = req & mask;

  //calculate priority for only right to the last grant bit
  assign masked_grant = mask_req & ~(mask_req - 1'b1);

  assign grant = (|mask_req) ? masked_grant : unmasked_grant;

  always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
      last_grant <= '0;
    end
    //do no reset when input is all zeros, if input all zeros the last grant still should be saved
    else if(|req) begin
      last_grant <= grant;
    end
  end

endmodule
