//----------------------------------------------------------------------
// Reusable I2C sequence that sweeps the full register map.
//----------------------------------------------------------------------

class i2c_reg_map_sweep_sequence extends i2c_sequence_base #(
      .I2C_ADDR_WIDTH(7),
      .I2C_DATA_WIDTH(8),
      .I2C_SLAVE_ADDRESS(8'h22)
      );

  `uvm_object_utils( i2c_reg_map_sweep_sequence );

  function new(string name = "");
    super.new(name);
  endfunction

  task automatic send_i2c_write(bit [7:0] write_addr, bit [7:0] write_data, string txn_name);
    req.set_name(txn_name);
    start_item(req);
    req.addr = 7'h22;
    req.op = I2C_WR;
    req.reg_addr_valid = 1'b1;
    req.reg_addr_dbg = write_addr;
    req.data.delete();
    req.data.push_back(write_addr);
    req.data.push_back(write_data);
    finish_item(req);
  endtask

  task automatic send_i2c_read(bit [7:0] read_addr, string txn_name);
    req.set_name(txn_name);
    start_item(req);
    req.addr = 7'h22;
    req.op = I2C_RD;
    req.reg_addr_valid = 1'b1;
    req.reg_addr_dbg = read_addr;
    req.data.delete();
    req.data.push_back(8'h00);
    finish_item(req);
  endtask

  task automatic write_and_readback(bit [7:0] reg_addr, bit [7:0] reg_data, string label);
    send_i2c_write(reg_addr, reg_data, $sformatf("%s_wr_%0h_%0h", label, reg_addr, reg_data));
    send_i2c_write(8'h31, reg_addr, $sformatf("%s_ptr_%0h", label, reg_addr));
    send_i2c_read(reg_addr, $sformatf("%s_rd_%0h", label, reg_addr));
  endtask

  virtual task body();
    bit [7:0] trim_addr;

    for (int unsigned addr = 8'h00; addr <= 8'h07; addr++) begin
      write_and_readback(addr[7:0], (8'h10 + addr[7:0]), "pass0");
      write_and_readback(addr[7:0], (8'h80 + addr[7:0]), "pass1");
    end

    write_and_readback(8'h08, 8'h2A, "pass0");
    write_and_readback(8'h08, 8'h54, "pass1");
    write_and_readback(8'h09, 8'h00, "pass0");
    write_and_readback(8'h09, 8'h00, "pass1");
    write_and_readback(8'h0A, 8'h03, "pass0");
    write_and_readback(8'h0A, 8'h55, "pass1");
    write_and_readback(8'h0B, 8'h20, "pass0");
    write_and_readback(8'h0B, 8'hE0, "pass1");
    write_and_readback(8'h0C, 8'h01, "pass0");
    write_and_readback(8'h0C, 8'h02, "pass1");
    write_and_readback(8'h30, 8'h01, "pass0");
    write_and_readback(8'h30, 8'h7F, "pass1");
    write_and_readback(8'h31, 8'h31, "pass0");
    write_and_readback(8'h31, 8'h31, "pass1");

    write_and_readback(8'h32, 8'h09, "testkey0");
    write_and_readback(8'h32, 8'h01, "testkey1");
    write_and_readback(8'h32, 8'h09, "testkey2");

    for (trim_addr = 8'h20; trim_addr <= 8'h2F; trim_addr++) begin
      write_and_readback(trim_addr, (8'h20 + trim_addr), "trim0");
      write_and_readback(trim_addr, (8'h40 + trim_addr), "trim1");
    end

    write_and_readback(8'h32, 8'h09, "pass0");
    write_and_readback(8'h32, 8'h01, "pass1");
  endtask

endclass
