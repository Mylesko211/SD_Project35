//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the i2c transaction and sends it 
// to the UVM driver.
//
// This sequence constructs and randomizes a i2c_transaction.
// 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class i2c_random_sequence #(
      int I2C_ADDR_WIDTH = 7,
      int I2C_DATA_WIDTH = 8,
      int I2C_SLAVE_ADDRESS = 8'h22
      )

  extends i2c_sequence_base #(
      .I2C_ADDR_WIDTH(I2C_ADDR_WIDTH),
      .I2C_DATA_WIDTH(I2C_DATA_WIDTH),
      .I2C_SLAVE_ADDRESS(I2C_SLAVE_ADDRESS)
      )
;

  `uvm_object_param_utils( i2c_random_sequence #(
                           I2C_ADDR_WIDTH,
                           I2C_DATA_WIDTH,
                           I2C_SLAVE_ADDRESS
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
      req=i2c_transaction#(
                .I2C_ADDR_WIDTH(I2C_ADDR_WIDTH),
                .I2C_DATA_WIDTH(I2C_DATA_WIDTH),
                .I2C_SLAVE_ADDRESS(I2C_SLAVE_ADDRESS)
                )
::type_id::create("req");
      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "i2c_random_sequence::body()-i2c_transaction randomization failed")
      // Send the transaction to the i2c_driver_bfm via the sequencer and i2c_driver.
      finish_item(req);
      `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)

  endtask

endclass: i2c_random_sequence

// pragma uvmf custom external begin
// pragma uvmf custom external end

