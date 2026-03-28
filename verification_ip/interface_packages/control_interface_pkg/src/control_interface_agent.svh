//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// DESCRIPTION: Protocol specific agent class definition
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class control_interface_agent #(
     time DVDD_STARTUP_TIME = 23us,
     time PORZ_STARTUP_TIME = 120us,
     time CLK_GD_I_STARTUP_TIME = 100us
     )
 extends uvmf_parameterized_agent #(
                    .CONFIG_T(control_interface_configuration #(
                              .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
                              .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
                              .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
                              )
),
                    .DRIVER_T(control_interface_driver #(
                              .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
                              .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
                              .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
                              )
),
                    .MONITOR_T(control_interface_monitor #(
                               .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
                               .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
                               .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
                               )
),
                    .COVERAGE_T(control_interface_transaction_coverage #(
                                .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
                                .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
                                .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
                                )
),
                    .TRANS_T(control_interface_transaction #(
                             .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
                             .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
                             .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
                             )
)
                    );

  `uvm_component_param_utils( control_interface_agent #(
                              DVDD_STARTUP_TIME,
                              PORZ_STARTUP_TIME,
                              CLK_GD_I_STARTUP_TIME
                              )
)

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
  // FUNCTION: build_phase
  virtual function void build_phase(uvm_phase phase);
// pragma uvmf custom build_phase_pre_super begin
// pragma uvmf custom build_phase_pre_super end
    super.build_phase(phase);
    if (configuration.active_passive == ACTIVE) begin
      // Place sequencer handle into configuration object
      // so that it may be retrieved from configuration 
      // rather than using uvm_config_db
      configuration.sequencer = this.sequencer;
    end
  endfunction
  
endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

