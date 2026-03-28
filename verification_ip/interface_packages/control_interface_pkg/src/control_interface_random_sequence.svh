//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the control_interface transaction and sends it 
// to the UVM driver.
//
// This sequence constructs and randomizes a control_interface_transaction.
// 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class control_interface_random_sequence #(
      time DVDD_STARTUP_TIME = 23us,
      time PORZ_STARTUP_TIME = 120us,
      time CLK_GD_I_STARTUP_TIME = 100us
      )

  extends control_interface_sequence_base #(
      .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
      .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
      .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
      )
;

  `uvm_object_param_utils( control_interface_random_sequence #(
                           DVDD_STARTUP_TIME,
                           PORZ_STARTUP_TIME,
                           CLK_GD_I_STARTUP_TIME
                           )
)

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  //*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

  // ****************************************************************************
  // TASK : body()
  // This task is automatically executed when this sequence is started using the 
  // start(sequencerHandle) task.
  //
  task body();
  
      // Construct the transaction
      req=control_interface_transaction#(
                .DVDD_STARTUP_TIME(DVDD_STARTUP_TIME),
                .PORZ_STARTUP_TIME(PORZ_STARTUP_TIME),
                .CLK_GD_I_STARTUP_TIME(CLK_GD_I_STARTUP_TIME)
                )
::type_id::create("req");
      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "control_interface_random_sequence::body()-control_interface_transaction randomization failed")
      // Send the transaction to the control_interface_driver_bfm via the sequencer and control_interface_driver.
      finish_item(req);
      `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)

  endtask

endclass: control_interface_random_sequence

// pragma uvmf custom external begin
// pragma uvmf custom external end

