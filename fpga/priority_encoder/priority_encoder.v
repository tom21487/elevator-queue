/* Implements a 4-2 priority encoder */
module priority_encoder(
  input  [3:0] in, // inverse pmod, active high
  output       valid,
  output [1:0] out
);
    wire a, b;
    assign a = ~in[2];
    assign b = a & in[1];
    assign out[0] = in[3] | b;
    assign out[1] = in[3] | in[2];
    assign valid = out[1] | in[1] | in[0];
endmodule
