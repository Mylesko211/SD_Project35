//----------------------------------------------------------------------
// Created with uvmf_gen version 2026.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class records i2c transaction information using
//       a covergroup named i2c_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class i2c_transaction_coverage #(
      int I2C_ADDR_WIDTH = 7,
      int I2C_DATA_WIDTH = 8,
      int I2C_SLAVE_ADDRESS = 8'h22
      )
 extends uvm_subscriber #(.T(i2c_transaction #(
                                            .I2C_ADDR_WIDTH(I2C_ADDR_WIDTH),
                                            .I2C_DATA_WIDTH(I2C_DATA_WIDTH),
                                            .I2C_SLAVE_ADDRESS(I2C_SLAVE_ADDRESS)
                                            )
));

  `uvm_component_param_utils( i2c_transaction_coverage #(
                              I2C_ADDR_WIDTH,
                              I2C_DATA_WIDTH,
                              I2C_SLAVE_ADDRESS
                              )
)

  T coverage_trans;

  // pragma uvmf custom class_item_additional begin
  bit [7:0] sampled_reg_addr;
  bit [7:0] sampled_data_value;
  bit [7:0] last_otp_addr_value;
  bit [7:0] last_test_key_0;
  bit [7:0] last_test_key_1;
  bit       inferred_test_mode;
  int unsigned read_samples;
  int unsigned write_samples;
  int unsigned otp_cmd_write_samples;
  int unsigned otp_addr_write_samples;
  int unsigned otp_status_read_samples;
  int unsigned otp_status_write_samples;
  int unsigned wd_ctrl_write_samples;
  int unsigned sys_ctrl_write_samples;
  int unsigned int_ctrl_write_samples;
  int unsigned i2c_read_ptr_write_samples;
  int unsigned test_reg_write_samples;
  int unsigned test_mode_access_samples;
  int unsigned invalid_access_samples;
  int unsigned general_reg_pattern_samples;
  int unsigned trim_reg_access_samples;
  int unsigned ctrl_reg_access_samples;
  int unsigned int_ctrl_reserved_attempt_samples;

  function automatic bit get_sampled_reg_addr(input T t, output bit [7:0] reg_addr);
    if (t.reg_addr_valid) begin
      reg_addr = t.reg_addr_dbg;
      return 1'b1;
    end
    if ((t.op == I2C_WR) && (t.data.size() > 0)) begin
      reg_addr = t.data[0];
      return 1'b1;
    end
    return 1'b0;
  endfunction

  function automatic bit get_sampled_data_value(input T t, output bit [7:0] data_value);
    if (t.data.size() == 0) begin
      return 1'b0;
    end
    if (t.op == I2C_WR) begin
      if (t.data.size() < 2) begin
        return 1'b0;
      end
      data_value = t.data[1];
      return 1'b1;
    end
    data_value = t.data[0];
    return 1'b1;
  endfunction

  function automatic bit is_valid_reg_addr(input bit [7:0] reg_addr);
    return (i2c_transaction#()::is_legal_write_addr(reg_addr)
            || i2c_transaction#()::is_indirect_readable_addr(reg_addr));
  endfunction
  // pragma uvmf custom class_item_additional end
  
  // ****************************************************************************
  covergroup i2c_write_reg_cg with function sample(bit [7:0] reg_addr);
    // pragma uvmf custom covergroup begin
    option.per_instance=1;
    write_reg: coverpoint reg_addr {
      bins gen_reg0 = {8'h00};
      bins gen_reg1 = {8'h01};
      bins gen_reg2 = {8'h02};
      bins gen_reg3 = {8'h03};
      bins gen_reg4 = {8'h04};
      bins gen_reg5 = {8'h05};
      bins gen_reg6 = {8'h06};
      bins gen_reg7 = {8'h07};
      bins wd_ctrl = {8'h08};
      bins otp_cmd = {8'h09};
      bins otp_addr = {8'h0A};
      bins otp_status = {8'h0B};
      bins int_ctrl = {8'h0C};
      bins trim_reg0 = {8'h20};
      bins trim_reg1 = {8'h21};
      bins trim_reg2 = {8'h22};
      bins trim_reg3 = {8'h23};
      bins trim_reg4 = {8'h24};
      bins trim_reg5 = {8'h25};
      bins trim_reg6 = {8'h26};
      bins trim_reg7 = {8'h27};
      bins trim_reg8 = {8'h28};
      bins trim_reg9 = {8'h29};
      bins trim_regA = {8'h2A};
      bins trim_regB = {8'h2B};
      bins trim_regC = {8'h2C};
      bins trim_regD = {8'h2D};
      bins trim_regE = {8'h2E};
      bins trim_regF = {8'h2F};
      bins sys_ctrl = {8'h30};
      bins i2c_read_addr = {8'h31};
      bins test_reg = {8'h32};
    }
    // pragma uvmf custom covergroup end
  endgroup

  covergroup i2c_read_reg_cg with function sample(bit [7:0] reg_addr);
    // pragma uvmf custom covergroup begin
    option.per_instance=1;
    read_reg: coverpoint reg_addr {
      bins gen_reg0 = {8'h00};
      bins gen_reg1 = {8'h01};
      bins gen_reg2 = {8'h02};
      bins gen_reg3 = {8'h03};
      bins gen_reg4 = {8'h04};
      bins gen_reg5 = {8'h05};
      bins gen_reg6 = {8'h06};
      bins gen_reg7 = {8'h07};
      bins wd_ctrl = {8'h08};
      bins otp_cmd = {8'h09};
      bins otp_addr = {8'h0A};
      bins otp_status = {8'h0B};
      bins int_ctrl = {8'h0C};
      bins trim_reg0 = {8'h20};
      bins trim_reg1 = {8'h21};
      bins trim_reg2 = {8'h22};
      bins trim_reg3 = {8'h23};
      bins trim_reg4 = {8'h24};
      bins trim_reg5 = {8'h25};
      bins trim_reg6 = {8'h26};
      bins trim_reg7 = {8'h27};
      bins trim_reg8 = {8'h28};
      bins trim_reg9 = {8'h29};
      bins trim_regA = {8'h2A};
      bins trim_regB = {8'h2B};
      bins trim_regC = {8'h2C};
      bins trim_regD = {8'h2D};
      bins trim_regE = {8'h2E};
      bins trim_regF = {8'h2F};
      bins sys_ctrl = {8'h30};
      bins i2c_read_addr = {8'h31};
      bins test_reg = {8'h32};
    }
    // pragma uvmf custom covergroup end
  endgroup

  covergroup i2c_write_data_cg with function sample(bit [7:0] data_value);
    option.per_instance = 1;
    option.auto_bin_max = 256;
    write_data: coverpoint data_value;
  endgroup

  covergroup i2c_rw_addr_cross_cg with function sample(bit is_read, bit [7:0] reg_addr);
    option.per_instance = 1;
    rw_kind: coverpoint is_read { bins write = {0}; bins read = {1}; }
    reg_addr_cp: coverpoint reg_addr {
      bins general[] = {[8'h00:8'h07]};
      bins control[] = {8'h08,8'h09,8'h0A,8'h0B,8'h0C};
      bins trim[] = {[8'h20:8'h2F]};
      bins misc[] = {8'h30,8'h31,8'h32};
    }
    rw_x_addr: cross rw_kind, reg_addr_cp;
  endgroup

  covergroup i2c_addr_data_cross_cg with function sample(bit [7:0] reg_addr, bit [7:0] data_value);
    option.per_instance = 1;
    reg_addr_cp: coverpoint reg_addr {
      bins general[] = {[8'h00:8'h07]};
      bins control[] = {8'h08,8'h09,8'h0A,8'h0B,8'h0C};
      bins trim[] = {[8'h20:8'h2F]};
      bins misc[] = {8'h30,8'h31,8'h32};
    }
    data_cp: coverpoint data_value { option.auto_bin_max = 256; }
    addr_x_data: cross reg_addr_cp, data_cp;
  endgroup

  covergroup otp_cmd_write_cg with function sample(bit [7:0] cmd_value);
    // pragma uvmf custom covergroup begin
    option.per_instance = 1;
    otp_cmd: coverpoint cmd_value {
      bins reload_cmd = {i2c_transaction#()::OTP_CMD_RELOAD};
      bins program_cmd = {i2c_transaction#()::OTP_CMD_PROGRAM};
      bins prog_bit_cmd = {i2c_transaction#()::OTP_CMD_PROG_BIT};
      bins noop_cmd = {8'h00};
      bins invalid_cmd = default;
    }
    // pragma uvmf custom covergroup end
  endgroup

  covergroup otp_addr_write_cg with function sample(bit [7:0] addr_value);
    // pragma uvmf custom covergroup begin
    option.per_instance = 1;
    otp_addr: coverpoint addr_value {
      bins first_byte_bits = {[8'h00:8'h07]};
      bins middle_byte_bits = {[8'h08:8'h77]};
      bins last_byte_bits = {[8'h78:8'h7F]};
      bins out_of_range = {[8'h80:8'hFF]};
    }
    // pragma uvmf custom covergroup end
  endgroup

  covergroup otp_status_read_cg with function sample(bit [7:0] status_value);
    // pragma uvmf custom covergroup begin
    option.per_instance = 1;
    otp_status_value: coverpoint status_value {
      bins idle = {8'h00};
      bins reload_done = {8'h02};
      bins prog_trim_done = {8'h01};
      bins otp_lock_prog_done = {8'h11};
      bins cmd_error = {8'h08};
      bins upper_bits_only[] = {[8'h20:8'hE0]};
      bins mixed_values[] = {[8'h01:8'h1F], [8'h21:8'hFF]};
    }
    otp_lock: coverpoint status_value[4] { bins clear = {0}; bins set = {1}; }
    cmd_error: coverpoint status_value[3] { bins clear = {0}; bins set = {1}; }
    prog_error: coverpoint status_value[2] { bins clear = {0}; bins set = {1}; }
    reload_done: coverpoint status_value[1] { bins clear = {0}; bins set = {1}; }
    prog_trim_done: coverpoint status_value[0] { bins clear = {0}; bins set = {1}; }
    otp_status_upper: coverpoint status_value[7:5] {
      bins zero = {3'b000};
      bins nonzero[] = {[3'b001:3'b111]};
    }
    // pragma uvmf custom covergroup end
  endgroup

  covergroup otp_status_write_cg with function sample(bit [7:0] status_write_value);
    // pragma uvmf custom covergroup begin
    option.per_instance = 1;
    otp_status_upper_write: coverpoint status_write_value[7:5] {
      bins zero = {3'b000};
      bins each[] = {[3'b001:3'b111]};
    }
    otp_status_lower_write: coverpoint status_write_value[4:0] {
      bins all_zero = {5'b00000};
      bins non_zero = default;
    }
    // pragma uvmf custom covergroup end
  endgroup

  covergroup otp_cmd_addr_cross_cg with function sample(bit [7:0] cmd_value, bit [7:0] addr_value);
    // pragma uvmf custom covergroup begin
    option.per_instance = 1;
    otp_cmd_cp: coverpoint cmd_value {
      bins reload_cmd = {i2c_transaction#()::OTP_CMD_RELOAD};
      bins program_cmd = {i2c_transaction#()::OTP_CMD_PROGRAM};
      bins prog_bit_cmd = {i2c_transaction#()::OTP_CMD_PROG_BIT};
      bins noop_cmd = {8'h00};
      bins invalid_cmd = default;
    }
    otp_addr_cp: coverpoint addr_value {
      bins low = {[8'h00:8'h07]};
      bins mid = {[8'h08:8'h77]};
      bins high = {[8'h78:8'h7F]};
      bins out_of_range = {[8'h80:8'hFF]};
    }
    otp_cmd_x_addr: cross otp_cmd_cp, otp_addr_cp;
    // pragma uvmf custom covergroup end
  endgroup

  covergroup wd_ctrl_write_cg with function sample(bit [7:0] wd_value);
    option.per_instance = 1;
    wd_enable: coverpoint wd_value[3] { bins disabled = {0}; bins enabled = {1}; }
    wd_kick: coverpoint wd_value[2] { bins idle = {0}; bins clear = {1}; }
    wd_period: coverpoint wd_value[5:4] {
      bins sel0 = {2'b00};
      bins sel1 = {2'b01};
      bins sel2 = {2'b10};
      bins sel3 = {2'b11};
    }
    wd_mask: coverpoint wd_value[1] { bins unmasked = {0}; bins masked = {1}; }
    wd_x: cross wd_enable, wd_period;
  endgroup

  covergroup sys_ctrl_write_cg with function sample(bit [7:0] sys_value);
    option.per_instance = 1;
    reg_rst: coverpoint sys_value[7] { bins clear = {0}; bins asserted = {1}; }
    sys_payload: coverpoint sys_value[6:0] {
      bins zero = {7'h00};
      bins nonzero = default;
    }
  endgroup

  covergroup int_ctrl_write_cg with function sample(bit [7:0] int_value);
    option.per_instance = 1;
    int_bits: coverpoint int_value[1:0] {
      bins both_clear = {2'b00};
      bins bit0_only = {2'b01};
      bins bit1_only = {2'b10};
      bins both_set = {2'b11};
    }
  endgroup

  covergroup i2c_read_ptr_cg with function sample(bit [7:0] ptr_value);
    option.per_instance = 1;
    indirect_ptr: coverpoint ptr_value {
      bins valid_low = {[8'h00:8'h0C]};
      bins reserved = {[8'h0D:8'h19]};
      bins valid_high = {[8'h20:8'h32]};
      bins invalid_high = {[8'h1A:8'h1F], [8'h33:8'hFF]};
    }
  endgroup

  covergroup test_reg_write_cg with function sample(bit [7:0] test_value);
    option.per_instance = 1;
    test_key: coverpoint test_value {
      bins key0 = {8'h09};
      bins key1 = {8'h01};
      bins other = default;
    }
  endgroup

  covergroup test_key_sequence_cg with function sample(bit [7:0] prev2, bit [7:0] prev1, bit [7:0] curr);
    option.per_instance = 1;
    key_prev2: coverpoint prev2 { bins key0 = {8'h09}; bins other = default; }
    key_prev1: coverpoint prev1 { bins key1 = {8'h01}; bins other = default; }
    key_curr: coverpoint curr { bins key0 = {8'h09}; bins other = default; }
    enter_test_mode: cross key_prev2, key_prev1, key_curr;
  endgroup

  covergroup test_mode_access_cg with function sample(bit [7:0] reg_addr);
    option.per_instance = 1;
    test_mode_reg: coverpoint reg_addr {
      bins trim_regs[] = {[8'h20:8'h2F]};
      bins ctrl_regs[] = {8'h08,8'h09,8'h0A,8'h0B,8'h0C,8'h30,8'h31,8'h32};
    }
  endgroup

  covergroup invalid_access_cg with function sample(bit i2c_is_read, bit [7:0] reg_addr);
    option.per_instance = 1;
    access_kind: coverpoint i2c_is_read { bins write = {0}; bins read = {1}; }
    invalid_addr: coverpoint reg_addr {
      bins reserved_regs[] = {[8'h0D:8'h1F]};
      bins above_map[] = {[8'h33:8'hFF]};
    }
    invalid_x: cross access_kind, invalid_addr;
  endgroup

  covergroup general_reg_pattern_cg with function sample(bit [7:0] reg_addr, bit [7:0] data_value);
    option.per_instance = 1;
    general_reg: coverpoint reg_addr { bins regs[] = {[8'h00:8'h07]}; }
    data_pattern: coverpoint data_value {
      bins zero = {8'h00};
      bins all_ones = {8'hFF};
      bins alternating_a = {8'hAA};
      bins alternating_5 = {8'h55};
      bins walking_1[] = {8'h01,8'h02,8'h04,8'h08,8'h10,8'h20,8'h40,8'h80};
      bins walking_0[] = {8'hFE,8'hFD,8'hFB,8'hF7,8'hEF,8'hDF,8'hBF,8'h7F};
      bins other = default;
    }
    general_reg_x_pattern: cross general_reg, data_pattern;
  endgroup

  covergroup trim_reg_access_cg with function sample(bit is_read, bit [7:0] reg_addr);
    option.per_instance = 1;
    access_kind: coverpoint is_read { bins write = {0}; bins read = {1}; }
    trim_reg: coverpoint reg_addr { bins regs[] = {[8'h20:8'h2F]}; }
    trim_access_x: cross access_kind, trim_reg;
  endgroup

  covergroup ctrl_reg_access_cg with function sample(bit is_read, bit [7:0] reg_addr);
    option.per_instance = 1;
    access_kind: coverpoint is_read { bins write = {0}; bins read = {1}; }
    ctrl_reg: coverpoint reg_addr {
      bins wd_ctrl = {8'h08};
      bins otp_cmd = {8'h09};
      bins otp_addr = {8'h0A};
      bins otp_status = {8'h0B};
      bins int_ctrl = {8'h0C};
      bins sys_ctrl = {8'h30};
      bins i2c_read_addr = {8'h31};
      bins test_reg = {8'h32};
    }
    ctrl_access_x: cross access_kind, ctrl_reg;
  endgroup

  covergroup int_ctrl_reserved_attempt_cg with function sample(bit has_reserved_bits);
    option.per_instance = 1;
    reserved_attempt: coverpoint has_reserved_bits {
      bins legal_only = {0};
      bins reserved_bits_present = {1};
    }
  endgroup

  // ****************************************************************************
  // FUNCTION : new()
  // This function is the standard SystemVerilog constructor.
  //
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    i2c_write_reg_cg = new;
    i2c_read_reg_cg = new;
    i2c_write_data_cg = new;
    i2c_rw_addr_cross_cg = new;
    i2c_addr_data_cross_cg = new;
    otp_cmd_write_cg = new;
    otp_addr_write_cg = new;
    otp_status_read_cg = new;
    otp_status_write_cg = new;
    otp_cmd_addr_cross_cg = new;
    wd_ctrl_write_cg = new;
    sys_ctrl_write_cg = new;
    int_ctrl_write_cg = new;
    i2c_read_ptr_cg = new;
    test_reg_write_cg = new;
    test_key_sequence_cg = new;
    test_mode_access_cg = new;
    invalid_access_cg = new;
    general_reg_pattern_cg = new;
    trim_reg_access_cg = new;
    ctrl_reg_access_cg = new;
    int_ctrl_reserved_attempt_cg = new;
  endfunction

  // ****************************************************************************
  // FUNCTION : build_phase()
  // This function is the standard UVM build_phase.
  //
  function void build_phase(uvm_phase phase);
    i2c_write_reg_cg.set_inst_name($sformatf("i2c_write_reg_cg_%s",get_full_name()));
    i2c_read_reg_cg.set_inst_name($sformatf("i2c_read_reg_cg_%s",get_full_name()));
    i2c_write_data_cg.set_inst_name($sformatf("i2c_write_data_cg_%s",get_full_name()));
    i2c_rw_addr_cross_cg.set_inst_name($sformatf("i2c_rw_addr_cross_cg_%s",get_full_name()));
    i2c_addr_data_cross_cg.set_inst_name($sformatf("i2c_addr_data_cross_cg_%s",get_full_name()));
    otp_cmd_write_cg.set_inst_name($sformatf("otp_cmd_write_cg_%s",get_full_name()));
    otp_addr_write_cg.set_inst_name($sformatf("otp_addr_write_cg_%s",get_full_name()));
    otp_status_read_cg.set_inst_name($sformatf("otp_status_read_cg_%s",get_full_name()));
    otp_status_write_cg.set_inst_name($sformatf("otp_status_write_cg_%s",get_full_name()));
    otp_cmd_addr_cross_cg.set_inst_name($sformatf("otp_cmd_addr_cross_cg_%s",get_full_name()));
    wd_ctrl_write_cg.set_inst_name($sformatf("wd_ctrl_write_cg_%s",get_full_name()));
    sys_ctrl_write_cg.set_inst_name($sformatf("sys_ctrl_write_cg_%s",get_full_name()));
    int_ctrl_write_cg.set_inst_name($sformatf("int_ctrl_write_cg_%s",get_full_name()));
    i2c_read_ptr_cg.set_inst_name($sformatf("i2c_read_ptr_cg_%s",get_full_name()));
    test_reg_write_cg.set_inst_name($sformatf("test_reg_write_cg_%s",get_full_name()));
    test_key_sequence_cg.set_inst_name($sformatf("test_key_sequence_cg_%s",get_full_name()));
    test_mode_access_cg.set_inst_name($sformatf("test_mode_access_cg_%s",get_full_name()));
    invalid_access_cg.set_inst_name($sformatf("invalid_access_cg_%s",get_full_name()));
    general_reg_pattern_cg.set_inst_name($sformatf("general_reg_pattern_cg_%s",get_full_name()));
    trim_reg_access_cg.set_inst_name($sformatf("trim_reg_access_cg_%s",get_full_name()));
    ctrl_reg_access_cg.set_inst_name($sformatf("ctrl_reg_access_cg_%s",get_full_name()));
    int_ctrl_reserved_attempt_cg.set_inst_name($sformatf("int_ctrl_reserved_attempt_cg_%s",get_full_name()));
  endfunction

  // ****************************************************************************
  // FUNCTION: write (T t)
  // This function is automatically executed when a transaction arrives on the
  // analysis_export.  It copies values from the variables in the transaction 
  // to local variables used to collect functional coverage.  
  //
  virtual function void write (T t);
    `uvm_info("COV","Received transaction",UVM_HIGH);
    coverage_trans = t;
    if (!get_sampled_reg_addr(t, sampled_reg_addr)) begin
      return;
    end
    if (!get_sampled_data_value(t, sampled_data_value)) begin
      return;
    end
    if (!is_valid_reg_addr(sampled_reg_addr)) begin
      invalid_access_samples++;
      invalid_access_cg.sample((t.op == I2C_RD), sampled_reg_addr);
      return;
    end

    case (t.op)
      I2C_WR: begin
        write_samples++;
        i2c_write_reg_cg.sample(sampled_reg_addr);
        i2c_write_data_cg.sample(sampled_data_value);
        i2c_rw_addr_cross_cg.sample(1'b0, sampled_reg_addr);
        i2c_addr_data_cross_cg.sample(sampled_reg_addr, sampled_data_value);
        if (sampled_reg_addr inside {[8'h00:8'h07]}) begin
          general_reg_pattern_samples++;
          general_reg_pattern_cg.sample(sampled_reg_addr, sampled_data_value);
        end
        if (sampled_reg_addr inside {[8'h20:8'h2F]}) begin
          trim_reg_access_samples++;
          trim_reg_access_cg.sample(1'b0, sampled_reg_addr);
        end
        if (sampled_reg_addr inside {8'h08,8'h09,8'h0A,8'h0B,8'h0C,8'h30,8'h31,8'h32}) begin
          ctrl_reg_access_samples++;
          ctrl_reg_access_cg.sample(1'b0, sampled_reg_addr);
        end
        if (sampled_reg_addr == i2c_transaction#()::WD_CTRL_REG_ADDR) begin
          wd_ctrl_write_samples++;
          wd_ctrl_write_cg.sample(sampled_data_value);
        end
        if (sampled_reg_addr == i2c_transaction#()::OTP_CMD_REG_ADDR) begin
          otp_cmd_write_samples++;
          otp_cmd_write_cg.sample(sampled_data_value);
        end
        if (sampled_reg_addr == i2c_transaction#()::OTP_ADDR_REG_ADDR) begin
          otp_addr_write_samples++;
          last_otp_addr_value = sampled_data_value;
          otp_addr_write_cg.sample(sampled_data_value);
        end
        if (sampled_reg_addr == i2c_transaction#()::OTP_STATUS_REG_ADDR) begin
          otp_status_write_samples++;
          otp_status_write_cg.sample(sampled_data_value);
        end
        if (sampled_reg_addr == i2c_transaction#()::INT_CTRL_REG_ADDR) begin
          int_ctrl_write_samples++;
          int_ctrl_write_cg.sample(sampled_data_value);
          if (sampled_data_value[7:2] != '0) begin
            int_ctrl_reserved_attempt_samples++;
            int_ctrl_reserved_attempt_cg.sample(1'b1);
          end
          else begin
            int_ctrl_reserved_attempt_cg.sample(1'b0);
          end
        end
        if (sampled_reg_addr == i2c_transaction#()::SYS_CTRL_REG_ADDR) begin
          sys_ctrl_write_samples++;
          sys_ctrl_write_cg.sample(sampled_data_value);
          if (sampled_data_value[7]) begin
            inferred_test_mode = 1'b0;
          end
        end
        if (sampled_reg_addr == i2c_transaction#()::I2C_READ_ADDR_ADDR) begin
          i2c_read_ptr_write_samples++;
          i2c_read_ptr_cg.sample(sampled_data_value);
        end
        if (sampled_reg_addr == i2c_transaction#()::TEST_REG_ADDR) begin
          test_reg_write_samples++;
          test_reg_write_cg.sample(sampled_data_value);
          test_key_sequence_cg.sample(last_test_key_1, last_test_key_0, sampled_data_value);
          inferred_test_mode = (last_test_key_1 == 8'h09)
                               && (last_test_key_0 == 8'h01)
                               && (sampled_data_value == 8'h09);
          last_test_key_1 = last_test_key_0;
          last_test_key_0 = sampled_data_value;
        end
        if ((sampled_reg_addr == i2c_transaction#()::OTP_CMD_REG_ADDR)
            && (coverage_trans.reg_addr_valid
                || (coverage_trans.data.size() > 1))) begin
          otp_cmd_addr_cross_cg.sample(sampled_data_value, last_otp_addr_value);
        end
        if (inferred_test_mode
            && (sampled_reg_addr inside {[8'h20:8'h2F],8'h08,8'h09,8'h0A,8'h0B,8'h0C,8'h30,8'h31,8'h32})) begin
          test_mode_access_samples++;
          test_mode_access_cg.sample(sampled_reg_addr);
        end
      end
      I2C_RD: begin
        read_samples++;
        i2c_read_reg_cg.sample(sampled_reg_addr);
        i2c_rw_addr_cross_cg.sample(1'b1, sampled_reg_addr);
        if (sampled_reg_addr inside {[8'h20:8'h2F]}) begin
          trim_reg_access_samples++;
          trim_reg_access_cg.sample(1'b1, sampled_reg_addr);
        end
        if (sampled_reg_addr inside {8'h08,8'h09,8'h0A,8'h0B,8'h0C,8'h30,8'h31,8'h32}) begin
          ctrl_reg_access_samples++;
          ctrl_reg_access_cg.sample(1'b1, sampled_reg_addr);
        end
        if (sampled_reg_addr == i2c_transaction#()::OTP_STATUS_REG_ADDR) begin
          otp_status_read_samples++;
          otp_status_read_cg.sample(sampled_data_value);
        end
        if (inferred_test_mode
            && (sampled_reg_addr inside {[8'h20:8'h2F],8'h08,8'h09,8'h0A,8'h0B,8'h0C,8'h30,8'h31,8'h32})) begin
          test_mode_access_samples++;
          test_mode_access_cg.sample(sampled_reg_addr);
        end
      end
      default: ;
    endcase
  endfunction

  function void report_phase(uvm_phase phase);
    real write_cov;
    real read_cov;
    real otp_cmd_cov;
    real otp_addr_cov;
    real otp_status_read_cov;
    real otp_status_write_cov;
    real otp_cmd_addr_cov;
    real write_data_cov;
    real rw_addr_cov;
    real addr_data_cov;
    real wd_cov;
    real sys_cov;
    real int_cov;
    real ptr_cov;
    real test_cov;
    real test_seq_cov;
    real test_mode_cov;
    real invalid_cov;

    super.report_phase(phase);
    write_cov = i2c_write_reg_cg.get_coverage();
    read_cov = i2c_read_reg_cg.get_coverage();
    write_data_cov = i2c_write_data_cg.get_coverage();
    rw_addr_cov = i2c_rw_addr_cross_cg.get_coverage();
    addr_data_cov = i2c_addr_data_cross_cg.get_coverage();
    otp_cmd_cov = otp_cmd_write_cg.get_coverage();
    otp_addr_cov = otp_addr_write_cg.get_coverage();
    otp_status_read_cov = otp_status_read_cg.get_coverage();
    otp_status_write_cov = otp_status_write_cg.get_coverage();
    otp_cmd_addr_cov = otp_cmd_addr_cross_cg.get_coverage();
    wd_cov = wd_ctrl_write_cg.get_coverage();
    sys_cov = sys_ctrl_write_cg.get_coverage();
    int_cov = int_ctrl_write_cg.get_coverage();
    ptr_cov = i2c_read_ptr_cg.get_coverage();
    test_cov = test_reg_write_cg.get_coverage();
    test_seq_cov = test_key_sequence_cg.get_coverage();
    test_mode_cov = test_mode_access_cg.get_coverage();
    invalid_cov = invalid_access_cg.get_coverage();
    `uvm_info("COV",
              $sformatf("I2C register coverage: writes=%0.2f%% (%0d samples) reads=%0.2f%% (%0d samples) write_data=%0.2f%% rw_x_addr=%0.2f%% addr_x_data=%0.2f%%",
                        write_cov, write_samples, read_cov, read_samples,
                        write_data_cov, rw_addr_cov, addr_data_cov),
              UVM_NONE)
    `uvm_info("COV",
              $sformatf("OTP coverage: cmd_writes=%0.2f%% (%0d samples) otp_addr_writes=%0.2f%% (%0d samples) otp_status_reads=%0.2f%% (%0d samples) otp_status_writes=%0.2f%% (%0d samples) cmd_x_addr=%0.2f%%",
                        otp_cmd_cov, otp_cmd_write_samples,
                        otp_addr_cov, otp_addr_write_samples,
                        otp_status_read_cov, otp_status_read_samples,
                        otp_status_write_cov, otp_status_write_samples,
                        otp_cmd_addr_cov),
              UVM_NONE)
    `uvm_info("COV",
              $sformatf("Control coverage: wd_ctrl=%0.2f%% (%0d samples) sys_ctrl=%0.2f%% (%0d samples) int_ctrl=%0.2f%% (%0d samples) read_ptr=%0.2f%% (%0d samples)",
                        wd_cov, wd_ctrl_write_samples,
                        sys_cov, sys_ctrl_write_samples,
                        int_cov, int_ctrl_write_samples,
                        ptr_cov, i2c_read_ptr_write_samples),
              UVM_NONE)
    `uvm_info("COV",
              $sformatf("Test/invalid coverage: test_reg=%0.2f%% (%0d samples) test_key_seq=%0.2f%% test_mode_access=%0.2f%% (%0d samples) invalid_access=%0.2f%% (%0d samples)",
                        test_cov, test_reg_write_samples,
                        test_seq_cov,
                        test_mode_cov, test_mode_access_samples,
                        invalid_cov, invalid_access_samples),
              UVM_NONE)
  endfunction

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end
