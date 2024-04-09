`timescale 1ns / 1ps
`include "cpu.v"

module cpu_tb;

reg CLK;
reg RESET;
wire [31:0] PC;
reg [31:0] INSTRUCTION;

cpu myCPU (
    .INSTRUCTION(INSTRUCTION),
    .CLK(CLK),
    .RESET(RESET),
    .PC(PC)
);

initial begin
    CLK = 0;
    forever #10 CLK = ~CLK;
end

initial begin
    // Reset the CPU
    RESET = 1;
    #20;
    RESET = 0;

    $display("*******************************************************");
    $display("*                                                     *");
    $display("*                 8-Bit CPU Project                   *");
    $display("*                                                     *");
    $display("*******************************************************");
    $display("This Verilog project implements an 8-bit CPU.");
    $display("It consists of various instructions such as Add, Subtract,");
    $display("AND, OR, etc., executed sequentially.");
    $display("Each instruction is accompanied by its execution time,");
    $display("instruction code, program counter (PC), and function.");
    $display("Simulation results and CPU operation will be displayed below:\n\n");
    $display("-------------------------------------------------------------");

    $display("Time\t\tInstruction\tPC\tFunction");
    $display("-------------------------------------------------------------");
    
    // Load and execute instructions
    INSTRUCTION = 32'b00000000_00000000_00000000_00101010;  // Forward function
    #20;
    $display("%0t\t\t%0h\t\t%0d\tForward", $time, INSTRUCTION, PC);

    INSTRUCTION = 32'b00000001_00000001_00000000_00000000;  // Add function
    #20;
    $display("%0t\t\t%0h\t\t%0d\tAdd", $time, INSTRUCTION, PC);

    INSTRUCTION = 32'b00000010_00000010_00000001_00000000;  // Subtract function
    #20;
    $display("%0t\t\t%0h\t\t%0d\tSubtract", $time, INSTRUCTION, PC);

    INSTRUCTION = 32'b00000011_00000011_00000010_00000000;  // AND function
    #20;
    $display("%0t\t\t%0h\t\t%0d\tAND", $time, INSTRUCTION, PC);

    INSTRUCTION = 32'b00000100_00000100_00000011_00000000;  // OR function
    #20;
    $display("%0t\t\t%0h\t\t%0d\tOR", $time, INSTRUCTION, PC);

    INSTRUCTION = 32'b00000101_00000101_00000100_00000000;  // Reserved function
    #20;
    $display("%0t\t\t%0h\t\t%0d\tReserved", $time, INSTRUCTION, PC);
 
    // Reset the CPU again
    RESET = 1;
    #20;
    RESET = 0;

    // Finish simulation
    #100;
    $finish;
end

endmodule
