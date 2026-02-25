//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// Description: This file contains the top level and utility sequences
//     used by test_top. It can be extended to create derivative top
//     level sequences.
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//


typedef digitop_env_configuration  digitop_env_configuration_t;

class digicore_bench_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( digicore_bench_sequence_base );

  // pragma uvmf custom sequences begin

// This example shows how to use the environment sequence base
// It can only be used on environments generated with UVMF_2022.3 and later.
// Environment sequences generated with UVMF_2022.1 and earlier do not have the required 
//    environment level virtual sequencer
// typedef digitop_env_sequence_base #(
//         .CONFIG_T(digitop_env_configuration_t)// 
//         )
//         digitop_env_sequence_base_t;
// rand digitop_env_sequence_base_t digitop_env_seq;



  // UVMF_CHANGE_ME : Instantiate, construct, and start sequences as needed to create stimulus scenarios.
  // Instantiate sequences here
  typedef i2c_random_sequence #(
        .I2C_ADDR_WIDTH(7),
        .I2C_DATA_WIDTH(8),
        .I2C_SLAVE_ADDRESS(8'h22)
        )
 i2c_a_random_seq_t;
  i2c_a_random_seq_t i2c_a_random_seq;
  // pragma uvmf custom sequences end

  // Sequencer handles for each active interface in the environment
  typedef i2c_transaction #(
        .I2C_ADDR_WIDTH(7),
        .I2C_DATA_WIDTH(8),
        .I2C_SLAVE_ADDRESS(8'h22)
        )
 i2c_a_transaction_t;
  uvm_sequencer #(i2c_a_transaction_t)  i2c_a_sequencer; 


  // Top level environment configuration handle
  digitop_env_configuration_t top_configuration;

  // Configuration handles to access interface BFM's
  i2c_configuration #(
        .I2C_ADDR_WIDTH(7),
        .I2C_DATA_WIDTH(8),
        .I2C_SLAVE_ADDRESS(8'h22)
        )
 i2c_a_config;
  // Local handle to register model for convenience
  reg_block digitop_rm;
  uvm_status_e status;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // ****************************************************************************
  function new( string name = "" );
    super.new( name );
    // Retrieve the configuration handles from the uvm_config_db

    // Retrieve top level configuration handle
    if ( !uvm_config_db#(digitop_env_configuration_t)::get(null,UVMF_CONFIGURATIONS, "TOP_ENV_CONFIG",top_configuration) ) begin
      `uvm_info("CFG", "*** FATAL *** uvm_config_db::get can not find TOP_ENV_CONFIG.  Are you using an older UVMF release than what was used to generate this bench?",UVM_NONE);
      `uvm_fatal("CFG", "uvm_config_db#(digitop_env_configuration_t)::get cannot find resource TOP_ENV_CONFIG");
    end

    // Retrieve config handles for all agents
    if( !uvm_config_db #( i2c_configuration#(
        .I2C_ADDR_WIDTH(7),
        .I2C_DATA_WIDTH(8),
        .I2C_SLAVE_ADDRESS(8'h22)
        )
 )::get( null , UVMF_CONFIGURATIONS , i2c_a_BFM , i2c_a_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( i2c_configuration )::get cannot find resource i2c_a_BFM" )

    // Assign the sequencer handles from the handles within agent configurations
    i2c_a_sequencer = i2c_a_config.get_sequencer();

    digitop_rm = top_configuration.digitop_rm;


    // pragma uvmf custom new begin
    // pragma uvmf custom new end

  endfunction

  // ****************************************************************************
  virtual task body();
    // pragma uvmf custom body begin

    // Construct sequences here

    // digitop_env_seq = digitop_env_sequence_base_t::type_id::create("digitop_env_seq");

    i2c_a_random_seq     = i2c_a_random_seq_t::type_id::create("i2c_a_random_seq");
    fork
      i2c_a_config.wait_for_reset();
    join
    digitop_rm.reset();
    // Start RESPONDER sequences here
    fork
    join_none
    // Start INITIATOR sequences here
    fork
      repeat (25) i2c_a_random_seq.start(i2c_a_sequencer);
    join

// digitop_env_seq.start(top_configuration.vsqr);

    // UVMF_CHANGE_ME : Extend the simulation XXX number of clocks after 
    // the last sequence to allow for the last sequence item to flow 
    // through the design.
    fork
      i2c_a_config.wait_for_num_clocks(400);
    join

    // pragma uvmf custom body end
  endtask

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

