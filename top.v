`timescale 1ns / 1ps

module DOT_PRODUCT(clk_x61, reset_x61, input_instruction_x61, register_data_x61, clk_id_x61, clk_mem_x61, external_data_memory_x61, external_write_mem_x61, external_address_memory_x61);
  input wire clk_x61;
  input wire clk_id_x61;
  input wire clk_mem_x61;
  input wire reset_x61;
  input wire [31:0] input_instruction_x61;
  input wire [31:0] register_data_x61;
  input wire [31:0] external_data_memory_x61;
  input wire [31:0] external_address_memory_x61;
  input wire external_write_mem_x61;

  wire [31:0] output_EX_alu_output_x61;
  wire output_EX_branch_taken_x61;
  wire [31:0] output_WB_register_data_x61;
  wire [4:0] output_WB_register_destination_x61;
  wire output_WB_enable_write_x61;
  wire branch_jump_stall_x61;

  // IF STAGE 
  wire [31:0] output_IF_instruction;
  wire [31:0] output_IF_program_counter;
  IF_STAGE IF_test(
      .clk_x61(clk_x61),
      .reset_x61(reset_x61),
      .input_instruction_x61(input_instruction_x61),
      .branch_taken_x61(output_EX_branch_taken_x61),
      .alu_from_EX_x61(output_EX_alu_output_x61),
      .stall_x61(branch_jump_stall_x61),
      .output_instruction_x61(output_IF_instruction),
      .program_counter_x61(output_IF_program_counter));
  
  // ID STAGE
  wire [31:0] output_ID_program_counter;
  wire [31:0] output_ID_rs_or_base_x61;
  wire [31:0] output_ID_rt_x61;
  wire [4:0] output_ID_rd_x61;
  wire [5:0] output_ID_op_x61;
  wire [5:0] output_ID_funct_x61;
  wire [31:0] output_ID_imm_x61;
  wire [25:0] output_ID_jump_index_x61;
  wire [4:0] output_ID_raw_rt_x61;
  ID_STAGE ID_test(
      .clk_x61(clk_id_x61),
      .reset_x61(reset_x61),
      .register_data_x61(register_data_x61),
      .input_instruction_x61(output_IF_instruction), 
      .input_program_counter_x61(output_IF_program_counter),
      .output_program_counter_x61(output_ID_program_counter),
      .ff_rs_or_base_x61(output_ID_rs_or_base_x61),
      .ff_rt_x61(output_ID_rt_x61),
      .ff_raw_rt_x61(output_ID_raw_rt_x61),
      .ff_rd_x61(output_ID_rd_x61),
      .ff_op_x61(output_ID_op_x61),
      .ff_funct_x61(output_ID_funct_x61),
      .ff_imm_x61(output_ID_imm_x61),
      .ff_jump_index_x61(output_ID_jump_index_x61),
      .register_wb_data(output_WB_register_data_x61),
      .register_wb_destination(output_WB_register_destination_x61),
      .register_wb_enable(output_WB_enable_write_x61));
  

  // EX STAGE
  wire [4:0] output_EX_rd_x61; 
  wire [31:0] output_EX_rt_x61; 
  wire output_EX_read_mem_x61;
  wire output_EX_write_mem_x61;
  wire output_EX_write_reg_x61;
  EX_STAGE EX_test(
      .clk_x61(clk_x61),
      .reset_x61(reset_x61),
      .rs_or_base_x61(output_ID_rs_or_base_x61), 
      .rt_x61(output_ID_rt_x61),
      .raw_rt_x61(output_ID_raw_rt_x61),
      .rd_x61(output_ID_rd_x61),
      .op_x61(output_ID_op_x61),
      .funct_x61(output_ID_funct_x61),
      .imm_x61(output_ID_imm_x61),
      .jump_index_x61(output_ID_jump_index_x61),
      .input_program_counter_x61(output_ID_program_counter),
      .ff_rd_x61(output_EX_rd_x61),
      .ff_alu_output_x61(output_EX_alu_output_x61),
      .ff_branch_taken_x61(output_EX_branch_taken_x61),
      .ff_read_mem_x61(output_EX_read_mem_x61),
      .ff_write_mem_x61(output_EX_write_mem_x61),
      .ff_write_reg_x61(output_EX_write_reg_x61),
      .ff_rt_x61(output_EX_rt_x61));

  // MEM STAGE
  wire [31:0] output_MEM_mem_output;
  wire [31:0] output_MEM_alu_x61;
  wire [4:0] output_MEM_rd_x61;
  wire output_MEM_write_reg_x61;
  wire output_MEM_read_mem_x61;

  wire [31:0] data_memory_x61;
  assign data_memory_x61 = output_EX_rt_x61 ^ external_data_memory_x61;
  wire [31:0] address_memory_x61;
  assign address_memory_x61 = output_EX_alu_output_x61 ^ external_address_memory_x61;
  wire write_mem_x61;
  assign write_mem_x61 = output_EX_write_mem_x61 ^ external_write_mem_x61;

  MEM_STAGE MEM_test(
      .clk_x61(clk_mem_x61),
      .reset_x61(reset_x61),
      .rt_x61(data_memory_x61),
      .rd_x61(output_EX_rd_x61),
      .alu_x61(address_memory_x61),
      .read_mem_x61(output_EX_read_mem_x61),
      .write_mem_x61(write_mem_x61),
      .write_reg_x61(output_EX_write_reg_x61),
      .ff_mem_output(output_MEM_mem_output),
      .ff_alu_x61(output_MEM_alu_x61),
      .ff_rd_x61(output_MEM_rd_x61),
      .ff_write_reg_x61(output_MEM_write_reg_x61),
      .ff_read_mem_x61(output_MEM_read_mem_x61));

  // WB STAGE
  WB_STAGE WB_test(
      .clk_x61(clk_x61),
      .reset_x61(reset_x61),
      .input_mem_output_x61(output_MEM_mem_output),
      .input_alu_x61(output_MEM_alu_x61),
      .input_rd_x61(output_MEM_rd_x61),
      .input_write_reg_x61(output_MEM_write_reg_x61),
      .input_read_mem_x61(output_MEM_read_mem_x61),
      .output_register_data_x61(output_WB_register_data_x61),
      .output_register_destination_x61(output_WB_register_destination_x61),
      .output_enable_write_x61(output_WB_enable_write_x61));

  // STALLING for BRANCHES and JUMPS
  STALLING_JUMP_N_BRANCH branch_jump_stalling(
      .clk_x61(clk_x61),
      .reset_x61(reset_x61),
      .input_instruction_x61(output_IF_instruction),
      .stall_x61(branch_jump_stall_x61));


endmodule

module IF_STAGE(clk_x61, reset_x61, input_instruction_x61, branch_taken_x61, alu_from_EX_x61, stall_x61, output_instruction_x61, program_counter_x61);
  input wire clk_x61;  
  input wire reset_x61;
  input wire [31:0] input_instruction_x61;
  input wire branch_taken_x61;
  input wire [31:0] alu_from_EX_x61;
  input wire stall_x61;
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
    else if(branch_taken_x61)
    begin
      next_program_counter_x61 = (program_counter_x61 < 4*max_instruction_count - 4) ? alu_from_EX_x61 + 4: alu_from_EX_x61;
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

    else if(stall_x61)
    begin
      program_counter_x61 <= program_counter_x61;
      output_instruction_x61 <= 0;
    end


    else
    begin
      program_counter_x61 <= next_program_counter_x61;
      if(branch_taken_x61)
      begin
        output_instruction_x61 <= {instr_mem_x61[alu_from_EX_x61 + 3],
                                   instr_mem_x61[alu_from_EX_x61 + 2],
                                   instr_mem_x61[alu_from_EX_x61 + 1],
                                   instr_mem_x61[alu_from_EX_x61 + 0]};
      end
      
      else
      begin
        output_instruction_x61 <= {instr_mem_x61[program_counter_x61 + 3],
                                   instr_mem_x61[program_counter_x61 + 2],
                                   instr_mem_x61[program_counter_x61 + 1],
                                   instr_mem_x61[program_counter_x61 + 0]};
      end
    end
  end
endmodule

module ID_STAGE(clk_x61, reset_x61, register_data_x61, input_instruction_x61, input_program_counter_x61, output_program_counter_x61, ff_rs_or_base_x61, ff_rt_x61, ff_raw_rt_x61, ff_rd_x61, ff_op_x61, ff_funct_x61, ff_imm_x61, ff_jump_index_x61, register_wb_data, register_wb_destination, register_wb_enable);
  input wire clk_x61;  
  input wire reset_x61;
  input wire [31:0] register_data_x61;
  input wire [31:0] input_instruction_x61;  // output from IF_STAGE; input to ID_STAGE
  input wire [31:0] input_program_counter_x61;
  output reg [31:0] output_program_counter_x61;
  output reg [31:0] ff_rs_or_base_x61;
  output reg [31:0] ff_rt_x61;
  output reg [4:0] ff_raw_rt_x61;
  output reg [4:0] ff_rd_x61;
  output reg [5:0] ff_op_x61;
  output reg [5:0] ff_funct_x61;
  output reg [31:0] ff_imm_x61;
  output reg [25:0] ff_jump_index_x61;
  input wire [31:0] register_wb_data;
  input wire [4:0] register_wb_destination;
  input wire register_wb_enable;

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
        if(register_wb_enable)
          register_file[register_wb_destination] <= register_wb_data;
      end

    end


    else if(clk_x61)
    begin
      ff_rs_or_base_x61 <= register_file[rs_or_base];
      ff_rt_x61 <= register_file[rt];
      ff_raw_rt_x61 <= rt;
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


module EX_STAGE(clk_x61, reset_x61, rs_or_base_x61, rt_x61, raw_rt_x61, rd_x61, op_x61, funct_x61, imm_x61, jump_index_x61, input_program_counter_x61, ff_rd_x61, ff_alu_output_x61, ff_branch_taken_x61, ff_read_mem_x61, ff_write_mem_x61, ff_write_reg_x61, ff_rt_x61);
  input wire clk_x61;
  input wire reset_x61;
  input wire [31:0] rs_or_base_x61; 
  input wire [31:0] rt_x61; 
  input wire [4:0] raw_rt_x61; 
  input wire [4:0] rd_x61;
  input wire [5:0] op_x61;  
  input wire [5:0] funct_x61; 
  input wire [31:0] imm_x61;  
  input wire [25:0] jump_index_x61;
  input wire [31:0] input_program_counter_x61;
  output reg [4:0] ff_rd_x61; 
  output reg [31:0] ff_alu_output_x61;
  output reg ff_branch_taken_x61;
  output reg ff_read_mem_x61;
  output reg ff_write_mem_x61;
  output reg ff_write_reg_x61;
  output reg [31:0] ff_rt_x61; 


  `include "functions.v"

  reg [36:0] alu_output;
  always@(*)
  begin
    if(reset_x61)
      alu_output = 36'b0000_00000000_00000000_00000000_00000000;
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
      ff_rd_x61 <= 0;
      ff_write_reg_x61 <= 0;
      ff_write_mem_x61 <= 0;
      ff_read_mem_x61 <= 0;
      ff_rt_x61 <= 0;
    end

    else
    begin
      ff_alu_output_x61 <= alu_output[31:0];
      ff_branch_taken_x61 <= alu_output[32];
      ff_write_reg_x61 <= alu_output[33];
      ff_write_mem_x61 <= alu_output[34];
      ff_read_mem_x61 <= alu_output[35];
      ff_rt_x61 <= rt_x61;

      if(op_x61 == 6'b00_0011) // JAL
        ff_rd_x61 <= 31;
      else if(alu_output[36]) // alu_output[36] is get_raw_rt flag
        ff_rd_x61 <= raw_rt_x61;
      else
        ff_rd_x61 <= rd_x61;
    end
  end
endmodule


module MEM_STAGE(clk_x61, reset_x61, rt_x61, rd_x61, alu_x61, read_mem_x61, write_mem_x61, write_reg_x61, ff_mem_output, ff_alu_x61, ff_rd_x61, ff_write_reg_x61, ff_read_mem_x61);
  input wire clk_x61;
  input wire reset_x61;
  input wire [31:0] rt_x61;
  input wire [4:0] rd_x61; 
  input wire [31:0] alu_x61;
  input wire read_mem_x61;
  input wire write_mem_x61;
  input wire write_reg_x61;
  output reg [31:0] ff_mem_output;
  output reg [31:0] ff_alu_x61;
  output reg [4:0] ff_rd_x61;
  output reg ff_write_reg_x61;
  output reg ff_read_mem_x61;

  // 1024 bytes / 4bytes/word = 256 words; kinda byte addressable
  // 8 bits for each row x 1024 rows
  localparam max_memory_bytes = 144;
  localparam max_memory_words = max_memory_bytes/4;
  reg [7:0] data_mem_x61 [max_memory_bytes - 1:0];    
                                            
  integer i;
  // initialize to 0 on reset
  // read and write
  always@(posedge clk_x61 or posedge reset_x61)
  begin
    if(reset_x61)
    begin
      ff_mem_output <= 0;
      for(i = 0; i < max_memory_bytes; i=i+1)
      begin
        data_mem_x61[i] <= 0;
      end
    end
    
    else
    begin
      if(read_mem_x61)
      begin
        if(alu_x61[31:2] < max_memory_words)
        begin
          ff_mem_output[7:0] <= data_mem_x61[(({alu_x61[31:2], 2'b00})*4 + 0)];
          ff_mem_output[15:8] <= data_mem_x61[(({alu_x61[31:2], 2'b00})*4 + 1)];
          ff_mem_output[23:16] <= data_mem_x61[(({alu_x61[31:2], 2'b00})*4 + 2)];
          ff_mem_output[31:24] <= data_mem_x61[(({alu_x61[31:2], 2'b00})*4 + 3)];
        end
      end

      else if(write_mem_x61)
      begin
        data_mem_x61[(({alu_x61[31:2]})*4 + 0)] <= rt_x61[7:0];
        data_mem_x61[(({alu_x61[31:2]})*4 + 1)] <= rt_x61[15:8];
        data_mem_x61[(({alu_x61[31:2]})*4 + 2)] <= rt_x61[23:16];
        data_mem_x61[(({alu_x61[31:2]})*4 + 3)] <= rt_x61[31:24];
      end
    end
  end

  always@(posedge clk_x61 or posedge reset_x61)
  begin
    if(reset_x61)
    begin
      ff_alu_x61 <= 0;
      ff_rd_x61 <= 0;
      ff_write_reg_x61 <= 0;
      ff_read_mem_x61 <= 0;
    end

    else
    begin
      ff_alu_x61 <= alu_x61;
      ff_rd_x61 <= rd_x61;
      ff_read_mem_x61 <= read_mem_x61;
      ff_write_reg_x61 <= write_reg_x61;
    end
  end
endmodule

module WB_STAGE(clk_x61, reset_x61, input_mem_output_x61, input_alu_x61, input_rd_x61, input_write_reg_x61, input_read_mem_x61, output_register_data_x61, output_register_destination_x61, output_enable_write_x61);
  input wire clk_x61;
  input wire reset_x61;
  input wire [31:0] input_mem_output_x61;
  input wire [31:0] input_alu_x61;
  input wire [4:0] input_rd_x61;
  input wire input_write_reg_x61;
  input wire input_read_mem_x61;
  output wire [31:0] output_register_data_x61;
  output wire [4:0] output_register_destination_x61;
  output wire output_enable_write_x61;

  assign output_register_data_x61 = reset_x61 ? 0 : (input_read_mem_x61 ? input_mem_output_x61 : input_alu_x61);
  assign output_register_destination_x61 = reset_x61 ? 0 : input_rd_x61;
  assign output_enable_write_x61 = reset_x61 ? 0 : input_write_reg_x61;
endmodule


module STALLING_JUMP_N_BRANCH(clk_x61, reset_x61, input_instruction_x61, stall_x61);
  input wire clk_x61;  
  input wire reset_x61;
  input wire [31:0] input_instruction_x61;  // output from IF_STAGE; input to ID_STAGE
  output reg stall_x61;

  reg [1:0] current_state_x61;
  reg [1:0] next_state_x61;

  localparam s0 = 0,
             s1 = 1,
             s2 = 2;

  wire [5:0] op_code;
  wire [5:0] funct;
  assign op_code = input_instruction_x61[31:26];
  assign funct = input_instruction_x61[5:0];
  
  always@(*)
  begin
    if(current_state_x61 == s0)
    begin
      if((op_code == 6'b00_0100) |    // BEQ
        (op_code == 6'b00_0010) |    // J
        (op_code == 6'b00_0011) |    // J
        ((op_code == 6'b00_0000) & (funct == 6'b00_1000)))  // JR
      begin
        next_state_x61 = s1;
        stall_x61 = 1;
      end
      
      else
      begin
        next_state_x61 = s0;
        stall_x61 = 0;
      end

    end

    else if(current_state_x61 == s1)
    begin
      next_state_x61 = s2;
      stall_x61 = 1;
    end

    else if(current_state_x61 == s2)
    begin
      next_state_x61 = s0;
      stall_x61 = 0;
    end
  end


  always@(posedge clk_x61 or posedge reset_x61)
  begin
    if(reset_x61)
      current_state_x61 <= 0;
    else
      current_state_x61 <= next_state_x61;
  end
endmodule






