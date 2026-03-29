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
  // FIX 1: Added the missing state variables here
  bit is_test_mode = 0;       // 0 = Regular Mode, 1 = Test Mode
  int test_seq_step = 0;      // Tracks how far along we are in the 9-1-9 sequence
  // pragma uvmf custom class_item_additional end
  
  // ****************************************************************************
  covergroup i2c_transaction_cg;
    // pragma uvmf custom covergroup begin
    option.auto_bin_max=1024;
    option.per_instance=1;

    // 1. Coverpoint for Address 
    addr: coverpoint coverage_trans.addr {
      bins general_regs[]       = {[0:7]};
      bins control_regs[]       = {[8:12]};
      bins reserved_regs[]      = {[13:31]};
      bins trim_regs[]          = {[32:47]};
      bins system_control_reg   = {48};
      bins i2c_read_reg         = {49};
      bins test_reg             = {50};
      bins out_of_bounds        = default; 
    }
    
    // 2. Coverpoint for Data
    data: coverpoint coverage_trans.data;
    
    // 3. Coverpoint for Operation
    op: coverpoint coverage_trans.op;

    // 4. Coverpoint for Mode State 
    mode: coverpoint is_test_mode {
      bins regular_mode = {0};
      bins test_mode    = {1};
    }

    // 5. 3-Way Cross Coverage 
    cr_op_addr_mode: cross op, addr, mode {
      
      // FIX 2: Changed 'intersecting' to 'intersect'
      ignore_bins regular_ro_writes = binsof(mode.regular_mode) && 
                                      binsof(op) intersect {I2C_WR} && 
                                      (binsof(addr.control_regs) || 
                                       binsof(addr.reserved_regs) || 
                                       binsof(addr.trim_regs) || 
                                       binsof(addr.i2c_read_reg));
    }

    cp_reg8_special_data: coverpoint coverage_trans.data iff (coverage_trans.addr == 8 && coverage_trans.op == I2C_WR) {
      
      wildcard bins pattern_00 = {8'b1?00????};
      wildcard bins pattern_01 = {8'b1?01????};
      wildcard bins pattern_10 = {8'b1?10????};
      wildcard bins pattern_11 = {8'b1?11????};
      
      // Catch-all for any other data written to register 8
      bins other_data = default; 
    }


    // pragma uvmf custom covergroup end
  endgroup

  // ****************************************************************************
  // FUNCTION : new()
  //
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    i2c_transaction_cg=new;
  endfunction

  // ****************************************************************************
  // FUNCTION : build_phase()
  //
  function void build_phase(uvm_phase phase);
    i2c_transaction_cg.set_inst_name($sformatf("i2c_transaction_cg_%s",get_full_name()));
  endfunction

  // ****************************************************************************
  // FUNCTION: write (T t)
  //
virtual function void write (T t);
    `uvm_info("COV","Received transaction",UVM_HIGH);
    // pragma uvmf custom coverage begin
    coverage_trans = t;

    // We must ensure the data array has at least 1 byte before checking index [0]
    if (coverage_trans.op == I2C_WR && coverage_trans.data.size() > 0) begin
      if (coverage_trans.addr == 50) begin // Test Register
        
        if (is_test_mode == 0) begin
          // We are in Regular Mode, looking for 9-1-9
          // Check the first byte of the data payload payload (index 0)
          if      (test_seq_step == 0 && coverage_trans.data[0] == 8'h09) test_seq_step = 1;
          else if (test_seq_step == 1 && coverage_trans.data[0] == 8'h01) test_seq_step = 2;
          else if (test_seq_step == 2 && coverage_trans.data[0] == 8'h09) begin
            is_test_mode = 1;  
            `uvm_info("COV", "ENTERED TEST MODE", UVM_LOW)
            test_seq_step = 0; 
          end 
          else begin
            test_seq_step = 0; 
          end
        end 
        else begin
          // We are in Test Mode. Exit if any number EXCEPT 9 is written.
          if (coverage_trans.data[0] != 8'h09) begin
            is_test_mode = 0;  
            `uvm_info("COV", "EXITED TEST MODE", UVM_LOW)
            test_seq_step = 0;
          end
        end

      end else begin
        // A write to any OTHER register breaks the sequence
        test_seq_step = 0; 
      end
    end

    // Finally, sample the coverage after the state is updated
    i2c_transaction_cg.sample();
    // pragma uvmf custom coverage end
  endfunction

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end





































/*
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


    addr: coverpoint coverage_trans.addr
    {
    bins general_regs[] = {[0:7]};
    bins control_regs[] = {[8:12]};
    bins reserved_regs[] = {[13:31]};
    bins trim_regs[] = {[32:47]};
    bins system_control_reg = {[48]};
    bins i2c_read_reg = {[49]};
    bins test_reg = {[50]};

    bins out_of_bounds        = default;
    }
    data: coverpoint coverage_trans.data;
    op: coverpoint coverage_trans.op;

    // 4. CROSS COVERAGE: This ensures BOTH Read and Write happen to EACH mapped address
    cr_op_addr: cross op, addr {
      // Optional: If you know you aren't supposed to write to the 'i2c_read_reg',
      // you can tell the coverage tool to ignore that specific combination 
      // so you can still reach 100% coverage overall.
      // ignore_bins ignore_read_only_writes = binsof(op) intersecting {I2C_WR} && binsof(addr.i2c_read_reg);
    }

    // pragma uvmf custom covergroup end
  endgroup

  // ****************************************************************************
  // FUNCTION : new()
  // This function is the standard SystemVerilog constructor.
  //
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    i2c_transaction_cg=new;
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

*/