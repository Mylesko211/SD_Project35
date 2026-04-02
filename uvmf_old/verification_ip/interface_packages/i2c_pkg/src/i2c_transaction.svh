//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class defines the variables required for an i2c
//    transaction.  Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class i2c_transaction #(
      int I2C_ADDR_WIDTH = 7,
      int I2C_DATA_WIDTH = 8,
      int I2C_SLAVE_ADDRESS = 8'h22
      )
 extends uvmf_transaction_base;

  `uvm_object_param_utils( i2c_transaction #(
                           I2C_ADDR_WIDTH,
                           I2C_DATA_WIDTH,
                           I2C_SLAVE_ADDRESS
                           )
)

  rand bit [I2C_ADDR_WIDTH-1:0] addr ;
  rand bit [I2C_DATA_WIDTH-1:0] data [$];
  rand i2c_op_t op ;

  const static bit [I2C_DATA_WIDTH-1:0] GEN_REG0_ADDR       = 8'h00;
  const static bit [I2C_DATA_WIDTH-1:0] GEN_REG7_ADDR       = 8'h07;
  const static bit [I2C_DATA_WIDTH-1:0] WD_CTRL_REG_ADDR    = 8'h08;
  const static bit [I2C_DATA_WIDTH-1:0] OTP_CMD_REG_ADDR    = 8'h09;
  const static bit [I2C_DATA_WIDTH-1:0] OTP_ADDR_REG_ADDR   = 8'h0A;
  const static bit [I2C_DATA_WIDTH-1:0] OTP_STATUS_REG_ADDR = 8'h0B;
  const static bit [I2C_DATA_WIDTH-1:0] INT_CTRL_REG_ADDR   = 8'h0C;
  const static bit [I2C_DATA_WIDTH-1:0] TRIM_REG0_ADDR      = 8'h20;
  const static bit [I2C_DATA_WIDTH-1:0] TRIM_REGF_ADDR      = 8'h2F;
  const static bit [I2C_DATA_WIDTH-1:0] SYS_CTRL_REG_ADDR   = 8'h30;
  const static bit [I2C_DATA_WIDTH-1:0] I2C_READ_ADDR_ADDR  = 8'h31;
  const static bit [I2C_DATA_WIDTH-1:0] TEST_REG_ADDR       = 8'h32;

  const static bit [I2C_DATA_WIDTH-1:0] OTP_CMD_RELOAD      = 8'h5A;
  const static bit [I2C_DATA_WIDTH-1:0] OTP_CMD_PROGRAM     = 8'hA5;
  const static bit [I2C_DATA_WIDTH-1:0] OTP_CMD_PROG_BIT    = 8'h32;

  const static bit [I2C_DATA_WIDTH-1:0] WD_CTRL_WR_MASK     = 8'hFE;
  const static bit [I2C_DATA_WIDTH-1:0] OTP_STATUS_WR_MASK  = 8'hE0;
  const static bit [I2C_DATA_WIDTH-1:0] INT_CTRL_WR_MASK    = 8'h03;
  const static bit [I2C_DATA_WIDTH-1:0] SYS_CTRL_WR_MASK    = 8'hFF;

  static function automatic bit is_general_reg_addr(input bit [I2C_DATA_WIDTH-1:0] reg_addr);
    return (reg_addr inside {[GEN_REG0_ADDR:GEN_REG7_ADDR]});
  endfunction

  static function automatic bit is_trim_reg_addr(input bit [I2C_DATA_WIDTH-1:0] reg_addr);
    return (reg_addr inside {[TRIM_REG0_ADDR:TRIM_REGF_ADDR]});
  endfunction

  static function automatic bit is_indirect_readable_addr(input bit [I2C_DATA_WIDTH-1:0] reg_addr);
    return ((reg_addr < 8'h0D) || ((reg_addr > 8'h19) && (reg_addr < 8'h33)));
  endfunction

  static function automatic bit is_legal_write_addr(input bit [I2C_DATA_WIDTH-1:0] reg_addr);
    return (is_general_reg_addr(reg_addr)
            || (reg_addr == WD_CTRL_REG_ADDR)
            || (reg_addr == OTP_CMD_REG_ADDR)
            || (reg_addr == OTP_ADDR_REG_ADDR)
            || (reg_addr == OTP_STATUS_REG_ADDR)
            || (reg_addr == INT_CTRL_REG_ADDR)
            || is_trim_reg_addr(reg_addr)
            || (reg_addr == SYS_CTRL_REG_ADDR)
            || (reg_addr == I2C_READ_ADDR_ADDR)
            || (reg_addr == TEST_REG_ADDR));
  endfunction

  static function automatic bit [I2C_DATA_WIDTH-1:0] write_mask(input bit [I2C_DATA_WIDTH-1:0] reg_addr);
    case (reg_addr)
      WD_CTRL_REG_ADDR:    return WD_CTRL_WR_MASK;
      OTP_STATUS_REG_ADDR: return OTP_STATUS_WR_MASK;
      INT_CTRL_REG_ADDR:   return INT_CTRL_WR_MASK;
      SYS_CTRL_REG_ADDR:   return SYS_CTRL_WR_MASK;
      default:             return '1;
    endcase
  endfunction

  static function automatic bit [I2C_DATA_WIDTH-1:0] apply_write_policy(
    input bit [I2C_DATA_WIDTH-1:0] reg_addr,
    input bit [I2C_DATA_WIDTH-1:0] current_value,
    input bit [I2C_DATA_WIDTH-1:0] write_value
  );
    bit [I2C_DATA_WIDTH-1:0] mask;
    mask = write_mask(reg_addr);
    return ((current_value & ~mask) | (write_value & mask));
  endfunction

  //Constraints for the transaction variables:
  
  constraint slave_addr { addr == I2C_SLAVE_ADDRESS; }
  constraint reg_addr {
    if (op == I2C_WR) {
      data.size() >= 1;
      is_legal_write_addr(data[0]);
    }
  }
  constraint test_reg {
    if (op == I2C_WR && data.size() > 1 && data[0] == TEST_REG_ADDR) {
      data[1] inside { [GEN_REG0_ADDR : INT_CTRL_REG_ADDR], [TRIM_REG0_ADDR : I2C_READ_ADDR_ADDR] };
    }
  }
  constraint data_size_c {
    if (op == I2C_WR) data.size() == 2;
    else data.size() == 1;
  }

  constraint write_data_mask_c {
    if (op == I2C_WR && data.size() > 1) {
      (data[1] & ~write_mask(data[0])) == '0;
    }
  }

  // pragma uvmf custom class_item_additional begin
  bit reg_addr_valid;
  bit [I2C_DATA_WIDTH-1:0] reg_addr_dbg;
  // pragma uvmf custom class_item_additional end

  // ****************************************************************************
  // FUNCTION : new()
  // This function is the standard SystemVerilog constructor.
  //
  function new( string name = "" );
    super.new( name );
    reg_addr_valid = 1'b0;
    reg_addr_dbg = '0;
  endfunction

  // ****************************************************************************
  // FUNCTION: convert2string()
  // This function converts all variables in this class to a single string for 
  // logfile reporting.
  //
  virtual function string convert2string();
    // pragma uvmf custom convert2string begin
    // UVMF_CHANGE_ME : Customize format if desired.
    return $sformatf("addr:0x%x data:%p op:%s reg_addr:%s",
                     addr,
                     data,
                     op.name(),
                     reg_addr_valid ? $sformatf("0x%0x", reg_addr_dbg) : "n/a");
    // pragma uvmf custom convert2string end
  endfunction

  //*******************************************************************
  // FUNCTION: do_print()
  // This function is automatically called when the .print() function
  // is called on this class.
  //
  virtual function void do_print(uvm_printer printer);
    // pragma uvmf custom do_print begin
    // UVMF_CHANGE_ME : Current contents of do_print allows for the use of UVM 1.1d, 1.2 or P1800.2.
    // Update based on your own printing preference according to your preferred UVM version
    $display(convert2string());
    // pragma uvmf custom do_print end
  endfunction

  //*******************************************************************
  // FUNCTION: do_compare()
  // This function is automatically called when the .compare() function
  // is called on this class.
  //
  virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer);
    i2c_transaction #(
        .I2C_ADDR_WIDTH(I2C_ADDR_WIDTH),
        .I2C_DATA_WIDTH(I2C_DATA_WIDTH),
        .I2C_SLAVE_ADDRESS(I2C_SLAVE_ADDRESS)
        )
 RHS;
    if (!$cast(RHS,rhs)) return 0;
    // pragma uvmf custom do_compare begin
    // UVMF_CHANGE_ME : Eliminate comparison of variables not to be used for compare
    return (super.do_compare(rhs,comparer)
            &&(this.addr == RHS.addr)
            &&(this.data == RHS.data)
            &&(this.op == RHS.op)
            );
    // pragma uvmf custom do_compare end
  endfunction

  //*******************************************************************
  // FUNCTION: do_copy()
  // This function is automatically called when the .copy() function
  // is called on this class.
  //
  virtual function void do_copy (uvm_object rhs);
    i2c_transaction #(
        .I2C_ADDR_WIDTH(I2C_ADDR_WIDTH),
        .I2C_DATA_WIDTH(I2C_DATA_WIDTH),
        .I2C_SLAVE_ADDRESS(I2C_SLAVE_ADDRESS)
        )
 RHS;
    if(!$cast(RHS,rhs))begin
      `uvm_fatal("CAST","Transaction cast in do_copy() failed!")
    end
    // pragma uvmf custom do_copy begin
    super.do_copy(rhs);
    this.addr = RHS.addr;
    this.data = RHS.data;
    this.op = RHS.op;
    this.reg_addr_valid = RHS.reg_addr_valid;
    this.reg_addr_dbg = RHS.reg_addr_dbg;
    // pragma uvmf custom do_copy end
  endfunction

  // ****************************************************************************
  // FUNCTION: add_to_wave()
  // This function is used to display variables in this class in the waveform 
  // viewer.  The start_time and end_time variables must be set before this 
  // function is called.  If the start_time and end_time variables are not set
  // the transaction will be hidden at 0ns on the waveform display.
  // 
  virtual function void add_to_wave(int transaction_viewing_stream_h);
    `ifdef QUESTA
    if (transaction_view_h == 0) begin
      transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"i2c_transaction",start_time);
    end
    super.add_to_wave(transaction_view_h);
    // pragma uvmf custom add_to_wave begin
    // UVMF_CHANGE_ME : Color can be applied to transaction entries based on content, example below
    // case()
    //   1 : $add_color(transaction_view_h,"red");
    //   default : $add_color(transaction_view_h,"grey");
    // endcase
    // UVMF_CHANGE_ME : Eliminate transaction variables not wanted in transaction viewing in the waveform viewer
    $add_attribute(transaction_view_h,addr,"addr");
    $add_attribute(transaction_view_h,data,"data");
    $add_attribute(transaction_view_h,op,"op");
    $add_attribute(transaction_view_h,reg_addr_valid,"reg_addr_valid");
    $add_attribute(transaction_view_h,reg_addr_dbg,"reg_addr");
    // pragma uvmf custom add_to_wave end
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
    `endif // QUESTA
  endfunction

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end
