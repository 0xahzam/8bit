module barrelShifter (
    input [31:0] DATA1,
    input [4:0] shiftAmount,  // Adjusted width to match input from alu module
    output reg [31:0] RshiftResult
);

always @* begin
    RshiftResult = DATA1 >> shiftAmount;
end

endmodule

module alu(
    input [7:0] DATA1,
    input [7:0] DATA2,
    input [2:0] SELECT,
    output reg [7:0] RESULT,
    output reg ZERO
);

// Internal register declaration
wire [31:0] RshiftResult; // Changed to wire type as it's an output from barrelShifter

// Instantiation of barrel shifter
barrelShifter myRightLogicalShifter(
    .DATA1({24'd0, DATA1}),  // Padding DATA1 to match the width of barrelShifter input
    .shiftAmount(DATA2[4:0]),
    .RshiftResult(RshiftResult)
);

// Always block triggered on input changes
always @* begin
    // Case statement based on SELECT input
    case(SELECT)
        3'b000: #1 RESULT = DATA2;           // Forward function
        3'b001: #2 RESULT = DATA1 + DATA2;   // Add and Sub function
        3'b010: #1 RESULT = DATA1 & DATA2;   // AND and Sub function
        3'b011: #1 RESULT = DATA1 | DATA2;   // OR and Sub function
        // Setting 1XX selection inputs as reserved for future references
        3'b100: RESULT = RshiftResult; 
        3'b101: RESULT = 8'b00000000; 
        3'b110: RESULT = 8'b00000000; 
        3'b111: RESULT = 8'b00000000; 
    endcase 
end

// Always block for generating the ZERO bit based on the alu result
always @* begin
    ZERO = (RESULT == 8'b0);
end

endmodule
