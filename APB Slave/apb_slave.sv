// Day 18: APB Slave Interface wrapper for day17 memory
module day18 (
  input  wire        clk,
  input  wire        reset,

  // APB Bus Signals
  input  wire        psel_i,
  input  wire        penable_i,
  input  wire [9:0]  paddr_i,     // 10-bit APB address bus
  input  wire        pwrite_i,    // 1 = Write, 0 = Read
  input  wire [31:0] pwdata_i,
  output wire [31:0] prdata_o,
  output wire        pready_o
);

  // Interconnect signals to Day 17 memory core
  wire        mem_req;
  wire        mem_rnw;
  wire [3:0]  mem_addr;

  // A valid request is active only when APB is in the ACCESS phase
  assign mem_req  = psel_i & penable_i;
  
  // Day17 uses 1 for Read and 0 for Write. APB uses 1 for Write and 0 for Read.
  assign mem_rnw  = !pwrite_i;
  
  // day17 only has 16 memory locations (4-bit address space).
  // We map the lower bits of the APB byte-addressing scheme. 
  // (Note: APB addresses are typically byte-aligned, so bits [5:2] map to word selection)
  assign mem_addr = paddr_i[5:2];

  day17 memory_core (
    .clk        (clk),
    .reset      (reset),
    .req_i      (mem_req),
    .req_rnw_i  (mem_rnw),
    .req_addr_i (mem_addr),
    .req_wdata_i(pwdata_i),
    .req_ready_o(pready_o),
    .req_rdata_o(prdata_o)
  );

endmodule