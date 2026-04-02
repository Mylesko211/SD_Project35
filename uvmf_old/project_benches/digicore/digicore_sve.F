
// UVM
+incdir+${UVM_HOME}/src
${UVM_HOME}/src/uvm_pkg.sv

// Common UVMF files
-f ${UVMF_HOME}/common/common_sve.f

// BFM Files
-F ${UVMF_VIP_LIBRARY_HOME}/interface_packages/i2c_pkg/i2c_pkg_sve.F

// Environment Files
-F ${UVMF_VIP_LIBRARY_HOME}/environment_packages/digitop_env_pkg/digitop_env_pkg_sve.F

// Bench Files
+incdir+./tb/tests
./tb/tests/digicore_tests_pkg.sv

+incdir+./tb/sequences
./tb/sequences/digicore_sequences_pkg.sv

+incdir+./tb/parameters
./tb/parameters/digicore_parameters_pkg.sv

./tb/testbench/hdl_top.sv
./tb/testbench/hvl_top.sv

