`timescale 1ns / 1ps

module TB_IF_ID_EX_STAGE;
    // universal inputs
    reg clk;
    reg reset;

    // IF STAGE 
    reg [31:0] input_instruction;
    wire [31:0] output_IF_instruction;
    wire [31:0] output_IF_program_counter;
    IF_STAGE IF_test(
        .clk_x61(clk),
        .reset_x61(reset),
        .input_instruction_x61(input_instruction), 
        .output_instruction_x61(output_IF_instruction),
        .program_counter_x61(output_IF_program_counter));
    
    // ID STAGE
    wire clk_id;
    reg [31:0] register_data;
    wire [31:0] output_ID_program_counter;
    wire [31:0] output_ID_rs_or_base_x61;
    wire [31:0] output_ID_rt_x61;
    wire [4:0] output_ID_rd_x61;
    wire [5:0] output_ID_op_x61;
    wire [5:0] output_ID_funct_x61;
    wire [31:0] output_ID_imm_x61;
    wire [25:0] output_ID_jump_index_x61;
    ID_STAGE ID_test(
        .clk_x61(clk_id),
        .reset_x61(reset),
        .register_data_x61(register_data),
        .input_instruction_x61(output_IF_instruction), 
        .input_program_counter_x61(output_IF_program_counter),
        .output_program_counter_x61(output_ID_program_counter),
        .ff_rs_or_base_x61(output_ID_rs_or_base_x61),
        .ff_rt_x61(output_ID_rt_x61),
        .ff_rd_x61(output_ID_rd_x61),
        .ff_op_x61(output_ID_op_x61),
        .ff_funct_x61(output_ID_funct_x61),
        .ff_imm_x61(output_ID_imm_x61),
        .ff_jump_index_x61(output_ID_jump_index_x61));
    
    // EX STAGE
    wire [31:0] output_EX_program_counter_x61; 
    wire [4:0] output_EX_rd_x61; 
    wire [31:0] output_EX_alu_output_x61;
    wire output_EX_branch_taken_x61;
    wire [5:0] output_EX_op_x61;
    wire [5:0] output_EX_funct_x61;
    EX_STAGE EX_test(
        .clk_x61(clk),
        .reset_x61(reset),
        .rs_or_base_x61(output_ID_rs_or_base_x61), 
        .rt_x61(output_ID_rt_x61),
        .rd_x61(output_ID_rd_x61),
        .op_x61(output_ID_op_x61),
        .funct_x61(output_ID_funct_x61),
        .imm_x61(output_ID_imm_x61),
        .jump_index_x61(output_ID_jump_index_x61),
        .input_program_counter_x61(output_ID_program_counter),
        .output_program_counter_x61(output_EX_program_counter_x61),
        .ff_rd_x61(output_EX_rd_x61),
        .ff_alu_output_x61(output_EX_alu_output_x61),
        .ff_branch_taken_x61(output_EX_branch_taken_x61),
        .ff_op_x61(output_EX_op_x61),
        .ff_funct_x61(output_EX_funct_x61));

    // clk generation
    initial
    begin
        clk = 0;
        clk_2 = 0;
        reset = 1;
        #3
        reset = 0;
    end

    reg done_initializing_instructions;
    reg done_initializing_registers;
    reg clk_2;
    assign clk_id = clk ^ clk_2;
    always 
    begin
        #10
        if(done_initializing_instructions & done_initializing_registers & !clk_2)
        begin
            clk = ~clk;
        end
        else
            clk_2 = ~clk_2;
    end

    // instruction memory initialization 
    initial
    begin
        done_initializing_instructions = 0;
        #3 input_instruction = 32'b000000_00000_00000_00001_00000_100001;
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
        
        #1000
        $finish;
    end

    // register initialization
    initial
    begin
        done_initializing_registers = 0;
        #5  register_data = 32'b1011_0010_0110_1101_0001_1110_1000_0101;
        #20 register_data = 32'b0100_1111_1001_0011_0110_0000_1101_1010;
        #20 register_data = 32'b1110_0001_0101_1011_1100_0111_0010_1001;
        #20 register_data = 32'b0001_1010_1111_0100_0011_1001_0101_0110;
        #20 register_data = 32'b1000_0111_0000_1101_1010_0011_1111_0001;
        #20 register_data = 32'b0110_1100_1011_1000_0101_1110_0001_0111;
        #20 register_data = 32'b1101_0011_0111_0001_1001_0100_1010_1100;
        #20 register_data = 32'b0011_1001_1100_0110_1111_0000_0100_1011;
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
        done_initializing_registers = 1;
    end

endmodule

// module TB_IF_STAGE;
//     reg clk;
//     reg reset;
//     reg [31:0] input_instruction;
//     wire [31:0] output_instruction;
//     reg done_initializing_instructions;


//     IF_STAGE test(
//         .clk_x61(clk),
//         .reset_x61(reset),
//         .input_instruction_x61(input_instruction), 
//         .output_instruction_x61(output_instruction));

//     // clk generation
//     initial
//     begin
//         clk = 0;
//         reset = 1;
//         #5
//         reset = 0;
//     end

//     always 
//     begin
//         #10
//         if(done_initializing_instructions)
//             clk <= ~clk;
//     end

//     // instruction memory initialization
//     initial
//     begin
//         done_initializing_instructions = 0;
//         #5 input_instruction = 32'b000000_00000_00000_00001_00000_100001;
//         #1 input_instruction = 32'b000100_00111_00000_0000_0000_0010_0000;
//         #1 input_instruction = 32'b100011_00011_00010_0000_0000_0000_0000;
//         #1 input_instruction = 32'b100011_00101_00100_0000_0000_0000_0000;
//         #1 input_instruction = 32'b000000_00010_00100_00010_00000_011000;
//         #1 input_instruction = 32'b000000_00001_00010_00001_00000_100001;
//         #1 input_instruction = 32'b001001_00011_00011_0000_0000_0000_0100;
//         #1 input_instruction = 32'b001001_00101_00101_0000_0000_0000_0100;
//         #1 input_instruction = 32'b001001_00111_00111_1111_1111_1111_1111;
//         #1 input_instruction = 32'b000010_00_0000_0000_0000_0000_0000_1000;
//         #1 input_instruction = 32'b000000_11111_000_0000_0000_0000_001000;
//         #1 done_initializing_instructions = 1;
        
//         #300
//         $finish;
//     end

// endmodule







