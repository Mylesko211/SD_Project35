//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class passes transactions between the sequencer
//        and the BFM driver interface.  It accesses the driver BFM 
//        through the bfm handle. This driver
//        passes transactions to the driver BFM through the access
//        task.  
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class control_interface_driver  #(
      time DVDD_STARTUP_TIME = 23us,
      time PORZ_STARTUP_TIME = 120us,
      time CLK_GD_I_STARTUP_TIME = 100us
      )
 extends uvmf_driver_base #(
                   .CONFIG_T(control_interface_configuration  #(
                             .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
                             .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
                             .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
                             )
 ),
                   .BFM_BIND_T(virtual control_interface_driver_bfm  #(
                             .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
                             .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
                             .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
                             )
 ),
                   .REQ(control_interface_transaction  #(
                             .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
                             .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
                             .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
                             )
 ),
                   .RSP(control_interface_transaction  #(
                             .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
                             .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
                             .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
                             )
 ));

  `uvm_component_param_utils( control_interface_driver #(
                              DVDD_STARTUP_TIME,
                              PORZ_STARTUP_TIME,
                              CLK_GD_I_STARTUP_TIME
                              )
)

// pragma uvmf custom class_item_additional begin
// pragma uvmf custom class_item_additional end

// ****************************************************************************
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent=null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
// This function sends configuration object variables to the driver BFM 
// using the configuration struct.
//
  virtual function void configure(input CONFIG_T cfg);
      bfm.configure( cfg );
  endfunction

// ****************************************************************************
// This function places a handle to this class in the proxy variable in the
// driver BFM.  This allows the driver BFM to call tasks and function within this class.
//
  virtual function void set_bfm_proxy_handle();
    bfm.proxy = this;  endfunction

// **************************************************************************** 
// This task is called by the run_phase in uvmf_driver_base.              
  virtual task access( inout REQ txn );
// pragma uvmf custom access begin
    if (configuration.initiator_responder==RESPONDER) begin
      // Complete current transfer and wait for next transfer
      bfm.respond_and_wait_for_next_transfer( txn );
    end else begin    
      // Initiate a transfer and get response
      bfm.initiate_and_get_response( txn );
    end
// pragma uvmf custom access end
  endtask

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

