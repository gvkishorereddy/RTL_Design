module bin_to_gray #(parameter WIDTH = 4) (
    input  logic [WIDTH-1:0] bin_i,
    output logic [WIDTH-1:0] gray_o
);
    // Gray[n] = Binary[n] ^ Binary[n+1]
    assign gray_o = bin_i ^ (bin_i >> 1);

endmodule