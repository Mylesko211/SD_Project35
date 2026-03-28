//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
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
//    - <control_interface_typedefs_hdl>
//    - <control_interface_typedefs.svh>
//    - <control_interface_transaction.svh>

//    - <control_interface_configuration.svh>
//    - <control_interface_driver.svh>
//    - <control_interface_monitor.svh>

//    - <control_interface_transaction_coverage.svh>
//    - <control_interface_sequence_base.svh>
//    - <control_interface_random_sequence.svh>

//    - <control_interface_responder_sequence.svh>
//    - <control_interface2reg_adapter.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package control_interface_pkg;
  
   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import control_interface_pkg_hdl::*;

   `include "uvm_macros.svh"

   // pragma uvmf custom package_imports_additional begin 
   // pragma uvmf custom package_imports_additional end

   export control_interface_pkg_hdl::*;
   
 

   // Parameters defined as HVL parameters

   `include "src/control_interface_typedefs.svh"
   `include "src/control_interface_transaction.svh"

   `include "src/control_interface_configuration.svh"
   `include "src/control_interface_driver.svh"
   `include "src/control_interface_monitor.svh"

   `include "src/control_interface_transaction_coverage.svh"
   `include "src/control_interface_sequence_base.svh"
   `include "src/control_interface_random_sequence.svh"

   `include "src/control_interface_responder_sequence.svh"
   `include "src/control_interface2reg_adapter.svh"

   `include "src/control_interface_agent.svh"

   // pragma uvmf custom package_item_additional begin
   // UVMF_CHANGE_ME : When adding new interface sequences to the src directory
   //    be sure to add the sequence file here so that it will be
   //    compiled as part of the interface package.  Be sure to place
   //    the new sequence after any base sequences of the new sequence.
   // pragma uvmf custom package_item_additional end

endpackage

// pragma uvmf custom external begin
// pragma uvmf custom external end

