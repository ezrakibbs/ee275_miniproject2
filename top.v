`timescale 1ns / 1ps

module IF_STAGE(clk_x61, reset_x61, input_instruction_x61, output_instruction_x61);
  input wire clk_x61;  
  input wire reset_x61;
  input wire [31:0] input_instruction_x61;
  output reg [31:0] output_instruction_x61;


  localparam max_instruction_count = 11;
  
  reg [7:0] instr_mem_x61 [43:0]; // 11instr x 4bytes/instr = 44bytes; byte addressable
  reg [3:0] write_index_x61;
  integer i;
  always @(*)
  begin
    if(reset_x61)
    begin
      write_index_x61 = 0;
      for(i = 0; i < 44; i= i +1)
      begin
        instr_mem_x61[i] = 8'b0000_0000;
      end
    end
    
    else if(write_index_x61 < max_instruction_count)
    begin
      instr_mem_x61[write_index_x61*4 + 0] = input_instruction_x61[7:0];
      instr_mem_x61[write_index_x61*4 + 1] = input_instruction_x61[15:8];
      instr_mem_x61[write_index_x61*4 + 2] = input_instruction_x61[23:16];
      instr_mem_x61[write_index_x61*4 + 3] = input_instruction_x61[31:24];
      write_index_x61 = write_index_x61 + 1;
    end
  end

  reg [5:0] next_program_counter_x61;
  always @(*)
  begin
    if(reset_x61)
    begin
      next_program_counter_x61 = 0;
    end
    else
    begin
      next_program_counter_x61 = (program_counter_x61 < 4*max_instruction_count - 4) ? program_counter_x61 + 4: program_counter_x61;
    end
  end

  reg [5:0] program_counter_x61;
  always @(posedge clk_x61 or posedge reset_x61)
  begin
    program_counter_x61 <= next_program_counter_x61;
    output_instruction_x61 <= {instr_mem_x61[program_counter_x61 + 3],
                               instr_mem_x61[program_counter_x61 + 2],
                               instr_mem_x61[program_counter_x61 + 1],
                               instr_mem_x61[program_counter_x61 + 0]};
  end
endmodule