module day16 (
  input       logic        clk,
  input       logic        reset,

  input       logic[1:0]   cmd_i,

  output      logic        psel_o,
  output      logic        penable_o,
  output      logic[31:0]  paddr_o,
  output      logic        pwrite_o,
  output      logic[31:0]  pwdata_o,
  input       logic        pready_i,
  input       logic[31:0]  prdata_i
);

  // APB FSM States
  typedef enum logic [1:0] {
    IDLE   = 2'b00,
    SETUP  = 2'b01,
    ACCESS = 2'b10
  } state_t;

  state_t current_state, next_state;
  
  logic [31:0] read_data;
  logic        is_write_reg;

  // State Transition Sequential Logic
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      current_state <= IDLE;
    else
      current_state <= next_state;
  end

  // Register to lock in whether the transaction is a read or write at the SETUP phase
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      is_write_reg <= 1'b0;
    else if (current_state == IDLE && (cmd_i == 2'b01 || cmd_i == 2'b10))
      is_write_reg <= cmd_i[1]; // 2'b01 (Read) -> 0, 2'b10 (Write) -> 1
  end

  // Next State Combinational Logic
  always_comb begin
    next_state = current_state;
    case (current_state)
      IDLE: begin
        if (cmd_i == 2'b01 || cmd_i == 2'b10)
          next_state = SETUP;
      end
      SETUP: begin
        next_state = ACCESS;
      end
      ACCESS: begin
        if (pready_i)
          next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

  // Capture read data on a valid APB Read Access phase completion
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      read_data <= '0;
    else if (current_state == ACCESS && pready_i && !is_write_reg)
      read_data <= prdata_i;
  end

  // APB Output Assignments
  assign psel_o    = (current_state == SETUP) || (current_state == ACCESS);
  assign penable_o = (current_state == ACCESS);
  assign pwrite_o  = is_write_reg;
  assign paddr_o   = 32'hDEAD_CAFE;
  assign pwdata_o  = read_data + 32'h1;

endmodule