//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the control_interface interface signals.
//      It is instantiated once per control_interface bus.  Bus Functional Models, 
//      BFM's named control_interface_driver_bfm, are used to drive signals on the bus.
//      BFM's named control_interface_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(control_interface_bus.dvdd), // Agent output 
// .dut_signal_port(control_interface_bus.porz), // Agent output 
// .dut_signal_port(control_interface_bus.clk_gd_i), // Agent output 

import uvmf_base_pkg_hdl::*;
import control_interface_pkg_hdl::*;

interface  control_interface_if #(
  time DVDD_STARTUP_TIME = 23us,
  time PORZ_STARTUP_TIME = 120us,
  time CLK_GD_I_STARTUP_TIME = 100us
  )


  (
  input tri clk, 
  input tri reset_n,
  inout tri  dvdd,
  inout tri  porz,
  inout tri  clk_gd_i
  );

modport monitor_port 
  (
  input clk,
  input reset_n,
  input dvdd,
  input porz,
  input clk_gd_i
  );

modport initiator_port 
  (
  input clk,
  input reset_n,
  output dvdd,
  output porz,
  output clk_gd_i
  );

modport responder_port 
  (
  input clk,
  input reset_n,  
  input dvdd,
  input porz,
  input clk_gd_i
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

