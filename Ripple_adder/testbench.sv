module tb;
  localparam width = 16;
  
  logic [width-1:0] a, b;
  logic cin;
  logic [width-1:0] sum;
  logic cout;
  
  ripple_adder #(.N(width)) dut(.*);
  
  logic [width:0] hw_sum;
  logic [width:0] expected_sum;
  logic [31:0]    tests_failed; 
  
  assign expected_sum = a + b + cin; 
  assign hw_sum       = {cout, sum};
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  
    a            = 0;
    b            = 0;
    cin          = 0;
    tests_failed = 0; 
    
    #10; 
    
    repeat(100) begin
      
      a = $urandom_range((1<<width)-1, 0);
      b = $urandom_range((1<<width)-1, 0);
      
      #1; 
      
      $display("%t: a=%d, b=%d | HW=%d, Expected=%d", $time, a, b, hw_sum, expected_sum);
             
      if (hw_sum !== expected_sum) begin
        tests_failed = tests_failed + 1;
        $display("Error: Mismatch detected!");
      end
    end
    
    
    if (tests_failed == 0) begin
      $display("---------------------------------------");
      $display("SUCCESS: All Tests Passed!");
      $display("---------------------------------------");
    end else begin
      $display("---------------------------------------");
      $display("FAILURE: %0d tests failed.", tests_failed);
      $display("---------------------------------------");
    end
    
    $finish;
  end
  
endmodule
