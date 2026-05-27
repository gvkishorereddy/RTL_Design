//Moore
//Overlap

module sequence_detector(
    input  logic clk,
    input  logic reset_n,
    input  logic in,
    output logic detected
);
  
  typedef enum logic [2:0] {
    IDLE  = 3'b000,
    S1    = 3'b001,
    S10   = 3'b010,
    S101  = 3'b011,
    S1011 = 3'b100
  } states;
  
  states current_state, next_state;
  
  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n)
      current_state <= IDLE;
    else 
      current_state <= next_state;
  end
  
  always_comb begin
    next_state = IDLE; 
    detected   = 1'b0;
    
    case (current_state)
      IDLE: begin
        if (in) next_state = S1;
        else    next_state = IDLE;
      end
      
      S1: begin
        if (in) next_state = S1;
        else    next_state = S10;
      end
      
      S10: begin
        if (in) next_state = S101;
        else    next_state = IDLE; 
      end
      
      S101: begin
        if (in) next_state = S1011;
        else    next_state = S10;   
      end
      
      S1011: begin
        detected = 1'b1;            
        if (in) next_state = S1;    
        else    next_state = S10;   
      end
      
      default: begin
        next_state = IDLE;
        detected   = 1'b0;
      end
    endcase
  end

endmodule
