//----------------------------------------------------------------------
// Created with uvmf_gen version 2026.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    interface package that will run on the host simulator.
//
// CONTAINS:
//    - <i2c_typedefs_hdl>
//    - <i2c_typedefs.svh>
//    - <i2c_transaction.svh>

//    - <i2c_configuration.svh>
//    - <i2c_driver.svh>
//    - <i2c_monitor.svh>

//    - <i2c_transaction_coverage.svh>
//    - <i2c_sequence_base.svh>
//    - <i2c_random_sequence.svh>

//    - <i2c_responder_sequence.svh>
//    - <i2c2reg_adapter.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package i2c_pkg;
  
   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import i2c_pkg_hdl::*;

   `include "uvm_macros.svh"

   // pragma uvmf custom package_imports_additional begin 
   // pragma uvmf custom package_imports_additional end

   export i2c_pkg_hdl::*;
   
 

   // Parameters defined as HVL parameters

   `include "src/i2c_typedefs.svh"
   `include "src/i2c_transaction.svh"

   `include "src/i2c_configuration.svh"
   `include "src/i2c_driver.svh"
   `include "src/i2c_monitor.svh"

   `include "src/i2c_transaction_coverage.svh"
   `include "src/i2c_sequence_base.svh"
   `include "src/i2c_random_sequence.svh"
   `include "src/i2c_reg_map_sweep_sequence.svh"

   `include "src/i2c_responder_sequence.svh"
   `include "src/i2c2reg_adapter.svh"

   `include "src/i2c_agent.svh"

   // pragma uvmf custom package_item_additional begin
   // UVMF_CHANGE_ME : When adding new interface sequences to the src directory
   //    be sure to add the sequence file here so that it will be
   //    compiled as part of the interface package.  Be sure to place
   //    the new sequence after any base sequences of the new sequence.
   // pragma uvmf custom package_item_additional end

endpackage

// pragma uvmf custom external begin
// pragma uvmf custom external end
