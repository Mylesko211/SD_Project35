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
class i2c_reg_write_sequence #(
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

  `uvm_object_param_utils( i2c_reg_write_sequence #(
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
      i2c_driver_bfm.write(reg_addr = GEN_REG0, data_byte = 8'hAB); // Example of using the write task in the driver BFM. You can replace the parameters with random values or variables as needed.
      // Send the transaction to the i2c_driver_bfm via the sequencer and i2c_driver.
      finish_item(req);
      `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)

  endtask

endclass: i2c_reg_write_sequence

// pragma uvmf custom external begin
// pragma uvmf custom external end

