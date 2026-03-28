//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the control_interface signal driving.  It is
//     accessed by the uvm control_interface driver through a virtual interface
//     handle in the control_interface configuration.  It drives the singals passed
//     in through the port connection named bus of type control_interface_if.
//
//     Input signals from the control_interface_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within control_interface_if based on INITIATOR/RESPONDER and/or
//     ARBITRATION/GRANT status.  
//
//     The output signal connections are as follows:
//        signal_o -> bus.signal
//
//                                                                                           
//      Interface functions and tasks used by UVM components:
//
//             configure:
//                   This function gets configuration attributes from the
//                   UVM driver to set any required BFM configuration
//                   variables such as 'initiator_responder'.                                       
//                                                                                           
//             initiate_and_get_response:
//                   This task is used to perform signaling activity for initiating
//                   a protocol transfer.  The task initiates the transfer, using
//                   input data from the initiator struct.  Then the task captures
//                   response data, placing the data into the response struct.
//                   The response struct is returned to the driver class.
//
//             respond_and_wait_for_next_transfer:
//                   This task is used to complete a current transfer as a responder
//                   and then wait for the initiator to start the next transfer.
//                   The task uses data in the responder struct to drive protocol
//                   signals to complete the transfer.  The task then waits for 
//                   the next transfer.  Once the next transfer begins, data from
//                   the initiator is placed into the initiator struct and sent
//                   to the responder sequence for processing to determine 
//                   what data to respond with.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import control_interface_pkg_hdl::*;
import control_interface_pkg::*;

interface control_interface_driver_bfm #(
  time DVDD_STARTUP_TIME = 23us,
  time PORZ_STARTUP_TIME = 120us,
  time CLK_GD_I_STARTUP_TIME = 100us
  )

  (control_interface_if bus);

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
      $psprintf("The BFM at '%m' has the following parameters: DVDD_STARTUP_TIME=%x PORZ_STARTUP_TIME=%x CLK_GD_I_STARTUP_TIME=%x ", DVDD_STARTUP_TIME,PORZ_STARTUP_TIME,CLK_GD_I_STARTUP_TIME),
      UVM_DEBUG)
