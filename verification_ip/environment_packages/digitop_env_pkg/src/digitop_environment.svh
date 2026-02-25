//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
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






   // Instantiate register model adapter and predictor
   typedef i2c_reg_adapter    reg_adapter_t;
   reg_adapter_t    reg_adapter;
   typedef uvm_reg_predictor #(i2c_transaction#(.I2C_ADDR_WIDTH(7),.I2C_DATA_WIDTH(8),.I2C_SLAVE_ADDRESS(8'h22))) reg_predictor_t;
   reg_predictor_t    reg_predictor;


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
// pragma uvmf custom reg_model_build_phase begin
  // Build register model predictor if prediction is enabled
  if (configuration.enable_reg_prediction) begin
    reg_predictor = new("reg_predictor", this);
  end
// pragma uvmf custom reg_model_build_phase end

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
    // pragma uvmf custom reg_model_connect_phase begin
    // Create register model adapter if required
    if (configuration.enable_reg_prediction ||
        configuration.enable_reg_adaptation)
      reg_adapter = new("reg_adapter");
    // Set sequencer and adapter in register model map
    if ((configuration.enable_reg_adaptation) && (i2c_a.sequencer != null ))
      configuration.digitop_rm.bus_map.set_sequencer(i2c_a.sequencer, reg_adapter);
    // Set map and adapter handles within uvm predictor
    if (configuration.enable_reg_prediction) begin
      reg_predictor.map     = configuration.digitop_rm.bus_map;
      reg_predictor.adapter = reg_adapter;
      // The connection between the agent analysis_port and uvm_reg_predictor 
      // analysis_export could cause problems due to a uvm register package bug,
      // if this environment is used as a sub-environment at a higher level.
      // The uvm register package does not construct sub-maps within register
      // sub blocks.  While the connection below succeeds, the execution of the
      // write method associated with the analysis_export fails.  It fails because
      // the write method executes the get_reg_by_offset method of the register
      // map, which is null because of the uvm register package bug.
      // The call works when operating at block level because the uvm register 
      // package constructs the top level register map.  The call fails when the 
      // register map associated with this environment is a sub-map.  Construction
      // of the sub-maps must be done manually.
      //i2c_a.monitored_ap.connect(reg_predictor.bus_in);
    end
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

