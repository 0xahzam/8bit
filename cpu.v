`include "alu.v"
`include "reg.v"
`include "utility.v"

module cpu (
    input [31:0] INSTRUCTION,
    input CLK,
    input RESET,
    output reg [31:0] PC
);

reg writeEnable;
reg isAdd;
reg isImmediate;
reg [2:0] aluOp;
reg [2:0] regRead1Address;
reg [2:0] regRead2Address;
reg [2:0] writeRegAddress;
reg [7:0] immediateVal;
wire [7:0] mux1out;
wire [7:0] mux2out;
wire [7:0] ALURESULT;
wire [7:0] minusVal;
reg [7:0] IN;
wire [7:0] OUT1;
wire [7:0] OUT2;
reg [7:0] OPCODE; 
reg [2:0] DESTINATION;  
reg [2:0] SOURCE1; 
reg [2:0] SOURCE2;
wire ZERO; // Added ZERO wire for ALU ZERO output

// Adder to update PC by 4
wire [31:0] nextPC;
adder myadder (.a(PC), .b(32'd4), .sum(nextPC));

always @(posedge CLK) begin
    if (RESET) begin
        PC <= 32'd0;  // Reset PC to 0
    end else begin
        PC <= nextPC;
    end
end

always @* begin
    OPCODE = INSTRUCTION[31:24];
    case(OPCODE)
        8'b00000000:
            begin
                writeEnable = 1'b1;
                aluOp = 3'b000;
                isAdd = 1'b1;
                isImmediate = 1'b1;
            end
        8'b00000001:
            begin
                writeEnable = 1'b1;  
                aluOp = 3'b000;
                isAdd = 1'b1;
                isImmediate = 1'b0;
            end
        8'b00000010:
            begin
                writeEnable = 1'b1;
                aluOp = 3'b001;
                isAdd = 1'b1;
                isImmediate = 1'b0;
            end
        8'b00000011:
            begin
                writeEnable = 1'b1;
                aluOp = 3'b001;
                isAdd = 1'b0;
                isImmediate = 1'b0;
            end
        8'b00000100:
            begin
                writeEnable = 1'b1;
                aluOp = 3'b010;
                isAdd = 1'b1;
                isImmediate = 1'b0; 
            end
        8'b00000101:
            begin
                writeEnable = 1'b1;
                aluOp = 3'b011;
                isAdd = 1'b1;
                isImmediate = 1'b0; 
            end
    endcase        
end

// Including the register file
reg_file myReg (
    .IN(IN),
    .OUT1(OUT1),
    .OUT2(OUT2),
    .INADDRESS(DESTINATION),
    .OUT1ADDRESS(SOURCE1),
    .OUT2ADDRESS(SOURCE2),
    .WRITE(writeEnable),
    .CLK(CLK),
    .RESET(RESET)
);

always @* begin
    DESTINATION  = INSTRUCTION[18:16];
    SOURCE1   = INSTRUCTION[10:8];
    SOURCE2 = INSTRUCTION[2:0];
    immediateVal = INSTRUCTION[7:0];
end

// Two's complement unit for subtraction
twosCompliment mytwo (
    .in(OUT2),
    .result(minusVal)
);

// Multiplexer to choose between minus value and plus value
mux2_1 mymux1 (
    .in0(OUT2),
    .in1(minusVal),
    .se1(isAdd),
    .out(mux1out)
);

// Multiplexer to choose between immediate value and mux1 output
mux2_1 mymux2 (
    .in0(immediateVal),
    .in1(mux1out),
    .se1(isImmediate),
    .out(mux2out)
);

// ALU module
alu myalu (
    .DATA1(OUT1),
    .DATA2(mux2out),
    .SELECT(aluOp),
    .RESULT(ALURESULT),
    .ZERO(ZERO)
);

always @* begin
    IN = ALURESULT;  // Setting the reg input with the ALU result
end

endmodule
