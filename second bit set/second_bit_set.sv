module day21 #(
  parameter WIDTH = 12
)(
  input  logic [WIDTH-1:0] vec_i,
  output logic [WIDTH-1:0] second_bit_o
);

  logic [WIDTH-1:0] masked_vec;

  always_comb begin
    masked_vec   = vec_i;
    second_bit_o = '0;

   
    for (int i = 0; i < WIDTH; i++) begin 
      if (vec_i[i] == 1'b1) begin
        masked_vec[i] = 1'b0;
        break; 
      end
    end

    
    for (int j = 0; j < WIDTH; j++) begin 
      if (masked_vec[j] == 1'b1) begin
        second_bit_o[j] = 1'b1;
        break;
      end
    end
  end

endmodule