// Utility modules
// Implementation of a 2 to 1 multiplexer
module mux2_1 (
    input wire se1,         // Immediate value
    input wire [7:0] in0, 
    input wire [7:0] in1,   // Register output
    output reg [7:0] out
);

always @* begin
    if (se1 == 1'b1) begin
        out = in0;
    end 
    else begin
        out = in1;
    end
end

endmodule

// Convert numbers into minus in two's complement
module twosCompliment (
    input wire [7:0] in,
    output reg [7:0] result
);

always @* begin
    result = ~in + 1;
end

endmodule

module adder (
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] sum
);

always @* begin
    sum = a + b;
end

endmodule
