//----------------------------------------------------------------------
// Directed register-map sweep coverage test.
//----------------------------------------------------------------------

class reg_map_sweep_test extends test_top;

  `uvm_component_utils( reg_map_sweep_test );

  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  virtual function void build_phase(uvm_phase phase);
    digicore_bench_sequence_base::type_id::set_type_override(reg_map_sweep_test_sequence::get_type());
    super.build_phase(phase);
  endfunction

endclass
