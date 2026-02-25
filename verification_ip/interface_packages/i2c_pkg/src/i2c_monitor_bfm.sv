//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the i2c signal monitoring.
//      It is accessed by the uvm i2c monitor through a virtual
//      interface handle in the i2c configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type i2c_if.
//
//     Input signals from the i2c_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//      Interface functions and tasks used by UVM components:
//             monitor(inout TRANS_T txn);
//                   This task receives the transaction, txn, from the
//                   UVM monitor and then populates variables in txn
//                   from values observed on bus activity.  This task
//                   blocks until an operation on the i2c bus is complete.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import i2c_pkg_hdl::*;
import i2c_pkg::*;


interface i2c_monitor_bfm #(
  int I2C_ADDR_WIDTH = 7,
  int I2C_DATA_WIDTH = 8,
  int I2C_SLAVE_ADDRESS = 8'h22
  )

  ( i2c_if  bus );

`ifndef XRTL
// This code is to aid in debugging parameter mismatches between the BFM and its corresponding agent.
// Enable this debug by setting UVM_VERBOSITY to UVM_DEBUG
// Setting UVM_VERBOSITY to UVM_DEBUG causes all BFM's and all agents to display their parameter settings.
// All of the messages from this feature have a UVM messaging id value of "CFG"
// The transcript or run.log can be parsed to ensure BFM parameter settings match its corresponding agents parameter settings.
import uvm_pkg::*;
`include "uvm_macros.svh"
initial begin : bfm_vs_agent_parameter_debug
  `uvm_info("CFG", 
      $psprintf("The BFM at '%m' has the following parameters: I2C_ADDR_WIDTH=%x I2C_DATA_WIDTH=%x I2C_SLAVE_ADDRESS=%x ", I2C_ADDR_WIDTH,I2C_DATA_WIDTH,I2C_SLAVE_ADDRESS),
      UVM_DEBUG)
end
`endif


 i2c_transaction #(
                      I2C_ADDR_WIDTH,
                      I2C_DATA_WIDTH,
                      I2C_SLAVE_ADDRESS
                      )
 
                      monitored_trans;
 

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri scl_i;
  tri reset_n_i;
  tri  sda_i;
  assign scl_i = bus.scl;
  assign reset_n_i = bus.reset_n;
  assign sda_i = bus.sda;

  // Proxy handle to UVM monitor
  i2c_pkg::i2c_monitor #(
    .I2C_ADDR_WIDTH(I2C_ADDR_WIDTH),
    .I2C_DATA_WIDTH(I2C_DATA_WIDTH),
    .I2C_SLAVE_ADDRESS(I2C_SLAVE_ADDRESS)
    )
 proxy;

  // pragma uvmf custom interface_item_additional begin
  // pragma uvmf custom interface_item_additional end
  
  //******************************************************************                         
  task wait_for_reset(); 
    @(posedge scl_i) ;                                                                    
    do_wait_for_reset();                                                                   
  endtask                                                                                   

  // ****************************************************************************              
  task do_wait_for_reset(); 
  // pragma uvmf custom reset_condition begin
    wait ( reset_n_i === 1 ) ;                                                              
    @(posedge scl_i) ;                                                                    
  // pragma uvmf custom reset_condition end                                                                
  endtask    

  //******************************************************************                         
 
  task wait_for_num_clocks(input int unsigned count); 
    @(posedge scl_i);  
                                                                   
    repeat (count-1) @(posedge scl_i);                                                    
  endtask      

  //******************************************************************                         
  event go;                                                                                 
  function void start_monitoring();  
    -> go;
  endfunction                                                                               
  
  // ****************************************************************************              
  initial begin                                                                             
    @go;                                                                                   
    forever begin                                                                        
      @(posedge scl_i);  
      monitored_trans = new("monitored_trans");
      do_monitor( );
                                                                 
 
      proxy.notify_transaction( monitored_trans ); 
 
    end                                                                                    
  end                                                                                       

  //******************************************************************
  // The configure() function is used to pass agent configuration
  // variables to the monitor BFM.  It is called by the monitor within
  // the agent at the beginning of the simulation.  It may be called 
  // during the simulation if agent configuration variables are updated
  // and the monitor BFM needs to be aware of the new configuration 
  // variables.
  //
    function void configure(i2c_configuration 
                         #(
                         I2C_ADDR_WIDTH,
                         I2C_DATA_WIDTH,
                         I2C_SLAVE_ADDRESS
                         )
 
                         i2c_configuration_arg
                         );  
    initiator_responder = i2c_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction   


  // ****************************************************************************  
  task do_monitor();
    //
    // Available struct members:
    //     //    monitored_trans.addr
    //     //    monitored_trans.data
    //     //    monitored_trans.op
    //     //
    // Reference code;
    //    How to wait for signal value
    //      while (control_signal === 1'b1) @(posedge scl_i);
    //    
    //    How to assign a transaction variable, named xyz, from a signal.   
    //    All available input signals listed.
    //      monitored_trans.xyz = sda_i;  //     
    // pragma uvmf custom do_monitor begin
    // UVMF_CHANGE_ME : Implement protocol monitoring.  The commented reference code 
    // below are examples of how to capture signal values and assign them to 
    // structure members.  All available input signals are listed.  The 'while' 
    // code example shows how to wait for a synchronous flow control signal.  This
    // task should return when a complete transfer has been observed.  Once this task is
    // exited with captured values, it is then called again to wait for and observe 
    // the next transfer. One clock cycle is consumed between calls to do_monitor.
    monitored_trans.start_time = $time;
    @(posedge scl_i);
    @(posedge scl_i);
    @(posedge scl_i);
    @(posedge scl_i);
    monitored_trans.end_time = $time;
    // pragma uvmf custom do_monitor end
  endtask         
  
 
endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

