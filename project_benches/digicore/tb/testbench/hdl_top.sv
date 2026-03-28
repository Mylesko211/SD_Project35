//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
`timescale 1ns / 1ps

// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------                     
//               
// Description: This top level module instantiates all synthesizable
//    static content.  This and tb_top.sv are the two top level modules
//    of the simulation.  
//
//    This module instantiates the following:
//        DUT: The Design Under Test
//        Interfaces:  Signal bundles that contain signals connected to DUT
//        Driver BFM's: BFM's that actively drive interface signals
//        Monitor BFM's: BFM's that passively monitor interface signals
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
//

module hdl_top#(DVDD_STARTUP_TIME = 23us, PORZ_STARTUP_TIME = 120us, CLK_GD_I_STARTUP_TIME = 100us);

import digicore_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;

// pragma uvmf custom clock_generator begin
  bit clk;
  // Instantiate a clk driver 
  initial begin
    clk = 0;
    #9ns;
    forever begin
      clk = ~clk;
      #5ns;
    end
  end
// pragma uvmf custom clock_generator end

// pragma uvmf custom reset_generator begin
  bit rst;
  // Instantiate a rst driver
  initial begin
    rst = 0; 
    #250ns;
    rst =  1; 
  end
// pragma uvmf custom reset_generator end

  // pragma uvmf custom module_item_additional begin
  // Instantiate a DVDD driver
    bit dvdd, porz, clk_gd_i;
    logic trim_done, otp_cs_o, otp_prog_o, otp_read_o, otp_en_prog_vpp_o, otp_en_read_vpp_o;
    logic [3:0] otp_adr_o;
    logic [7:0] otp_do_i, otp_din_o;
  initial begin
    dvdd = 0; 
    #DVDD_STARTUP_TIME;
    dvdd =  1; 
  end
  // Instantiate a CLK_GD_I driver
  initial begin
    clk_gd_i = 0; 
    #DVDD_STARTUP_TIME;
    #PORZ_STARTUP_TIME;
    #CLK_GD_I_STARTUP_TIME;
    clk_gd_i =  1; 
  end
  // Instantiate a PORZ driver
  initial begin
    porz = 0; 
    #DVDD_STARTUP_TIME;
    #PORZ_STARTUP_TIME;
    porz =  1; 
  end
  // pragma uvmf custom module_item_additional end

  // Instantiate the signal bundle, monitor bfm and driver bfm for each interface.
  // The signal bundle, _if, contains signals to be connected to the DUT.
  // The monitor, monitor_bfm, observes the bus, _if, and captures transactions.
  // The driver, driver_bfm, drives transactions onto the bus, _if.
  i2c_if #(
        .I2C_ADDR_WIDTH(7),
        .I2C_DATA_WIDTH(8),
        .I2C_SLAVE_ADDRESS(8'h22)
        )
 i2c_a_bus(
     // pragma uvmf custom i2c_a_bus_connections begin
     .scl(clk), .reset_n(rst), .sda()
     // pragma uvmf custom i2c_a_bus_connections end
     );
  i2c_monitor_bfm #(
        .I2C_ADDR_WIDTH(7),
        .I2C_DATA_WIDTH(8),
        .I2C_SLAVE_ADDRESS(8'h22)
        )
 i2c_a_mon_bfm(i2c_a_bus);
  i2c_driver_bfm #(
        .I2C_ADDR_WIDTH(7),
        .I2C_DATA_WIDTH(8),
        .I2C_SLAVE_ADDRESS(8'h22)
        )
 i2c_a_drv_bfm(i2c_a_bus);

  // pragma uvmf custom dut_instantiation begin
  // UVMF_CHANGE_ME : Add DUT and connect to signals in _bus interfaces listed above
  // Instantiate your DUT here
  // These DUT's instantiated to show verilog and vhdl instantiation
  digitop         dut_verilog(   .clk(clk), 
                                 .rst(rst),  
                                 .DVDD(dvdd),
                                 .CLK_GD_I(clk_gd_i),
                                 .PORZ(porz),
                                 .trim_done(trim_done),
                                 .otp_do_i(otp_do_i),
                                 .otp_cs_o(otp_cs_o),
                                 .otp_prog_o(otp_prog_o),
                                 .otp_read_o(otp_read_o),
                                 .otp_en_prog_vpp_o(otp_en_prog_vpp_o),
                                 .otp_en_read_vpp_o(otp_en_read_vpp_o),
                                 .otp_adr_o(otp_adr_o),
                                 .otp_din_o(otp_din_o),
                                 .i2c_scl(i2c_a_bus.scl),
                                 .i2c_sda(i2c_a_bus.sda)
                                 );
  vhdl_dut            dut_vhdl   (   .clk(clk), .rst(rst), .in_signal(verilog_to_vhdl_signal), .out_signal(vhdl_to_verilog_signal));

  otp_model          otp_model_inst ( .otp_cs_i(otp_cs_o),
                                 .otp_prog_i(otp_prog_o),
                                 .otp_read_i(otp_read_o),
                                 .otp_en_prog_vpp_i(otp_en_prog_vpp_o),
                                 .otp_en_read_vpp_i(otp_en_read_vpp_o),
                                 .otp_adr_i(otp_adr_o),
                                 .otp_din_i(otp_din_o),
                                 .otp_do_o(otp_do_i)
                                 );

  // pragma uvmf custom dut_instantiation end

  initial begin      import uvm_pkg::uvm_config_db;
    // The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
    // They are placed into the uvm_config_db using the string names defined in the parameters package.
    // The string names are passed to the agent configurations by test_top through the top level configuration.
    // They are retrieved by the agents configuration class for use by the agent.
    #300us;
    uvm_config_db #( virtual i2c_monitor_bfm #(
        .I2C_ADDR_WIDTH(7),
        .I2C_DATA_WIDTH(8),
        .I2C_SLAVE_ADDRESS(8'h22)
        )
 )::set( null , UVMF_VIRTUAL_INTERFACES , i2c_a_BFM , i2c_a_mon_bfm ); 
    uvm_config_db #( virtual i2c_driver_bfm #(
        .I2C_ADDR_WIDTH(7),
        .I2C_DATA_WIDTH(8),
        .I2C_SLAVE_ADDRESS(8'h22)
        )
 )::set( null , UVMF_VIRTUAL_INTERFACES , i2c_a_BFM , i2c_a_drv_bfm  );
  end

endmodule

// pragma uvmf custom external begin
// pragma uvmf custom external end

