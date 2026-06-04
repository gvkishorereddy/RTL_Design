// Day 17: Valid/Ready Memory Slave
// 16x32 bit memory with a random delay on ready
// Master must hold req_i high until ready is seen!

module day17 (
  input  wire        clk,
  input  wire        reset,

  // Master interface
  input  wire        req_i,         // Valid req from master
  input  wire        req_rnw_i,     // 1 = Read, 0 = Write
  input  wire [3:0]  req_addr_i,    // 4-bit address for 16 deep mem
  input  wire [31:0] req_wdata_i,   // Data to write
  
  // Slave interface
  output wire        req_ready_o,   // Ready to close handshake
  output wire [31:0] req_rdata_o    // Read data output
);

  // --- Core Memory and States ---
  logic [31:0] mem [15:0];          // 16 deep, 32-bit wide array

  typedef enum logic [1:0] {
    IDLE   = 2'b00,
    DELAY  = 2'b01,
    ACCESS = 2'b10
  } states;
  
  states current_state, next_state;

  logic [2:0] delay;                // Random delay number from LFSR
  logic [2:0] dec_counter;          // Main countdown register
  wire        mem_rd;               // Read flag for bus masking

  // Instantiate the LFSR to get random wait cycles
  lfsr random_delay (
    .clk  (clk),
    .reset(reset),
    .lfsr (delay)
  );

  // --- State Machine Reg ---
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      current_state <= IDLE;
    else
      current_state <= next_state;
  end

  // --- Next State Logic ---
  always_comb begin
    next_state = current_state;
    
    case (current_state)
      IDLE: begin
        if (req_i == 1'b1) begin
          // If delay happens to be 0, skip wait and accept right away
          if (delay == 3'b000)
            next_state = ACCESS;
          else
            next_state = DELAY;
        end
      end
      
      DELAY: begin
        // Exit to ACCESS state when counter hits 1
        if (dec_counter == 3'b001)
          next_state = ACCESS;
        else
          next_state = DELAY;
      end
      
      ACCESS: begin
        // Transaction completes on this cycle, go back to IDLE
        next_state = IDLE;
      end
      
      default: next_state = IDLE;
    endcase
  end

  // --- Counter and Memory Blocks ---
  
  // Down counter control
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      dec_counter <= 3'b000;
    end else begin
      if (current_state == IDLE && req_i) begin
        dec_counter <= delay;              // Latch the random delay value
      end else if (current_state == DELAY) begin
        dec_counter <= dec_counter - 3'b001; // Decrement by 1
      end
    end
  end

  // Write block (Must be clocked/sequential!)
  always_ff @(posedge clk) begin
    if (current_state == ACCESS) begin
      if (!req_rnw_i) begin
        mem[req_addr_i] <= req_wdata_i;
      end
    end
  end
      
  // Drive ready pin when in access state
  assign req_ready_o = (current_state == ACCESS);
  
  // Unmask read bus ONLY during a valid read access cycle
  assign mem_rd = (current_state == ACCESS) && req_rnw_i;

  // Read block (Combinational + masked with all 0s when idle to save power)
  assign req_rdata_o = mem[req_addr_i] & {32{mem_rd}};
  
endmodule


// Standard 3-bit LFSR for pseudo-random numbers
module lfsr (
  input  logic       clk,
  input  logic       reset,
  output logic [2:0] lfsr
);
  // Uses feedback taps on bits 2 and 1. Cannot reset to 3'b000 or it locks up!
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      lfsr <= 3'b111; 
    else
      lfsr <= {lfsr[1:0], lfsr[1] ^ lfsr[2]};
  end
endmodule