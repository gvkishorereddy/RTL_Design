module gray_to_bin #(parameter WIDTH = 4) (
  output  logic [WIDTH-1:0] bin_o,
  input logic [WIDTH-1:0] gray_i
);

  // Binary[n] = Gray[n] ^ Binary[n+1]
  
   always_comb begin
     bin_o[WIDTH-1] = gray_i[WIDTH-1];
     for(int i=WIDTH-2;i>0;i--) begin : calculate_xor
         bin_o[i] = gray_i[i] ^ bin_o[i+1];
     end
   end
endmodule
//using streaming operator
//assign bin_o = { >> { ^(gray_i >> (WIDTH-1-i)) } };