//----------------------------------------------------------------------
// Created with uvmf_gen version 2026.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//
// DESCRIPTION: This analysis component contains analysis_exports for receiving
//   data and analysis_ports for sending data.
// 
//   This analysis component has the following analysis_exports that receive the 
//   listed transaction type.
//   
//   i2c_in_ae receives transactions of type  i2c_transaction #()
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  i2c_expected_ap broadcasts transactions of type i2c_transaction #()
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class digicore_predictor #(
  type CONFIG_T,
  type BASE_T = uvm_component
  )
 extends BASE_T;

  // Factory registration of this class
  `uvm_component_param_utils( digicore_predictor #(
                              CONFIG_T,
                              BASE_T
                              )
)


  // Instantiate a handle to the configuration of the environment in which this component resides
  CONFIG_T configuration;

  
  // Instantiate the analysis exports
  uvm_analysis_imp_i2c_in_ae #(i2c_transaction #(), digicore_predictor #(
                              .CONFIG_T(CONFIG_T),
                              .BASE_T(BASE_T)
                              )
) i2c_in_ae;

  
  // Instantiate the analysis ports
  uvm_analysis_port #(i2c_transaction #()) i2c_expected_ap;
  uvm_analysis_port #(i2c_transaction #()) i2c_actual_ap;


  // Transaction variable for predicted values to be sent out i2c_expected_ap
  // Once a transaction is sent through an analysis_port, another transaction should
  // be constructed for the next predicted transaction. 
  typedef i2c_transaction #() i2c_expected_ap_output_transaction_t;
  i2c_expected_ap_output_transaction_t i2c_expected_ap_output_transaction;
  typedef i2c_transaction #() i2c_actual_ap_output_transaction_t;
  i2c_actual_ap_output_transaction_t i2c_actual_ap_output_transaction;
  // Code for sending output transaction out through i2c_expected_ap
  // i2c_expected_ap.write(i2c_expected_ap_output_transaction);

  // Define transaction handles for debug visibility 
  i2c_transaction #() i2c_in_ae_debug;


  // pragma uvmf custom class_item_additional begin
  // Register model used for read data prediction.
  logic [7:0] gen_reg [0:7];   // 0x00-0x07
  logic [7:0] wd_ctrl_reg;     // 0x08
  logic [7:0] otp_cmd_reg;     // 0x09
  logic [7:0] otp_addr_reg;    // 0x0A
  logic [7:0] otp_status_reg;  // 0x0B
  logic [7:0] int_ctrl_reg;    // 0x0C
  logic [7:0] trim_reg [0:15]; // 0x20-0x2F
  logic [7:0] otp_array [0:15]; // Predictor-side OTP image
  logic [7:0] sys_ctrl_reg;    // 0x30
  logic [7:0] i2c_read_addr;   // 0x31 (indirect pointer)
  logic [7:0] test_reg;        // 0x32

  function automatic bit valid_read_ptr(input logic [7:0] addr);
    return i2c_transaction#()::is_indirect_readable_addr(addr);
  endfunction

  function automatic void init_otp_model();
    for (int i = 0; i < 16; i++) begin
      otp_array[i] = 8'hFF;
    end
  endfunction

  function automatic void reset_reg_model();
    for (int i = 0; i < 8; i++) begin
      gen_reg[i] = 8'h00;
    end
    wd_ctrl_reg   = 8'h00;
    otp_cmd_reg   = 8'h00;
    otp_addr_reg  = 8'h00;
    otp_status_reg= 8'h00;
    int_ctrl_reg  = 8'h00;
    for (int i = 0; i < 16; i++) begin
      trim_reg[i] = 8'hFF;
    end
    sys_ctrl_reg  = 8'h00;
    i2c_read_addr = 8'hFF;
    test_reg      = 8'hFF;
  endfunction

  function automatic void model_trim_load_from_otp();
    // REG_MAP reloads TRIM_REG0-TRIM_REGE directly from OTP and forces TRIM_REGF[7] high.
    for (int i = 0; i < 15; i++) begin
      trim_reg[i] = otp_array[i];
    end
    trim_reg[15] = {1'b1, otp_array[15][6:0]};
    otp_status_reg = 8'h02;
    otp_cmd_reg = 8'h00;
  endfunction

  function automatic void model_otp_program_from_trim();
    for (int i = 0; i < 16; i++) begin
      otp_array[i] = trim_reg[i];
    end
    otp_status_reg = 8'h11;
  endfunction

  function automatic void model_otp_program_bit();
    int unsigned byte_idx;
    int unsigned bit_idx;

    byte_idx = otp_addr_reg[6:0] / 8;
    bit_idx  = otp_addr_reg[6:0] % 8;
    if (byte_idx < 16) begin
      otp_array[byte_idx][bit_idx] = 1'b1;
      trim_reg[byte_idx][bit_idx] = 1'b1;
      if (byte_idx == 15) begin
        trim_reg[15][7] = 1'b1;
      end
    end
    otp_status_reg = 8'h01;
  endfunction

  function automatic string fmt_i2c_write(input i2c_transaction #() t);
    if (t.data.size() >= 2) begin
      return $sformatf("%s WRITE reg:0x%0x data:0x%0x",
                       t.get_name(), t.data[0], t.data[1]);
    end
    if (t.data.size() == 1) begin
      return $sformatf("%s WRITE reg:0x%0x data:<missing>",
                       t.get_name(), t.data[0]);
    end
    return $sformatf("%s WRITE reg:<missing> data:<missing>", t.get_name());
  endfunction

  function automatic string fmt_i2c_read_req(input i2c_transaction #() t, input logic [7:0] reg_addr);
    return $sformatf("%s READ  reg:0x%0x", t.get_name(), reg_addr);
  endfunction

  function automatic logic [7:0] read_reg(input logic [7:0] addr);
    unique case (addr)
      8'h00: read_reg = gen_reg[0];
      8'h01: read_reg = gen_reg[1];
      8'h02: read_reg = gen_reg[2];
      8'h03: read_reg = gen_reg[3];
      8'h04: read_reg = gen_reg[4];
      8'h05: read_reg = gen_reg[5];
      8'h06: read_reg = gen_reg[6];
      8'h07: read_reg = gen_reg[7];
      8'h08: read_reg = wd_ctrl_reg;
      8'h09: read_reg = otp_cmd_reg;
      8'h0A: read_reg = otp_addr_reg;
      8'h0B: read_reg = otp_status_reg;
      8'h0C: read_reg = int_ctrl_reg;
      8'h20: read_reg = trim_reg[0];
      8'h21: read_reg = trim_reg[1];
      8'h22: read_reg = trim_reg[2];
      8'h23: read_reg = trim_reg[3];
      8'h24: read_reg = trim_reg[4];
      8'h25: read_reg = trim_reg[5];
      8'h26: read_reg = trim_reg[6];
      8'h27: read_reg = trim_reg[7];
      8'h28: read_reg = trim_reg[8];
      8'h29: read_reg = trim_reg[9];
      8'h2A: read_reg = trim_reg[10];
      8'h2B: read_reg = trim_reg[11];
      8'h2C: read_reg = trim_reg[12];
      8'h2D: read_reg = trim_reg[13];
      8'h2E: read_reg = trim_reg[14];
      8'h2F: read_reg = trim_reg[15];
      8'h30: read_reg = sys_ctrl_reg;
      8'h31: read_reg = i2c_read_addr;
      8'h32: read_reg = test_reg;
      default: read_reg = '0;
    endcase
  endfunction

  function automatic void write_reg(input logic [7:0] addr, input logic [7:0] data);
    unique case (addr)
      8'h00: gen_reg[0] = data;
      8'h01: gen_reg[1] = data;
      8'h02: gen_reg[2] = data;
      8'h03: gen_reg[3] = data;
      8'h04: gen_reg[4] = data;
      8'h05: gen_reg[5] = data;
      8'h06: gen_reg[6] = data;
      8'h07: gen_reg[7] = data;
      8'h08: wd_ctrl_reg = i2c_transaction#()::apply_write_policy(addr, wd_ctrl_reg, data);
      8'h09: otp_cmd_reg = data;
      8'h0A: otp_addr_reg = data;
      8'h0B: otp_status_reg = i2c_transaction#()::apply_write_policy(addr, otp_status_reg, data);
      8'h0C: int_ctrl_reg = i2c_transaction#()::apply_write_policy(addr, int_ctrl_reg, data);
      8'h20: trim_reg[0] = data;
      8'h21: trim_reg[1] = data;
      8'h22: trim_reg[2] = data;
      8'h23: trim_reg[3] = data;
      8'h24: trim_reg[4] = data;
      8'h25: trim_reg[5] = data;
      8'h26: trim_reg[6] = data;
      8'h27: trim_reg[7] = data;
      8'h28: trim_reg[8] = data;
      8'h29: trim_reg[9] = data;
      8'h2A: trim_reg[10] = data;
      8'h2B: trim_reg[11] = data;
      8'h2C: trim_reg[12] = data;
      8'h2D: trim_reg[13] = data;
      8'h2E: trim_reg[14] = data;
      8'h2F: trim_reg[15] = data;
      8'h30: sys_ctrl_reg = i2c_transaction#()::apply_write_policy(addr, sys_ctrl_reg, data);
      8'h31: i2c_read_addr = data;
      8'h32: test_reg = data;
      default: ;
    endcase
  endfunction
  // pragma uvmf custom class_item_additional end

  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  // pragma uvmf custom new begin
    init_otp_model();
    reset_reg_model();
    model_trim_load_from_otp();
    otp_status_reg = 8'h00;
  // pragma uvmf custom new end
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);

    i2c_in_ae = new("i2c_in_ae", this);
    i2c_expected_ap =new("i2c_expected_ap", this );
    i2c_actual_ap = new("i2c_actual_ap", this);
  // pragma uvmf custom build_phase begin
  // pragma uvmf custom build_phase end
  endfunction

  // FUNCTION: write_i2c_in_ae
  // Transactions received through i2c_in_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_i2c_in_ae(i2c_transaction #() t);
    // pragma uvmf custom i2c_in_ae_predictor begin
    bit [7:0] observed_reg_addr;

    i2c_in_ae_debug = t;
    if ((t.op == I2C_WR) && (t.data.size() > 0)) begin
      observed_reg_addr = t.data[0];
    end
    else if (t.op == I2C_RD) begin
      observed_reg_addr = i2c_read_addr;
    end
    else begin
      observed_reg_addr = '0;
    end

    t.reg_addr_valid = ((t.op == I2C_WR) && (t.data.size() > 0)) || (t.op == I2C_RD);
    t.reg_addr_dbg = observed_reg_addr;
    // Only track/read-check target-slave transactions.
    if (t.addr != i2c_transaction#()::I2C_SLAVE_ADDRESS) begin
      return;
    end

    if (t.op == I2C_WR) begin
      // I2C write format:
      // - normal write: data[0]=register address, data[1]=register payload
      // - write to I2C_READ_ADDR: data[1] programs the indirect read pointer
      if (t.data.size() >= 2) begin
        write_reg(t.data[0], t.data[1]);

        // RTL side effects:
        // - Software reset when SYS_CTRL[7] is set.
        if ((t.data[0] == i2c_transaction#()::SYS_CTRL_REG_ADDR) && t.data[1][7]) begin
          reset_reg_model();
        end
        if (t.data[0] == i2c_transaction#()::OTP_CMD_REG_ADDR) begin
          unique case (t.data[1])
            i2c_transaction#()::OTP_CMD_RELOAD: begin
              model_trim_load_from_otp();
            end
            i2c_transaction#()::OTP_CMD_PROGRAM: begin
              model_otp_program_from_trim();
            end
            i2c_transaction#()::OTP_CMD_PROG_BIT: begin
              model_otp_program_bit();
            end
            default: begin
              // otp_ctrl only asserts CMD_ERROR when cmd_valid is high.
              // Writing 0x00 or any other non-command value into OTP_CMD_REG
              // does not update the read-only OTP status bits.
            end
          endcase
        end
      end

      `uvm_info("PRED", fmt_i2c_write(t), UVM_MEDIUM)

      // Do not send writes to the scoreboard. The driver already generated them.
      return;
    end

    if (t.op == I2C_RD) begin
      `uvm_info("PRED", fmt_i2c_read_req(t, i2c_read_addr), UVM_MEDIUM)

      // Forward actual DUT read response and predicted read response only.
      i2c_actual_ap_output_transaction =
        i2c_actual_ap_output_transaction_t::type_id::create("i2c_actual_ap_output_transaction");
      i2c_expected_ap_output_transaction =
        i2c_expected_ap_output_transaction_t::type_id::create("i2c_expected_ap_output_transaction");

      i2c_actual_ap_output_transaction.copy(t);
      i2c_expected_ap_output_transaction.copy(t);
      i2c_actual_ap_output_transaction.reg_addr_valid = 1'b1;
      i2c_actual_ap_output_transaction.reg_addr_dbg = i2c_read_addr;
      i2c_expected_ap_output_transaction.reg_addr_valid = 1'b1;
      i2c_expected_ap_output_transaction.reg_addr_dbg = i2c_read_addr;

      // Reads return contents of register addressed by I2C_READ_ADDR.
      i2c_expected_ap_output_transaction.data.delete();
      if (valid_read_ptr(i2c_read_addr)) begin
        i2c_expected_ap_output_transaction.data.push_back(read_reg(i2c_read_addr));
      end
      else begin
        i2c_expected_ap_output_transaction.data.push_back(8'h00);
      end

      i2c_expected_ap.write(i2c_expected_ap_output_transaction);
      i2c_actual_ap.write(i2c_actual_ap_output_transaction);
    end
    // pragma uvmf custom i2c_in_ae_predictor end
  endfunction


endclass 

// pragma uvmf custom external begin
// pragma uvmf custom external end
