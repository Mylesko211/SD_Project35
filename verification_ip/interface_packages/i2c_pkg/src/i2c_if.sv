//----------------------------------------------------------------------
// Created with uvmf_gen version 2026.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the i2c interface signals.
//      It is instantiated once per i2c bus.  Bus Functional Models, 
//      BFM's named i2c_driver_bfm, are used to drive signals on the bus.
//      BFM's named i2c_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(i2c_bus.sda), // Agent inout 

import uvmf_base_pkg_hdl::*;
import i2c_pkg_hdl::*;

interface  i2c_if #(
  int I2C_ADDR_WIDTH = 7,
  int I2C_DATA_WIDTH = 8,
  int I2C_SLAVE_ADDRESS = 8'h22
  )


  (
  input tri scl, 
  input tri reset_n,
  inout tri  sda
  );

modport monitor_port 
  (
  input scl,
  input reset_n,
  input sda
  );

modport initiator_port 
  (
  input scl,
  input reset_n,
  inout sda
  );

modport responder_port 
  (
  input scl,
  input reset_n,  
  inout sda
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

