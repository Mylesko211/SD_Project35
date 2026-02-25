//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class records i2c transaction information using
//       a covergroup named i2c_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class i2c_transaction_coverage #(
      int I2C_ADDR_WIDTH = 7,
      int I2C_DATA_WIDTH = 8,
      int I2C_SLAVE_ADDRESS = 8'h22
      )
 extends uvm_subscriber #(.T(i2c_transaction #(
                                            .I2C_ADDR_WIDTH(I2C_ADDR_WIDTH),
                                            .I2C_DATA_WIDTH(I2C_DATA_WIDTH),
                                            .I2C_SLAVE_ADDRESS(I2C_SLAVE_ADDRESS)
                                            )
));

  `uvm_component_param_utils( i2c_transaction_coverage #(
                              I2C_ADDR_WIDTH,
                              I2C_DATA_WIDTH,
                              I2C_SLAVE_ADDRESS
                              )
)

  T coverage_trans;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  // ****************************************************************************
  covergroup i2c_transaction_cg;
    // pragma uvmf custom covergroup begin
    // UVMF_CHANGE_ME : Add coverage bins, crosses, exclusions, etc. according to coverage needs.
    option.auto_bin_max=1024;
    option.per_instance=1;
    addr: coverpoint coverage_trans.addr;
    data: coverpoint coverage_trans.data;
    op: coverpoint coverage_trans.op;
    // pragma uvmf custom covergroup end
  endgroup

  // ****************************************************************************
  // FUNCTION : new()
  // This function is the standard SystemVerilog constructor.
  //
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    i2c_transaction_cg=new;
    `uvm_warning("COVERAGE_MODEL_REVIEW", "A covergroup has been constructed which may need review because of either generation or re-generation with merging.  Please note that transaction variables added as a result of re-generation and merging are not automatically added to the covergroup.  Remove this warning after the covergroup has been reviewed.")
  endfunction

  // ****************************************************************************
  // FUNCTION : build_phase()
  // This function is the standard UVM build_phase.
  //
  function void build_phase(uvm_phase phase);
    i2c_transaction_cg.set_inst_name($sformatf("i2c_transaction_cg_%s",get_full_name()));
  endfunction

  // ****************************************************************************
  // FUNCTION: write (T t)
  // This function is automatically executed when a transaction arrives on the
  // analysis_export.  It copies values from the variables in the transaction 
  // to local variables used to collect functional coverage.  
  //
  virtual function void write (T t);
    `uvm_info("COV","Received transaction",UVM_HIGH);
    coverage_trans = t;
    i2c_transaction_cg.sample();
  endfunction

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

