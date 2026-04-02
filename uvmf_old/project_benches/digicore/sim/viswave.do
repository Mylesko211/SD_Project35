 

onerror resume
wave tags F0
wave update off

wave spacer -backgroundcolor Salmon { i2c_a }
wave add uvm_test_top.environment.i2c_a.i2c_a_monitor.txn_stream -radix string -tag F0
wave group i2c_a_bus
wave add -group i2c_a_bus hdl_top.i2c_a_bus.* -radix hexadecimal -tag F0
wave group i2c_a_bus -collapse
wave insertion [expr [wave index insertpoint] +1]



wave update on
WaveSetStreamView

