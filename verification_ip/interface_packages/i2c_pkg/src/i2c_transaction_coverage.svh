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
  int unsigned read_samples;
  int unsigned write_samples;
  int unsigned otp_cmd_write_samples;
  int unsigned otp_addr_write_samples;
  int unsigned otp_status_read_samples;
  int unsigned otp_status_write_samples;

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

  // ****************************************************************************
  // FUNCTION : new()
  // This function is the standard SystemVerilog constructor.
  //
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    i2c_write_reg_cg = new;
    i2c_read_reg_cg = new;
    otp_cmd_write_cg = new;
    otp_addr_write_cg = new;
    otp_status_read_cg = new;
    otp_status_write_cg = new;
    otp_cmd_addr_cross_cg = new;
  endfunction

  // ****************************************************************************
  // FUNCTION : build_phase()
  // This function is the standard UVM build_phase.
  //
  function void build_phase(uvm_phase phase);
    i2c_write_reg_cg.set_inst_name($sformatf("i2c_write_reg_cg_%s",get_full_name()));
    i2c_read_reg_cg.set_inst_name($sformatf("i2c_read_reg_cg_%s",get_full_name()));
    otp_cmd_write_cg.set_inst_name($sformatf("otp_cmd_write_cg_%s",get_full_name()));
    otp_addr_write_cg.set_inst_name($sformatf("otp_addr_write_cg_%s",get_full_name()));
    otp_status_read_cg.set_inst_name($sformatf("otp_status_read_cg_%s",get_full_name()));
    otp_status_write_cg.set_inst_name($sformatf("otp_status_write_cg_%s",get_full_name()));
    otp_cmd_addr_cross_cg.set_inst_name($sformatf("otp_cmd_addr_cross_cg_%s",get_full_name()));
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

    case (t.op)
      I2C_WR: begin
        write_samples++;
        i2c_write_reg_cg.sample(sampled_reg_addr);
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
        if ((sampled_reg_addr == i2c_transaction#()::OTP_CMD_REG_ADDR)
            && (coverage_trans.reg_addr_valid
                || (coverage_trans.data.size() > 1))) begin
          otp_cmd_addr_cross_cg.sample(sampled_data_value, last_otp_addr_value);
        end
      end
      I2C_RD: begin
        read_samples++;
        i2c_read_reg_cg.sample(sampled_reg_addr);
        if (sampled_reg_addr == i2c_transaction#()::OTP_STATUS_REG_ADDR) begin
          otp_status_read_samples++;
          otp_status_read_cg.sample(sampled_data_value);
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

    super.report_phase(phase);
    write_cov = i2c_write_reg_cg.get_coverage();
    read_cov = i2c_read_reg_cg.get_coverage();
    otp_cmd_cov = otp_cmd_write_cg.get_coverage();
    otp_addr_cov = otp_addr_write_cg.get_coverage();
    otp_status_read_cov = otp_status_read_cg.get_coverage();
    otp_status_write_cov = otp_status_write_cg.get_coverage();
    otp_cmd_addr_cov = otp_cmd_addr_cross_cg.get_coverage();
    `uvm_info("COV",
              $sformatf("I2C register coverage: writes=%0.2f%% (%0d samples) reads=%0.2f%% (%0d samples)",
                        write_cov, write_samples, read_cov, read_samples),
              UVM_NONE)
    `uvm_info("COV",
              $sformatf("OTP coverage: cmd_writes=%0.2f%% (%0d samples) otp_addr_writes=%0.2f%% (%0d samples) otp_status_reads=%0.2f%% (%0d samples) otp_status_writes=%0.2f%% (%0d samples) cmd_x_addr=%0.2f%%",
                        otp_cmd_cov, otp_cmd_write_samples,
                        otp_addr_cov, otp_addr_write_samples,
                        otp_status_read_cov, otp_status_read_samples,
                        otp_status_write_cov, otp_status_write_samples,
                        otp_cmd_addr_cov),
              UVM_NONE)
  endfunction

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end
