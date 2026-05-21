module mux(input logic i0,input logic i1,input logic s,
           output logic out);
  assign out = (i0&~s)+(i1&s);
endmodule
  
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
    input  logic          cin,       
    output logic [N-1:0] sum,
    output logic          cout
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

module carry_select_adder #(parameter N=4)(
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    input  logic          cin,       
    output logic [N-1:0] sum,
    output logic          cout
);
  
    logic [N-1:0] sum0, sum1;
    logic         cout0, cout1;

    ripple_adder #(.N(N)) r0 (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(sum0),
        .cout(cout0)
    );

    ripple_adder #(.N(N)) r1 (
        .a(a),
        .b(b),
        .cin(1'b1),
        .sum(sum1),
        .cout(cout1)
    );

    mux mux_cout (
        .i0(cout0),
        .i1(cout1),
        .s(cin),
        .out(cout)
    );

    generate
        genvar i;
        for (i = 0; i < N; i++) begin : gen_mux_sum
            mux mux_bit_sum (
                .i0(sum0[i]),
                .i1(sum1[i]),
                .s(cin),
                .out(sum[i])
            );
        end
    endgenerate

endmodule

```
