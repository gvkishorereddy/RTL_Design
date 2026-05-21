module full_adder(
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule

module ripple_adder #(parameter N=4)(
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    input  logic         cin,       
    output logic [N-1:0] sum,
    output logic         cout
);

    
    logic [N:0] carry;
  
    
    assign carry[0] = cin; 
    assign cout     = carry[N]; 

    generate
        genvar i;
        for (i = 0; i < N; i++) begin : gen_bit_adder
            full_adder fa (
                .a   (a[i]),
                .b   (b[i]),
                .cin (carry[i]),
                .sum (sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate
         
endmodule
