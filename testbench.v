`timescale 1ns / 1ps

module TB_IF_ID_EX_STAGE;
    // universal inputs
    reg clk;
    reg reset;

    reg done_initializing_instructions;
    reg done_initializing_registers;
    reg done_initializing_data_memory;

    wire clk_id;
    reg clk_2;
    assign clk_id = clk ^ clk_2;

    wire clk_mem;
    reg clk_3;
    assign clk_mem = clk ^ clk_3;

    reg [31:0] input_instruction;
    reg [31:0] register_data;
    reg [31:0] data_memory;
    reg [31:0] address_memory;
    reg write_mem;


    DOT_PRODUCT five_stage_p_test(.clk_x61(clk),
                                  .reset_x61(reset),
                                  .input_instruction_x61(input_instruction),
                                  .register_data_x61(register_data),
                                  .clk_id_x61(clk_id),
                                  .clk_mem_x61(clk_mem),
                                  .external_data_memory_x61(data_memory),
                                  .external_write_mem_x61(write_mem),
                                  .external_address_memory_x61(address_memory));
    
    // clk generation
    initial
    begin
        clk = 0;
        clk_2 = 0;
        clk_3 = 0;
        reset = 1;
        #5
        reset = 0;
    end

    always 
    begin
        #10
        if(done_initializing_instructions & done_initializing_registers & done_initializing_data_memory & !clk_2 & !clk_3)
        begin
            clk = ~clk;
        end
        else
        begin
            if(!done_initializing_registers)
                clk_2 = ~clk_2;
            if(!done_initializing_data_memory)
                clk_3 = ~clk_3;
        end
    end

    // instruction memory initialization 
    initial
    begin
        done_initializing_instructions = 0;
        #4 input_instruction = 32'b000000_00000_00000_00001_00000_100001;
        #2 input_instruction = 32'b000100_00111_00000_0000_0000_0010_0000;
        #1 input_instruction = 32'b100011_00011_00010_0000_0000_0000_0000;
        #1 input_instruction = 32'b100011_00101_00100_0000_0000_0000_0000;
        #1 input_instruction = 32'b000000_00010_00100_00010_00000_011000;
        #1 input_instruction = 32'b000000_00001_00010_00001_00000_100001;
        #1 input_instruction = 32'b001001_00011_00011_0000_0000_0000_0100;
        #1 input_instruction = 32'b001001_00101_00101_0000_0000_0000_0100;
        #1 input_instruction = 32'b001001_00111_00111_1111_1111_1111_1111;
        #1 input_instruction = 32'b000010_00_0000_0000_0000_0000_0000_0001;
        #1 input_instruction = 32'b000000_11111_000_0000_0000_0000_001000;
        #1 done_initializing_instructions = 1;
        #15000
        $finish;
    end

    // register initialization
    initial
    begin
        done_initializing_registers = 0;
        #4  register_data = 32'b1011_0010_0110_1101_0001_1110_1000_0101;
        #20 register_data = 32'b0100_1111_1001_0011_0110_0000_1101_1010;
        #20 register_data = 32'b1110_0001_0101_1011_1100_0111_0010_1001;
        #20 register_data = 0;  // r3 needs to initialize to 0 because vector 1 starts at memory location 0
        #20 register_data = 32'b1000_0111_0000_1101_1010_0011_1111_0001;
        #20 register_data = 9;  // r5 needs to initialize to 9 because vector 2 starts at memory location 9
        #20 register_data = 32'b1101_0011_0111_0001_1001_0100_1010_1100;
        #20 register_data = 9;  // r7 needs to initialize to 9 because the vectors are 9 numbers long
        #20 register_data = 32'b1010_0101_0010_1111_0000_1100_0111_1001;
        #20 register_data = 32'b0101_1110_1000_0001_1011_0110_1100_0011;
        #20 register_data = 32'b1111_0000_0100_1010_0110_1001_0001_1110;
        #20 register_data = 32'b0000_1101_1010_0111_1101_0010_1000_0100;
        #20 register_data = 32'b1001_0110_1110_0000_0010_1101_0111_1011;
        #20 register_data = 32'b0111_0010_0001_1100_1000_1111_0101_0000;
        #20 register_data = 32'b1100_1011_0100_0011_1110_1000_0001_0110;
        #20 register_data = 32'b0010_1111_1001_0101_0100_0001_1011_1100;
        #20 register_data = 32'b1011_1100_0001_0111_0011_1010_1101_0000;
        #20 register_data = 32'b0100_0011_1110_1001_1001_0101_0000_1111;
        #20 register_data = 32'b1110_1010_0101_0000_0111_1100_1001_0011;
        #20 register_data = 32'b0001_0111_1011_1100_0100_0010_1110_1000;
        #20 register_data = 32'b1000_1101_0011_0110_1111_1001_0100_0001;
        #20 register_data = 32'b0110_0001_1100_1010_0001_0111_1011_1110;
        #20 register_data = 32'b1101_1110_0000_0101_1010_1000_0011_0111;
        #20 register_data = 32'b0011_0100_1010_1111_1100_0001_0110_1001;
        #20 register_data = 32'b1010_1001_0111_0010_0001_1101_1000_1110;
        #20 register_data = 32'b0101_0000_1101_1001_1110_0111_0010_0101;
        #20 register_data = 32'b1111_0110_0010_0001_1000_1011_1101_0100;
        #20 register_data = 32'b0000_1011_1001_1110_0101_0000_0111_0010;
        #20 register_data = 32'b1001_0001_0110_1011_0011_1110_0000_1101;
        #20 register_data = 32'b0111_1110_0001_0100_1010_0011_1100_1000;
        #20 register_data = 32'b1100_0101_1010_1000_0110_1101_0001_0011;
        #20 register_data = 32'b0010_1000_1111_0011_1101_0100_1011_0110;
        #20 clk_2 = 0;
        register_data = 0;
        done_initializing_registers = 1;
    end

    // data memory initialization
    // vector 1: (0, 2, 0, 1, 8, 8, 9, 6, 1)
    // vector 2: (1, 3, 1, 2, 9, 9, 0, 7, 2)
    initial
    begin
        done_initializing_data_memory = 0;
        write_mem = 1;
        #4  data_memory = 0;
        address_memory = 0;
        #20 data_memory = 2;
        address_memory = address_memory + 4;
        #20 data_memory = 0;
        address_memory = address_memory + 4;
        #20 data_memory = 1;
        address_memory = address_memory + 4;
        #20 data_memory = 8;
        address_memory = address_memory + 4;
        #20 data_memory = 8;
        address_memory = address_memory + 4;
        #20 data_memory = 9;
        address_memory = address_memory + 4;
        #20 data_memory = 6;
        address_memory = address_memory + 4;
        #20 data_memory = 1;
        address_memory = address_memory + 4;
        #20 data_memory = 1;
        address_memory = address_memory + 4;
        #20 data_memory = 3;
        address_memory = address_memory + 4;
        #20 data_memory = 1;
        address_memory = address_memory + 4;
        #20 data_memory = 2;
        address_memory = address_memory + 4;
        #20 data_memory = 9;
        address_memory = address_memory + 4;
        #20 data_memory = 9;
        address_memory = address_memory + 4;
        #20 data_memory = 0;
        address_memory = address_memory + 4;
        #20 data_memory = 7;
        address_memory = address_memory + 4;
        #20 data_memory = 2;
        address_memory = address_memory + 4;
        #20 data_memory = 32'b1000_1101_0011_0110_1111_1001_0100_0001;
        address_memory = address_memory + 4;
        #20 data_memory = 32'b0110_0001_1100_1010_0001_0111_1011_1110;
        address_memory = address_memory + 4;
        #20 data_memory = 32'b1101_1110_0000_0101_1010_1000_0011_0111;
        address_memory = address_memory + 4;
        #20 data_memory = 32'b0011_0100_1010_1111_1100_0001_0110_1001;
        address_memory = address_memory + 4;
        #20 clk_3 = 0;
        data_memory = 0;
        write_mem = 0;
        address_memory = 0;
        done_initializing_data_memory = 1;
    end


endmodule







