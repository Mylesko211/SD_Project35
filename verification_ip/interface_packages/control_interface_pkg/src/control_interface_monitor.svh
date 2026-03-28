//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class receives control_interface transactions observed by the
//     control_interface monitor BFM and broadcasts them through the analysis port
//     on the agent. It accesses the monitor BFM through the monitor
//     task. This UVM component captures transactions
//     for viewing in the waveform viewer if the
//     enable_transaction_viewing flag is set in the configuration.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class control_interface_monitor #(
      time DVDD_STARTUP_TIME = 23us,
      time PORZ_STARTUP_TIME = 120us,
      time CLK_GD_I_STARTUP_TIME = 100us
      )
 extends uvmf_monitor_base #(
                    .CONFIG_T(control_interface_configuration  #(
                             .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
                             .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
                             .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
                             )
),
                    .BFM_BIND_T(virtual control_interface_monitor_bfm  #(
                             .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
                             .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
                             .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
                             )
),
                    .TRANS_T(control_interface_transaction  #(
                             .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
                             .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
                             .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
                             )
));

  `uvm_component_param_utils( control_interface_monitor #(
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
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
// This function sends configuration object variables to the monitor BFM 
// using the configuration struct.
//
   virtual function void configure(input CONFIG_T cfg);
      bfm.configure( cfg );

   endfunction

// ****************************************************************************
// This function places a handle to this class in the proxy variable in the
// monitor BFM.  This allows the monitor BFM to call the notify_transaction
// function within this class.
//
   virtual function void set_bfm_proxy_handle();
      bfm.proxy = this;   endfunction

// ***************************************************************************              
  virtual task run_phase(uvm_phase phase);                                                   
  // Start monitor BFM thread and don't call super.run() in order to                       
  // override the default monitor proxy 'pull' behavior with the more                      
  // emulation-friendly BFM 'push' approach using the notify_transaction                   
  // function below                                                                        
  bfm.start_monitoring();                                                   
  endtask                                                                                    
  
// **************************************************************************  
// This function is called by the monitor BFM.  It receives data observed by the
// monitor BFM.  Data is passed using the control_interface_transaction object handle.          
 virtual function void notify_transaction(control_interface_transaction
                                         #(
                                         DVDD_STARTUP_TIME,
                                         PORZ_STARTUP_TIME,
                                         CLK_GD_I_STARTUP_TIME
                                         )
 
                                         monitored_trans
                                         );
 
    trans = monitored_trans;
 
    analyze(trans);                                                                         
  endfunction  

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

