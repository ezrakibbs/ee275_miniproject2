`timescale 1ns / 1ps

module TB_IF_STAGE;
    reg clk;
    reg reset;
    reg [31:0] input_instruction;
    wire [31:0] output_instruction;
    reg done_initializing_instructions;


    IF_STAGE test(
        .clk_x61(clk),
        .reset_x61(reset),
        .input_instruction_x61(input_instruction), 
        .output_instruction_x61(output_instruction));

    // clk generation
    initial
    begin
        clk = 0;
        reset = 1;
        #5
        reset = 0;
    end

    always 
    begin
        #10
        if(done_initializing_instructions)
            clk <= ~clk;
    end

    // instruction memory initialization
    initial
    begin
        done_initializing_instructions = 0;
        #5 input_instruction = 32'b000000_00000_00000_00001_00000_100001;
        #1 input_instruction = 32'b000100_00111_00000_0000_0000_0010_0000;
        #1 input_instruction = 32'b100011_00011_00010_0000_0000_0000_0000;
        #1 input_instruction = 32'b100011_00101_00100_0000_0000_0000_0000;
        #1 input_instruction = 32'b000000_00010_00100_00010_00000_011000;
        #1 input_instruction = 32'b000000_00001_00010_00001_00000_100001;
        #1 input_instruction = 32'b001001_00011_00011_0000_0000_0000_0100;
        #1 input_instruction = 32'b001001_00101_00101_0000_0000_0000_0100;
        #1 input_instruction = 32'b001001_00111_00111_1111_1111_1111_1111;
        #1 input_instruction = 32'b000010_00_0000_0000_0000_0000_0000_1000;
        #1 input_instruction = 32'b000000_11111_000_0000_0000_0000_001000;
        #1 done_initializing_instructions = 1;
        
        #300
        $finish;
    end

endmodule







