
module shift_register #(parameter width=4)(
  input     logic        clk,
  input     logic        reset,
  input     logic        x_i,      // Serial input

  output    logic[width-1:0]   sr_o //output
);

  logic[width-1:0] shift_reg;
  
  always @(posedge clk or posedge reset) begin
    if(reset)
      shift_reg <= '0;
    else
      //Right shift (MSB to LSB)
      shift_reg <= {x_i, shift_reg[width-1:1]};
      
     //If you want to shift left instead
       shift_reg <= {shift_reg[width-2:0], x_i};
       
  end
    
  assign sr_o = shift_reg;

endmodule