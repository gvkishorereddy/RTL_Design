
module day19 #(
  parameter DEPTH   = 4,
  parameter DATA_W  = 1
)(
  input  wire                 clk,
  input  wire                 reset,

  // Push Interface
  input  wire                 push_i,
  input  wire [DATA_W-1:0]    push_data_i,

  // Pop Interface
  input  wire                 pop_i,
  output logic [DATA_W-1:0]   pop_data_o, 
  // Status Flags
  output wire                 full_o,
  output wire                 empty_o
);

  // Sizing pointer bits based on max index
  localparam PTR_W = $clog2(DEPTH);

  // Internal Registers
  logic [PTR_W:0]          count;         
  logic [PTR_W-1:0]        wr_ptr;        // Tracks write index
  logic [PTR_W-1:0]        rd_ptr;        // Tracks read index
  logic [DATA_W-1:0]       fifo_mem [DEPTH-1:0]; // The physical memory storage
  
  
  logic                    valid_push;
  logic                    valid_pop;

  assign valid_push = push_i && !full_o;  
  assign valid_pop  = pop_i  && !empty_o;
  
 
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      count   <= '0;
      wr_ptr  <= '0;
      rd_ptr  <= '0;
      pop_data_o <= '0;
    end 
    else begin
      if (valid_push) begin
        fifo_mem[wr_ptr] <= push_data_i; 
        wr_ptr           <= (wr_ptr == DEPTH-1) ? '0 : wr_ptr + 1'b1;
      end
      
      if (valid_pop) begin
        pop_data_o       <= fifo_mem[rd_ptr];
        rd_ptr           <= (rd_ptr == DEPTH-1) ? '0 : rd_ptr + 1'b1;
      end

      case ({valid_push, valid_pop})
        2'b10: count <= count + 1'b1;
        2'b01: count <= count - 1'b1;
        default: count <= count;
      endcase
    end
  end
  
  
  assign full_o  = (count == DEPTH);
  assign empty_o = (count == 0);
      
endmodule
