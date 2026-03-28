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

class random_test_sequence extends digicore_bench_sequence_base;

  `uvm_object_utils( random_test_sequence );

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  function new(string name = "" );
    super.new(name);
  endfunction

  // ****************************************************************************
  virtual task body();

  i2c_random_sequence#(
    7,
    8,
    8'h22
  ) i2c_seq;
  i2c_seq = i2c_random_sequence#(
    7,
    8,
    8'h22
  )::type_id::create("i2c_seq");

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

    // Reset the register model
    digitop_rm.reset();

    // Start RESPONDER sequences here
    fork
      repeat (50) i2c_seq.start( i2c_a_sequencer );
    join_none

    fork
      i2c_a_config.wait_for_num_clocks(17500);
    join

  endtask

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

