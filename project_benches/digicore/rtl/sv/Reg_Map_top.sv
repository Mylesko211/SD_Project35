/* 
Register map top module
*/
`include "FSM.sv"
`include "Reg_Map.sv"

module REG_MAP_TOP(
    input logic clock,
    input logic reset_n,
    
    //global
    output logic trim_enable,

    // OTP interface signals
    input logic [127:0] OTP_data,
    input logic otp_ready,
    input logic otp_data_valid,
    input logic [4:0] otp_status,
    input logic [6:0] otp_addr,

    output logic cmd_valid,
    output logic [6:0] reg_addr,
    output logic [7:0] reg_cmd,
    output logic [7:0] reg_data,

    // I2C interface signals
    input logic [7:0] I2C_addr,
    input logic I2C_op, // 0 for read, 1 for write
    input logic I2C_valid_in,
    input logic [7:0] I2C_write_data,
    output logic [7:0] I2C_read_data,
    output logic I2C_valid_out,

    // Analog inputs
    input logic DVDD,
    input logic PORZ,
    input logic CLK_GD_I,

    // Watchdog interface
    input logic WD_timeout,
    output logic [7:0] WD_reg,

    // test flag
    output logic test_flag

    // debug
    //output logic [7:0] mem_out [0:51]
);

// FSM signals
logic [7:0] test_conn, sys_ctrl_reg;
logic [3:0] state;


// REG_MAP signals
logic trim_reload, trim_valid;

// Instantiate FSM and REG_MAP
FSM fsm_inst (
    // inputs
    .clock(clock),
    .reset_n(reset_n),
    .DVDD(DVDD),
    .PORZ(PORZ),
    .CLK_GD_I(CLK_GD_I),
    .trim_valid(trim_valid),
    .trim_reload(trim_reload),
    .test_reg(test_conn),
    .trim_enable(trim_enable),

    .sys_ctrl_reg(sys_ctrl_reg),
    .WD_ctrl_reg(WD_reg),
    .wd_timeout(WD_timeout),

    // outputs
    .test_flag(test_flag),
    .state(state)
);

REG_MAP reg_map_inst (
    .clock(clock),
    .reset_n(reset_n),

    .state(state),
    .trim_valid(trim_valid),
    .trim_reload(trim_reload),
    .test_out(test_conn),

    .sys_ctrl_reg(sys_ctrl_reg),

    .OTP_data(OTP_data),
    .otp_ready(otp_ready),
    .otp_data_valid(otp_data_valid),
    .otp_status(otp_status),
    .otp_addr(otp_addr),

    .cmd_valid(cmd_valid),
    .reg_addr(reg_addr),
    .reg_cmd(reg_cmd),
    .reg_data(reg_data),
    
    .I2C_addr(I2C_addr),
    .I2C_op(I2C_op),
    .I2C_valid_in(I2C_valid_in),
    .I2C_write_data(I2C_write_data),
    .I2C_read_data(I2C_read_data),
    .I2C_valid_out(I2C_valid_out),

    .wd_timeout(WD_timeout),
    .WD_reg(WD_reg)

    //.mem_out(mem_out) // debug
);

endmodule