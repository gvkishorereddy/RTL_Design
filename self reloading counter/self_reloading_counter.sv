module self_reloading_counter (
  input  logic       clk,
  input  logic       reset,
  input  logic       load_i,
  input  logic[3:0]  load_val_i,

  output logic[3:0]  count_o
);
  
  logic [3:0] count;
  logic [3:0] nxt_count;
  logic [3:0] load_ff;

  //Sequential Block
  always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
      count   <= '0;
      load_ff <= '0;
    end else begin
      count <= nxt_count; 
      if (load_i) begin   
        load_ff <= load_val_i;
      end
    end
  end
  
  //Combinational Block
  assign nxt_count = load_i             ? load_val_i : 
                     (count == 4'b1111) ? load_ff    : 
                                          count + 1'b1;
  
  assign count_o = count;

endmodule