end
`endif

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri clk_i;
  tri reset_n_i;

  // Signal list (all signals are capable of being inputs and outputs for the sake
  // of supporting both INITIATOR and RESPONDER mode operation. Expectation is that 
  // directionality in the config file was from the point-of-view of the INITIATOR

  // INITIATOR mode input signals

  // INITIATOR mode output signals
  tri  dvdd_i;
  reg  dvdd_o = 'b0;
  tri  porz_i;
  reg  porz_o = 'b0;
  tri  clk_gd_i_i;
  reg  clk_gd_i_o = 'b0;

  // Bi-directional signals
  

  assign clk_i = bus.clk;
  assign reset_n_i = bus.reset_n;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.
  assign bus.dvdd = (initiator_responder == INITIATOR) ? dvdd_o : 'bz;
  assign dvdd_i = bus.dvdd;
  assign bus.porz = (initiator_responder == INITIATOR) ? porz_o : 'bz;
  assign porz_i = bus.porz;
  assign bus.clk_gd_i = (initiator_responder == INITIATOR) ? clk_gd_i_o : 'bz;
  assign clk_gd_i_i = bus.clk_gd_i;

  // Proxy handle to UVM driver
  control_interface_pkg::control_interface_driver #(
    .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
    .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
    .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
    )
  proxy;


  // ****************************************************************************
// pragma uvmf custom reset_condition_and_response begin
  // Always block used to return signals to reset value upon assertion of reset
  /* Myles Edit
  always @( negedge reset_n_i )
     begin
       // RESPONDER mode output signals
       // INITIATOR mode output signals
       dvdd_o <= 'b0;
       porz_o <= 'b0;
       clk_gd_i_o <= 'b0;
       // Bi-directional signals
 
     end    
     */
// pragma uvmf custom reset_condition_and_response end

  // pragma uvmf custom interface_item_additional begin
  // pragma uvmf custom interface_item_additional end

  //******************************************************************
  // The configure() function is used to pass agent configuration
  // variables to the driver BFM.  It is called by the driver within
  // the agent at the beginning of the simulation.  It may be called 
  // during the simulation if agent configuration variables are updated
  // and the driver BFM needs to be aware of the new configuration 
  // variables.
  //

  function void configure(control_interface_configuration 
                         #(
                         DVDD_STARTUP_TIME,
                         PORZ_STARTUP_TIME,
                         CLK_GD_I_STARTUP_TIME
                         )

                         control_interface_configuration_arg
                         );  
    initiator_responder = control_interface_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction                                                                             

// pragma uvmf custom initiate_and_get_response begin
// ****************************************************************************
// UVMF_CHANGE_ME
// This task is used by an initator.  The task first initiates a transfer then
// waits for the responder to complete the transfer.
    task initiate_and_get_response( control_interface_transaction 
                                  #(
                                  DVDD_STARTUP_TIME,
                                  PORZ_STARTUP_TIME,
                                  CLK_GD_I_STARTUP_TIME
                                  )

                                  initiator_trans  
                                  );
       // 
       // Variables within the initiator_trans:
       //
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge clk_i);
       //    
       //    How to assign a initiator_trans variable, named xyz, from a signal.   
       //    All available initiator input and inout signals listed.
       //    Initiator input signals:
       //    Initiator inout signals:
       //    How to assign a signal, named xyz, from a initiator_trans varaiable.   
       //    All available initiator output and inout signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       //    Initiator output signals:
       //      dvdd_o <= initiator_trans.xyz;  //     
       //      porz_o <= initiator_trans.xyz;  //     
       //      clk_gd_i_o <= initiator_trans.xyz;  //     
       //    Initiator inout signals:
    // Initiate a transfer using the data received.
    @(posedge clk_i);
    @(posedge clk_i);
    // Wait for the responder to complete the transfer then place the responder data into 
    // initiator_trans.
    @(posedge clk_i);
    @(posedge clk_i);
  endtask        
// pragma uvmf custom initiate_and_get_response end

// pragma uvmf custom respond_and_wait_for_next_transfer begin
// ****************************************************************************
// The first_transfer variable is used to prevent completing a transfer in the 
// first call to this task.  For the first call to this task, there is not
// current transfer to complete.
bit first_transfer=1;

// UVMF_CHANGE_ME
// This task is used by a responder.  The task first completes the current 
// transfer in progress then waits for the initiator to start the next transfer.
  
  task respond_and_wait_for_next_transfer( control_interface_transaction 
                                         #(
                                         DVDD_STARTUP_TIME,
                                         PORZ_STARTUP_TIME,
                                         CLK_GD_I_STARTUP_TIME
                                         )

                                         responder_trans  
                                         );     
  // Variables within the responder_trans:
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge clk_i);
       //    
       //    How to assign a responder_trans member, named xyz, from a signal.   
       //    All available responder input and inout signals listed.
       //    Responder input signals
       //      responder_trans.xyz = dvdd_i;  //     
       //      responder_trans.xyz = porz_i;  //     
       //      responder_trans.xyz = clk_gd_i_i;  //     
       //    Responder inout signals
       //    How to assign a signal from a responder_trans member named xyz.   
       //    All available responder output and inout signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       ///   Responder output signals
       //    Responder inout signals
    

  @(posedge clk_i);
  if (!first_transfer) begin
    // Perform transfer response here.   
    // Reply using data recieved in the responder_trans.
    @(posedge clk_i);
    // Reply using data recieved in the transaction handle.
    @(posedge clk_i);
  end
    // Wait for next transfer then gather info from intiator about the transfer.
    // Place the data into the responder_trans handle.
    @(posedge clk_i);
    @(posedge clk_i);
    first_transfer = 0;
  endtask
// pragma uvmf custom respond_and_wait_for_next_transfer end

 
endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

