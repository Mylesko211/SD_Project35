`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
`include "watchDog.sv"
`include "otp_ctrl.sv"
`include "Reg_Map_top.sv"
`include "I2C_Slave.sv"


module digitop (
    // System / clocking
    input  logic        clk,
    input logic        rst,
    
    // Analog inputs
    input  logic        DVDD,
    input  logic        CLK_GD_I,
    input  logic        PORZ,

    // Trim control interface
    output logic        trim_done,     

    // OTP 
    input  logic [7:0]  otp_do_i,          
    output logic        otp_cs_o,
    output logic        otp_prog_o,
    output logic        otp_read_o,
    output logic        otp_en_prog_vpp_o,
    output logic        otp_en_read_vpp_o,
    output logic [3:0]  otp_adr_o,
    output logic [7:0]  otp_din_o,
	
	// I2C
	input logic			i2c_scl,
	inout logic			i2c_sda
);
   
    // Reg-map -> OTP controller command bus
    logic        cmd_valid;
    logic [6:0]  reg_addr;
    logic [7:0]  reg_cmd;
    logic [7:0]  reg_data;

    logic trim_enable;

    // OTP controller -> REG_MAP_TOP status / data
    logic        	otp_ready;
    logic        	otp_data_valid;
    logic [127:0] 	otp_data;
    logic [4:0]  	otp_status;
    logic [6:0]     reg_addr_counter;
	
	// I2C module -> REG_MAP_TOP
	logic [7:0] i2c_reg_data;
	logic [7:0] i2c_reg_addr;
	logic       i2c_reg_valid;
	logic       i2c_reg_op;
	logic [7:0] reg_i2c_data;
	logic       reg_i2c_valid;

    // Reg-map -> Watchdog
    logic [7:0] WD_reg;	
    logic WD_flag;
/*
	// I2C Module
	i2c_follower_module i2c_slave_inst (
	  .rst_n       (rst),
	  .scl         (i2c_scl),
	  .sda         (i2c_sda),
	  .data_in     (reg_i2c_data),
	  .valid_in    (reg_i2c_valid),
	  .reg_addr_o  (i2c_reg_addr),
	  .op_o        (i2c_reg_op),
	  .data_out_o  (i2c_reg_data),
	  .valid_out_o (i2c_reg_valid)
	);
*/
    // REG_MAP_TOP, contains FSM and REG_MAP
    
    REG_MAP_TOP reg_map_top_inst (
        .clock          (clk),
        .reset_n        (rst),

        .trim_enable    (trim_enable),

        .OTP_data       (otp_data),
        .otp_ready      (otp_ready),
        .otp_data_valid (otp_data_valid),
        .otp_status     (otp_status),

        .cmd_valid      (cmd_valid),
        .reg_addr       (reg_addr),
        .reg_cmd        (reg_cmd),
        .reg_data       (reg_data),
        .otp_addr      (reg_addr_counter),

        .I2C_addr       (i2c_reg_addr),
        .I2C_op         (i2c_reg_op),
        .I2C_valid_in   (i2c_reg_valid),
        .I2C_write_data (i2c_reg_data),
        .I2C_read_data  (reg_i2c_data),
        .I2C_valid_out  (reg_i2c_valid),

        .DVDD           (DVDD),
        .PORZ           (PORZ),
        .CLK_GD_I       (CLK_GD_I),
		
        .WD_timeout		(WD_flag),
		.WD_reg			(WD_reg),

        .test_flag      (test_flag)
    );

    // Watchdog
    watchDog wd_inst (
        .clock(clk),
        .reset_n(rst),
        .WD_ctrl_reg(WD_reg),

        .wd_timeout(WD_flag)
    );


    //otp_ctrl
    otp_ctrl otp_ctrl_inst (
        .clk_i              (clk),
        .reset_n            (rst),

        .trim_enable        (trim_enable),
        .trim_done          (trim_done),

        .cmd_valid          (cmd_valid),
        .reg_addr           (reg_addr),
        .reg_cmd            (reg_cmd),
        .reg_data           (reg_data),
        .reg_addr_counter   (reg_addr_counter),

        .otp_ready          (otp_ready),
        .otp_data_valid     (otp_data_valid),
        .otp_data           (otp_data),
        .otp_status         (otp_status),

        .otp_do_i           (otp_do_i),

        .otp_cs_o           (otp_cs_o),
        .otp_prog_o         (otp_prog_o),
        .otp_read_o         (otp_read_o),
        .otp_en_prog_vpp_o  (otp_en_prog_vpp_o),
        .otp_en_read_vpp_o  (otp_en_read_vpp_o),
        .otp_adr_o          (otp_adr_o),
        .otp_din_o          (otp_din_o)
    );

    
endmodule