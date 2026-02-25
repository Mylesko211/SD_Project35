onerror resume
wave tags  sim
wave update off
wave zoom range 0 98259000
wave spacer -backgroundcolor Salmon { i2c_a }
wave add uvm_test_top.environment.i2c_a.i2c_a_monitor.txn_stream -tag sim -radix string -expand -subitemconfig { unique_transaction_id {-radix hexadecimal} addr {-radix hexadecimal} data {-radix string} op {-radix string} }
wave group i2c_a_bus -backgroundcolor #004466
wave add -group i2c_a_bus hdl_top.i2c_a_bus.I2C_ADDR_WIDTH -tag sim -radix hexadecimal
wave add -group i2c_a_bus hdl_top.i2c_a_bus.I2C_DATA_WIDTH -tag sim -radix hexadecimal
wave add -group i2c_a_bus hdl_top.i2c_a_bus.I2C_SLAVE_ADDRESS -tag sim -radix hexadecimal
wave add -group i2c_a_bus hdl_top.i2c_a_bus.scl -tag sim -radix hexadecimal
wave add -group i2c_a_bus hdl_top.i2c_a_bus.reset_n -tag sim -radix hexadecimal
wave add -group i2c_a_bus hdl_top.i2c_a_bus.sda -tag sim -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave add hdl_top.dvdd -tag sim -radix hexadecimal
wave add hdl_top.porz -tag sim -radix hexadecimal -select
wave add hdl_top.clk_gd_i -tag sim -radix hexadecimal
wave update on
wave top 0
