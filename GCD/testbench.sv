`timescale 1ns/1ps

module tb;
  
  localparam width = 4;
  localparam MSB   = width - 1;
  
  logic clk, rst, start;
  logic [MSB:0] i_a, i_b;
  logic [MSB:0] o_result;
  logic done, busy;
  
  gcd #(.N(width)) dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .i_a(i_a),
    .i_b(i_b),
    .o_result(o_result),
    .done(done),
    .busy(busy)
  );
  
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end
  
  function automatic [MSB:0] get_expected_gcd(input [MSB:0] a, input [MSB:0] b);
    logic [MSB:0] x = a;
    logic [MSB:0] y = b;
    if (x == 0) return y;
    if (y == 0) return x;
    while (x != y) begin
      if (x > y) x = x - y;
      else       y = y - x;
    end
    return x;
  endfunction

  logic [MSB:0] expected_output;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
    
    i_a   = 0;
    i_b   = 0;
    start = 0;
    
    rst = 1;
    #15;
    rst = 0;
    #10;
    
    repeat(100) begin
      
      wait(!busy);
      
      i_a = $urandom_range((1<<width)-1, 1);
      i_b = $urandom_range((1<<width)-1, 1);
      expected_output = get_expected_gcd(i_a, i_b);
      
      @(posedge clk);
      start = 1;
      @(posedge clk);
      start = 0;
      
      @(posedge done);
      
      if(expected_output !== o_result) begin
        $display("[FAIL] Inputs: A=%0d, B=%0d | Expected: %0d, Got: %0d", i_a, i_b, expected_output, o_result);
      end else begin
        $display("[PASS] Inputs: A=%0d, B=%0d | GCD: %0d", i_a, i_b, o_result);
      end
      
      #20;
    end
    
    $display("Simulation Finished!");
    $finish;
  end
endmodule
