timeunit 1ns/1ps;

module gcd #(parameter N=4,
             int MSB = N -1)
  (
    input logic clk, rst, start,
    input logic [MSB:0] i_a, i_b,
    
    output logic [MSB:0] o_result,
    output logic done, busy
  );
  
  logic [MSB:0] x, y;
  
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      x        <= '0;
      y        <= '0;
      o_result <= '0;
      done     <= 1'b0;
      busy     <= 1'b0;
    end
    else begin
      done <= 1'b0;

      if (!busy) begin
        if (start) begin
          x    <= i_a;
          y    <= i_b;
          busy <= 1'b1;
        end
      end 
      else begin
        if (x == '0) begin
          o_result <= y;
          busy     <= 1'b0;
          done     <= 1'b1;
        end 
        else if (x >= y) begin
          x <= x - y;
        end 
        else begin
          x <= y;
          y <= x;
        end
      end
    end
  end
endmodule
