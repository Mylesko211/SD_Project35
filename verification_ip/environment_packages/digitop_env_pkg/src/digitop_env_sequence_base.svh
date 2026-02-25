//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains environment level sequences that will
//    be reused from block to top level simulations.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class digitop_env_sequence_base #( 
      type CONFIG_T
      ) extends uvmf_virtual_sequence_base #(.CONFIG_T(CONFIG_T));


  `uvm_object_param_utils( digitop_env_sequence_base #(
                           CONFIG_T
                           ) );

  // Handle to the environments register model
// This handle needs to be set before use.
  reg_block  digitop_rm;

// This digitop_env_sequence_base contains a handle to a digitop_env_configuration object 
// named configuration.  This configuration variable contains a handle to each 
// sequencer within each agent within this environment and any sub-environments.
// The configuration object handle is automatically assigned in the pre_body in the
// base class of this sequence.  The configuration handle is retrieved from the
// virtual sequencer that this sequence is started on.
// Available sequencer handles within the environment configuration:

  // Initiator agent sequencers in digitop_environment:
    // configuration.i2c_a_config.sequencer

  // Responder agent sequencers in digitop_environment:


    typedef i2c_random_sequence#(
                .I2C_ADDR_WIDTH(7),
                .I2C_DATA_WIDTH(8),
                .I2C_SLAVE_ADDRESS(8'h22)
                )
 i2c_a_random_sequence_t;
    i2c_a_random_sequence_t i2c_a_rand_seq;


// This example shows how to use the environment sequence base for sub-environments
// It can only be used on environments generated with UVMF_2022.3 and later.
// Environment sequences generated with UVMF_2022.1 and earlier do not have the required 
//    environment level virtual sequencer


  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  function new(string name = "" );
    super.new(name);
    i2c_a_rand_seq = i2c_a_random_sequence_t::type_id::create("i2c_a_rand_seq");


  endfunction

  virtual task body();

  // Handle to the environments register model
// This handle needs to be set before use.
  digitop_rm = configuration.digitop_rm ;

    if ( configuration.i2c_a_config.sequencer != null )
       repeat (25) i2c_a_rand_seq.start(configuration.i2c_a_config.sequencer);


  endtask

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

