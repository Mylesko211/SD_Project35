//----------------------------------------------------------------------
// Created with uvmf_gen version 2026.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This environment contains all agents, predictors and
// scoreboards required for the block level design.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class digitop_environment  extends uvmf_environment_base #(
    .CONFIG_T( digitop_env_configuration 
  ));
  `uvm_component_utils( digitop_environment )





  typedef i2c_agent #(
                .I2C_ADDR_WIDTH(7),
                .I2C_DATA_WIDTH(8),
                .I2C_SLAVE_ADDRESS(8'h22)
                )
 i2c_a_t;
  i2c_a_t i2c_a;




  typedef digicore_predictor #(
                .CONFIG_T(CONFIG_T)
                )
 digicore_pred_t;
  digicore_pred_t digicore_pred;

  typedef uvmf_in_order_scoreboard #(.T(i2c_transaction))  digicore_scoreboard_t;
  digicore_scoreboard_t digicore_scoreboard;



  typedef uvmf_virtual_sequencer_base #(.CONFIG_T(digitop_env_configuration)) digitop_vsqr_t;
  digitop_vsqr_t vsqr;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
 
// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
// FUNCTION: build_phase()
// This function builds all components within this environment.
//
  virtual function void build_phase(uvm_phase phase);
// pragma uvmf custom build_phase_pre_super begin
// pragma uvmf custom build_phase_pre_super end
    super.build_phase(phase);
    i2c_a = i2c_a_t::type_id::create("i2c_a",this);
    i2c_a.set_config(configuration.i2c_a_config);
    digicore_pred = digicore_pred_t::type_id::create("digicore_pred",this);
    digicore_pred.configuration = configuration;
    digicore_scoreboard = digicore_scoreboard_t::type_id::create("digicore_scoreboard",this);

    vsqr = digitop_vsqr_t::type_id::create("vsqr", this);
    vsqr.set_config(configuration);
    configuration.set_vsqr(vsqr);

    // pragma uvmf custom build_phase begin
    // pragma uvmf custom build_phase end
  endfunction

// ****************************************************************************
// FUNCTION: connect_phase()
// This function makes all connections within this environment.  Connections
// typically inclue agent to predictor, predictor to scoreboard and scoreboard
// to agent.
//
  virtual function void connect_phase(uvm_phase phase);
// pragma uvmf custom connect_phase_pre_super begin
// pragma uvmf custom connect_phase_pre_super end
    super.connect_phase(phase);
    i2c_a.monitored_ap.connect(digicore_pred.i2c_in_ae);
    digicore_pred.i2c_expected_ap.connect(digicore_scoreboard.expected_analysis_export);
    digicore_pred.i2c_actual_ap.connect(digicore_scoreboard.actual_analysis_export);
    // pragma uvmf custom reg_model_connect_phase begin
    // pragma uvmf custom reg_model_connect_phase end
  endfunction

// ****************************************************************************
// FUNCTION: end_of_simulation_phase()
// This function is executed just prior to executing run_phase.  This function
// was added to the environment to sample environment configuration settings
// just before the simulation exits time 0.  The configuration structure is 
// randomized in the build phase before the environment structure is constructed.
// Configuration variables can be customized after randomization in the build_phase
// of the extended test.
// If a sequence modifies values in the configuration structure then the sequence is
// responsible for sampling the covergroup in the configuration if required.
//
  virtual function void start_of_simulation_phase(uvm_phase phase);
     configuration.digitop_configuration_cg.sample();
  endfunction

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end
