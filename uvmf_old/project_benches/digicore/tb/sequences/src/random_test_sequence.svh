//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains the top level sequence used in register_test.
// It uses the UVM built in register test.  Specific UVM built-in tests can be
// selected in the body task.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class random_i2c_write_read_sequence extends i2c_sequence_base #(
      .I2C_ADDR_WIDTH(7),
      .I2C_DATA_WIDTH(8),
      .I2C_SLAVE_ADDRESS(8'h22)
      );

  `uvm_object_utils( random_i2c_write_read_sequence );

  rand bit [7:0] reg_addr;
  rand bit [7:0] reg_data;

  constraint safe_reg_c {
    // In normal I2C mode, REG_MAP only accepts writes to:
    //   0x00-0x07, 0x09, 0x0A, 0x0C, 0x30-0x32
    // Trim registers 0x20-0x2F are not writable until TEST_MODE.
    // Keep random traffic on safe user-visible registers that do not
    // trigger side effects like reset or trim reload.
    reg_addr inside { [8'h00:8'h07], 8'h0C };
  }

  constraint safe_data_c {
    if (reg_addr == 8'h0C) {
      reg_data[7:2] == '0;
    }
  }

  function new(string name = "");
    super.new(name);
  endfunction

  task automatic send_i2c_write(bit [7:0] write_addr, bit [7:0] write_data, string txn_name);
    req.set_name(txn_name);
    start_item(req);
    req.addr = 7'h22;
    req.op = I2C_WR;
    req.reg_addr_valid = 1'b1;
    req.reg_addr_dbg = write_addr;
    req.data.delete();
    req.data.push_back(write_addr);
    req.data.push_back(write_data);
    finish_item(req);
  endtask

  task automatic send_i2c_read(string txn_name);
    req.set_name(txn_name);
    start_item(req);
    req.addr = 7'h22;
    req.op = I2C_RD;
    req.reg_addr_valid = 1'b1;
    req.reg_addr_dbg = reg_addr;
    req.data.delete();
    req.data.push_back(8'h00);
    finish_item(req);
  endtask

  virtual task body();
    if (!randomize()) begin
      `uvm_fatal("SEQ", "Failed to randomize write/read access")
    end

    // Access pattern expected by the DUT:
    // 1. Write payload into a random readable/writable register
    // 2. Program I2C_READ_ADDR (0x31) with that register address
    // 3. Issue a one-byte read and check the DUT's returned data
    send_i2c_write(reg_addr, reg_data, $sformatf("write_reg_%0h", reg_addr));
    send_i2c_write(8'h31, reg_addr, $sformatf("set_read_ptr_%0h", reg_addr));
    send_i2c_read($sformatf("read_reg_%0h", reg_addr));
  endtask

endclass

class random_test_sequence extends digicore_bench_sequence_base;

  `uvm_object_utils( random_test_sequence );

  // pragma uvmf custom class_item_additional begin
  localparam int unsigned NUM_RANDOM_ACCESSES = 50;
  localparam int unsigned DUT_STARTUP_WAIT_CLKS = 26000;
  random_i2c_write_read_sequence i2c_seq;
  // pragma uvmf custom class_item_additional end

  function new(string name = "" );
    super.new(name);
  endfunction

  // ****************************************************************************
  virtual task body();

    // Reset the DUT
    fork
      // pragma uvmf custom register_test_reset begin
      // UVMF_CHANGE_ME 
      // Select the desired wait_for_reset or provide custom mechanism.
      // fork-join for this code block may be unnecessary based on your situation.
      i2c_a_config.wait_for_reset();
      // pragma uvmf custom register_test_reset end
    join

      // pragma uvmf custom register_test_setup begin
      // UVMF_CHANGE_ME perform potentially necessary operations before running the sequence.
      // pragma uvmf custom register_test_setup end

    // The DUT does not enter I2C mode immediately after reset.
    // hdl_top drives:
    // - DVDD high at 23us
    // - PORZ high at 143us
    // - CLK_GD_I high at 243us
    // After that, FSM enters READ_TRIM and waits for OTP reload to complete
    // before transitioning into I2C mode. Wait long enough before sending traffic.
    i2c_a_config.wait_for_num_clocks(DUT_STARTUP_WAIT_CLKS);

    i2c_seq = random_i2c_write_read_sequence::type_id::create("i2c_seq");

    repeat (NUM_RANDOM_ACCESSES) begin
      i2c_seq.start(i2c_a_sequencer);
    end

    fork
      i2c_a_config.wait_for_num_clocks(17500);
    join

  endtask

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end
