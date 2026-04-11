function [32:0] alu;  // 32 bits for ALU operation + 1 bit to indicate branch instruction bit
  input [31:0] alu_npc_x61;
  input [31:0] alu_rs_or_base_x61;
  input [31:0] alu_rt_x61;
  input [5:0] alu_funct_x61;
  input [31:0] alu_imm_x61;
  input [25:0] alu_jump_index_x61;
  input [5:0] alu_op_x61;

  localparam r_type = 0,
             j_type = 1,
             i_type = 2;

  reg [2:0] alu_instruction_format_x61;
  reg [31:0] alu_output;
  reg branch_taken;
  begin
    branch_taken = 0; // set to branch not taken by default

    casex(alu_op_x61) 
      6'b00_0000: alu_instruction_format_x61 = r_type;
      6'b00_001X: alu_instruction_format_x61 = j_type;
      default   : alu_instruction_format_x61 = i_type;
    endcase

    if(alu_instruction_format_x61 == r_type)
    begin
      case(alu_funct_x61)
        6'b10_0001: alu_output = alu_rs_or_base_x61 + alu_rt_x61;  // ADDU
        6'b10_0011: alu_output = alu_rs_or_base_x61 - alu_rt_x61;  // SUBU
        6'b01_1000: alu_output = alu_rs_or_base_x61 * alu_rt_x61;  // MULT (modified; assume 1 instruction)
        6'b00_1000: begin
                    alu_output = alu_rs_or_base_x61;               // JR
                    branch_taken = 1'b1;
        end
        default   : alu_output = 32'b00000000_00000000_00000000_00000000;
      endcase
    end

    else if(alu_instruction_format_x61 == j_type)
    begin
      alu_output = {alu_npc_x61[31:28], alu_jump_index_x61[25:0], 2'b00};  // J
      branch_taken = 1'b1;
    end

    else if(alu_instruction_format_x61 == i_type)
    begin
      if(alu_op_x61 == 6'b00_0100)  // BEQ
      begin
        alu_output = alu_npc_x61 + alu_imm_x61;
        if(alu_rs_or_base_x61 == alu_rt_x61)
          branch_taken = 1'b1;
      end
      else
        alu_output = alu_rs_or_base_x61 + alu_imm_x61; // LW
    end

    alu = {branch_taken, alu_output};

  end
endfunction