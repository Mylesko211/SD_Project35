//----------------------------------------------------------------------
// Created with uvmf_gen version 2026.1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    environment package that will run on the host simulator.
//
// CONTAINS:
//     - <digitop_configuration.svh>
//     - <digitop_environment.svh>
//     - <digitop_env_sequence_base.svh>
//     - <digicore_predictor.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package digitop_env_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import uvmf_base_pkg::*;
  import i2c_pkg::*;
  import i2c_pkg_hdl::*;
 
  `uvm_analysis_imp_decl(_i2c_in_ae)

  // pragma uvmf custom package_imports_additional begin
  // pragma uvmf custom package_imports_additional end

  // Parameters defined as HVL parameters

  `include "src/digitop_env_typedefs.svh"
  `include "src/digitop_env_configuration.svh"
  `include "src/digicore_predictor.svh"
  `include "src/digitop_environment.svh"
  `include "src/digitop_env_sequence_base.svh"

  // pragma uvmf custom package_item_additional begin
  // UVMF_CHANGE_ME : When adding new environment level sequences to the src directory
  //    be sure to add the sequence file here so that it will be
  //    compiled as part of the environment package.  Be sure to place
  //    the new sequence after any base sequence of the new sequence.
  // pragma uvmf custom package_item_additional end

endpackage

// pragma uvmf custom external begin
// pragma uvmf custom external end

