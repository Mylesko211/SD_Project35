//----------------------------------------------------------------------
// Created with uvmf_gen version 2026.1
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
class i2c_agent #(
     int I2C_ADDR_WIDTH = 7,
     int I2C_DATA_WIDTH = 8,
     int I2C_SLAVE_ADDRESS = 8'h22
     )
 extends uvmf_parameterized_agent #(
                    .CONFIG_T(i2c_configuration #(
                              .I2C_ADDR_WIDTH(I2C_ADDR_WIDTH),
                              .I2C_DATA_WIDTH(I2C_DATA_WIDTH),
                              .I2C_SLAVE_ADDRESS(I2C_SLAVE_ADDRESS)
                              )
),
                    .DRIVER_T(i2c_driver #(
                              .I2C_ADDR_WIDTH(I2C_ADDR_WIDTH),
                              .I2C_DATA_WIDTH(I2C_DATA_WIDTH),
                              .I2C_SLAVE_ADDRESS(I2C_SLAVE_ADDRESS)
                              )
),
                    .MONITOR_T(i2c_monitor #(
                               .I2C_ADDR_WIDTH(I2C_ADDR_WIDTH),
                               .I2C_DATA_WIDTH(I2C_DATA_WIDTH),
                               .I2C_SLAVE_ADDRESS(I2C_SLAVE_ADDRESS)
                               )
),
                    .COVERAGE_T(i2c_transaction_coverage #(
                                .I2C_ADDR_WIDTH(I2C_ADDR_WIDTH),
                                .I2C_DATA_WIDTH(I2C_DATA_WIDTH),
                                .I2C_SLAVE_ADDRESS(I2C_SLAVE_ADDRESS)
                                )
),
                    .TRANS_T(i2c_transaction #(
                             .I2C_ADDR_WIDTH(I2C_ADDR_WIDTH),
                             .I2C_DATA_WIDTH(I2C_DATA_WIDTH),
                             .I2C_SLAVE_ADDRESS(I2C_SLAVE_ADDRESS)
                             )
)
                    );

  `uvm_component_param_utils( i2c_agent #(
                              I2C_ADDR_WIDTH,
                              I2C_DATA_WIDTH,
                              I2C_SLAVE_ADDRESS
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

