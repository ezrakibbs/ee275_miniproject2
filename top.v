`timescale 1ns / 1ps

module IF_STAGE(clk_x61, reset_x61, input_instruction_x61, output_instruction_x61, program_counter_x61);
  input wire clk_x61;  
  input wire reset_x61;
  input wire [31:0] input_instruction_x61;
  output reg [31:0] output_instruction_x61;
  output reg [31:0] program_counter_x61;


  localparam max_instruction_count = 11;
  
  reg [7:0] instr_mem_x61 [43:0]; // 11instr x 4bytes/instr = 44bytes; byte addressable
                                  // 8 bits for each row x 44 rows
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

  reg [31:0] next_program_counter_x61;
  always @(*)
  begin
    if(reset_x61)
    begin
      next_program_counter_x61 = 32'b00000000_00000000_00000000_00000000;
    end
    else
    begin
      next_program_counter_x61 = (program_counter_x61 < 4*max_instruction_count - 4) ? program_counter_x61 + 4: program_counter_x61;
    end
  end

  always @(posedge clk_x61 or posedge reset_x61)
  begin
    if(reset_x61)
    begin
      program_counter_x61 <= 32'b00000000_00000000_00000000_00000000;
      output_instruction_x61 <= 32'b00000000_00000000_00000000_00000000;
    end
    else
    begin
      program_counter_x61 <= next_program_counter_x61;
      output_instruction_x61 <= {instr_mem_x61[program_counter_x61 + 3],
                                instr_mem_x61[program_counter_x61 + 2],
                                instr_mem_x61[program_counter_x61 + 1],
                                instr_mem_x61[program_counter_x61 + 0]};
    end
  end
endmodule

module ID_STAGE(clk_x61, reset_x61, register_data_x61, input_instruction_x61, input_program_counter_x61, output_program_counter_x61, ff_rs_or_base_x61, ff_rt_x61, ff_rd_x61, ff_op_x61, ff_funct_x61, ff_imm_x61, ff_jump_index_x61);
  input wire clk_x61;  
  input wire reset_x61;
  input wire [31:0] register_data_x61;
  input wire [31:0] input_instruction_x61;  // output from IF_STAGE; input to ID_STAGE
  input wire [31:0] input_program_counter_x61;
  output reg [31:0] output_program_counter_x61;
  output reg [31:0] ff_rs_or_base_x61;
  output reg [31:0] ff_rt_x61;
  output reg [4:0] ff_rd_x61;
  output reg [5:0] ff_op_x61;
  output reg [5:0] ff_funct_x61;
  output reg [31:0] ff_imm_x61;
  output reg [25:0] ff_jump_index_x61;

  wire [4:0] rs_or_base;
  wire [4:0] rt;
  wire [4:0] rd;
  wire [5:0] op_code;
  wire [5:0] funct;
  wire [15:0] offset;
  wire [25:0] jump_index;
  assign rs_or_base = input_instruction_x61[25:21];
  assign rt = input_instruction_x61[20:16];
  assign rd = input_instruction_x61[15:11];
  assign op_code = input_instruction_x61[31:26];
  assign funct = input_instruction_x61[5:0];
  assign offset = input_instruction_x61[15:0];
  assign jump_index = input_instruction_x61[25:0];

  localparam max_register_count = 32;
  // example array
  // reg[31:0] array [7:0]
  // array has 8 elements, each element is 32 bits long
  reg [31:0] register_file [max_register_count-1:0]; // max_register_count registers of 32 bits
  reg [5:0] initial_write_index_x61;  // 6 bits needed to represent numbers 0-32 (33 values)
  integer i;
  // initialize to 0 on reset
  // read and write
  always@(posedge clk_x61 or posedge reset_x61 or negedge clk_x61)
  begin
    if(reset_x61)
    begin
      initial_write_index_x61 <= 0;
      for(i = 0; i < max_register_count; i=i+1)
      begin
        register_file[i] <= 32'b00000000_00000000_00000000_00000000;
      end

      ff_rs_or_base_x61 <= 0;
      ff_rt_x61 <= 0;
      ff_rd_x61 <= 0; 
      ff_op_x61 <= 0; 
      ff_funct_x61 <= 0;
      ff_jump_index_x61 <= 0;
      output_program_counter_x61 <= 0;
      ff_imm_x61 <= 0;
    end
    
    else if(!clk_x61)
    begin
      if(initial_write_index_x61 < max_register_count)
      begin
        initial_write_index_x61 <= initial_write_index_x61 + 1;
        if(initial_write_index_x61 != 0)
          register_file[initial_write_index_x61] <= register_data_x61;
      end

      else
      begin
        // if(write_enable)
        //   register_file[rd_input];
      end

    end


    else if(clk_x61)
    begin
      ff_rs_or_base_x61 <= register_file[rs_or_base];
      ff_rt_x61 <= register_file[rt];
      ff_rd_x61 <= rd;
      ff_op_x61 <= op_code;
      ff_funct_x61 <= funct;
      ff_jump_index_x61 <= jump_index;
      output_program_counter_x61 <= input_program_counter_x61;
      // sign extend 16 -> 32bits
      if(offset[15])  // negative
        ff_imm_x61 <= {offset[15], 16'b1111_1111_1111_1111, offset[14:0]};
      else            // positive
        ff_imm_x61 <= {offset[15], 16'b0000_0000_0000_0000, offset[14:0]};
    end
  end
endmodule


module EX_STAGE(clk_x61, reset_x61, rs_or_base_x61, rt_x61, rd_x61, op_x61, funct_x61, imm_x61, jump_index_x61, input_program_counter_x61, output_program_counter_x61, ff_rd_x61, ff_alu_output_x61, ff_branch_taken_x61, ff_op_x61, ff_funct_x61);
  input wire clk_x61;
  input wire reset_x61;
  input wire [31:0] rs_or_base_x61; 
  input wire [31:0] rt_x61; 
  input wire [4:0] rd_x61;
  input wire [5:0] op_x61;  
  input wire [5:0] funct_x61; 
  input wire [31:0] imm_x61;  
  input wire [25:0] jump_index_x61;
  input wire [31:0] input_program_counter_x61;
  output reg [31:0] output_program_counter_x61; 
  output reg [4:0] ff_rd_x61; 
  output reg [31:0] ff_alu_output_x61;
  output reg ff_branch_taken_x61;
  output reg [5:0] ff_op_x61;
  output reg [5:0] ff_funct_x61;

  `include "functions.v"

  reg [32:0] alu_output;
  always@(*)
  begin
    if(reset_x61)
      alu_output = 33'b0_00000000_00000000_00000000_00000000;
    else
    begin
      alu_output = alu(input_program_counter_x61,
                       rs_or_base_x61,
                       rt_x61,
                       funct_x61,
                       imm_x61,
                       jump_index_x61,
                       op_x61);
    end
  end
    
  always@(posedge clk_x61 or posedge reset_x61)
  begin
    if(reset_x61)
    begin
      ff_alu_output_x61 <= 0;
      ff_branch_taken_x61 <= 0;
      ff_op_x61 <= 0;
      ff_funct_x61 <= 0;
      ff_rd_x61 <= 0;
      output_program_counter_x61 <= 0;
    end

    else
    begin
      ff_alu_output_x61 <= alu_output[31:0];
      ff_branch_taken_x61 <= alu_output[32];
      ff_op_x61 <= op_x61;
      ff_funct_x61 <= funct_x61;
      output_program_counter_x61 <= input_program_counter_x61;

      if(op_x61 == 6'b00_0011) // JAL
        ff_rd_x61 <= 31;
      else
        ff_rd_x61 <= rd_x61;
    end
  end
endmodule

// module MEM_STAGE(clk_x61, reset_x61, output_program_counter_x61, ff_rd_x61, ff_alu_output_x61, ff_branch_taken_x61, ff_op_x61, ff_funct_x61);

// endmodule


//   output reg [31:0] output_program_counter_x61; 
//   output reg [4:0] ff_rd_x61; 
//   output reg [31:0] ff_alu_output_x61;
//   output reg ff_branch_taken_x61;
//   output reg [5:0] ff_op_x61;
//   output reg [5:0] ff_funct_x61;
/* might need later

  localparam r_type = 0,
             j_type = 1,
             i_type = 2;

  reg [2:0] instruction_format;
  always@(*)
  begin
    casex(op_code) 
      6'b00_0000: instruction_format = r_type;
      6'b00_001X: instruction_format = j_type;
      default   : instruction_format = i_type;
    endcase
  end



*/


