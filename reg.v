module reg_file(
    input [2:0] INADDRESS,
    input [2:0] OUT1ADDRESS,
    input [2:0] OUT2ADDRESS,
    input WRITE,
    input CLK,
    input RESET,
    input [7:0] IN,
    output [7:0] OUT1,
    output [7:0] OUT2
);

// Internal variables
integer i;

// Register array declaration
reg [7:0] regFile[0:7];

// Resetting the registers if RESET is asserted
always @(*)
begin
    if (RESET == 1) begin
        #2;
        for (i = 0; i < 8; i = i + 1) begin
            regFile[i] = 8'b00000000;
        end
    end
end

// Writing to the register on the positive edge of CLK if WRITE is enabled
always @(posedge CLK)
begin
    if (WRITE == 1'b1 && RESET == 1'b0) begin
        #2;
        regFile[INADDRESS] = IN; // Write with a delay
    end
end

// Reading from the registers
assign #2 OUT1 = regFile[OUT1ADDRESS];
assign #2 OUT2 = regFile[OUT2ADDRESS];

endmodule
