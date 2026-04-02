class reg_map_sweep_test_sequence extends digicore_bench_sequence_base;

  `uvm_object_utils( reg_map_sweep_test_sequence );

  localparam int unsigned DUT_STARTUP_WAIT_CLKS = 26000;
  i2c_reg_map_sweep_sequence i2c_seq;

  function new(string name = "" );
    super.new(name);
  endfunction

  virtual task body();
    fork
      i2c_a_config.wait_for_reset();
    join

    i2c_a_config.wait_for_num_clocks(DUT_STARTUP_WAIT_CLKS);

    i2c_seq = i2c_reg_map_sweep_sequence::type_id::create("i2c_seq");
    i2c_seq.start(i2c_a_sequencer);

    i2c_a_config.wait_for_num_clocks(2000);
  endtask

endclass
