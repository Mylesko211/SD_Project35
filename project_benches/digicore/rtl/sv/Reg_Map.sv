`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2025 02:55:26 PM
// Design Name: 
// Module Name: Reg_Map
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module REG_MAP(
    input logic clock,
    input logic reset_n,

    // FSM
    input logic [3:0] state,
    output reg trim_valid,
    output logic trim_reload,

    output logic [7:0] test_out,
    output logic [7:0] sys_ctrl_reg,

    // OTP
    input logic [127:0] OTP_data,
    input logic otp_ready,
    input logic otp_data_valid,
    input logic [4:0] otp_status,
    input logic [6:0] otp_addr,

    output logic cmd_valid,
    output logic [6:0] reg_addr,
    output logic [7:0] reg_cmd,
    output logic [7:0] reg_data,

    // I2C_addr_reg
    input logic [7:0] I2C_addr,
    input logic I2C_op, // 1 for read, 0 for write
    input logic I2C_valid_in,
    input logic [7:0] I2C_write_data,
    output reg [7:0] I2C_read_data,
    output reg I2C_valid_out,

    // watchDog
    input logic wd_timeout,
    output logic [7:0] WD_reg

    //debug
    //output logic [7:0] mem_out [0:51]

);

// states
typedef enum bit [3:0] {
    DVDD_CHECK = 4'h0,
    PORZ_CHECK = 4'h1,
    CLK_GD_I_CHECK = 4'h2,
    READ_TRIM = 4'h3,
    I2C = 4'h4,
    VALID_KEY0 = 4'h5,
    VALID_KEY1 = 4'h6,
    TEST_MODE = 4'hF
} FSM_states;


// Reg Map Addrs
typedef enum bit[7:0] {
    GEN_REG0   = 8'h00, 
    GEN_REG1   = 8'h01,
    GEN_REG2   = 8'h02,
    GEN_REG3   = 8'h03,
    GEN_REG4   = 8'h04,
    GEN_REG5   = 8'h05,
    GEN_REG6   = 8'h06,
    GEN_REG7   = 8'h07,
    WD_CTRL_REG= 8'h08,
    OTP_CMD_REG= 8'h09,
    OTP_ADDR_REG=8'h0A,
    OTP_STATUS_REG=8'h0B,
    INT_CTRL_REG=8'h0C,
    // h'0E-h1F reserved
    TRIM_REG0  = 8'h20,
    TRIM_REG1  = 8'h21,
    TRIM_REG2  = 8'h22,
    TRIM_REG3  = 8'h23,
    TRIM_REG4  = 8'h24,
    TRIM_REG5  = 8'h25,
    TRIM_REG6  = 8'h26,
    TRIM_REG7  = 8'h27,
    TRIM_REG8  = 8'h28,
    TRIM_REG9  = 8'h29,
    TRIM_REGA  = 8'h2A,
    TRIM_REGB  = 8'h2B,
    TRIM_REGC  = 8'h2C,
    TRIM_REGD  = 8'h2D,
    TRIM_REGE  = 8'h2E,
    TRIM_REGF  = 8'h2F,
    SYS_CTRL_REG=8'h30,
    I2C_READ_ADDR = 8'h31,
    TEST_REG = 8'h32} reg_addresses;

logic [7:0] mem [0:51]; // 52 8-bit registers

// debug
//assign mem_out = mem;


always_ff@(posedge clock or negedge reset_n) begin
    if(!reset_n | mem[SYS_CTRL_REG][7] | (wd_timeout & (!mem[WD_CTRL_REG][3]))) begin
        // Reset all registers
        for (int i = 0; i < 50; i = i + 1) mem[i] <= 8'h00;
        mem[I2C_READ_ADDR] <= 8'hFF;
        mem[TEST_REG] <= 8'hFF;
    end else begin

        mem[OTP_STATUS_REG][4:0] <= otp_status; // update OTP status bits

        casex(state)

            READ_TRIM: begin
                if (otp_data_valid) begin
                    for(int i = 0; i < 15; i = i + 1) mem[TRIM_REG0 + i] <= OTP_data[i*8 +: 8];
                    mem[TRIM_REGF] <= {1'b1, OTP_data[126:120]}; // Indicate OTP locked

                    mem[OTP_CMD_REG] <= 8'h00; // clear OTP cmd reg (THIS IS IMPORTANT SO WE DONT GET STUCK IN READ_TRIM)
                end
            end

            // I2C States
            4'b01xx: begin

                mem[WD_CTRL_REG][0] <= wd_timeout; // WD timeout status bit

                if (I2C_valid_in & (I2C_op == 1'b0)) begin

                    if (I2C_addr == WD_CTRL_REG) mem[WD_CTRL_REG][7:1] <= I2C_write_data[7:1]; // WD reg write, bit 0 is read-only
                    else if (I2C_addr == OTP_STATUS_REG) mem[OTP_STATUS_REG][7:5] <= I2C_write_data[7:5]; // OTP status reg write, bits 4:0 are read-only
                    else if ((I2C_addr <= 8'h33 & I2C_addr >= 8'h30) | I2C_addr <= 8'h07 | I2C_addr == INT_CTRL_REG | I2C_addr == OTP_CMD_REG | I2C_addr == OTP_ADDR_REG) mem[I2C_addr] <= I2C_write_data;

                end

                if (otp_data_valid & mem[OTP_CMD_REG] == 8'h32) begin
                    mem[(TRIM_REG0 + mem[OTP_ADDR_REG] / 8 )][(mem[OTP_ADDR_REG] % 8)] <= OTP_data[0];
                end
            end

            // Test State
            4'b1xxx: begin // I2C, Test states
                if (I2C_valid_in & (I2C_op == 1'b0)) mem[I2C_addr] <= I2C_write_data;

                if (otp_data_valid & mem[OTP_CMD_REG] == 8'h32) begin
                    mem[(TRIM_REG0 + mem[OTP_ADDR_REG] / 8 )][(mem[OTP_ADDR_REG] % 8 )] <= OTP_data[0];
                end
            end


        endcase
    end
end

// FSM 
assign trim_valid = (state == READ_TRIM) & otp_data_valid;
assign trim_reload = cmd_valid & (reg_cmd == 8'h5A);
assign test_out = mem[TEST_REG];
assign sys_ctrl_reg = mem[SYS_CTRL_REG];

// OTP
assign cmd_valid = ((mem[OTP_CMD_REG] == 8'h5A) | (mem[OTP_CMD_REG] == 8'hA5) | (mem[OTP_CMD_REG] == 8'h32));
assign reg_addr = mem[OTP_ADDR_REG][6:0];
assign reg_cmd = mem[OTP_CMD_REG];
assign reg_data = mem[TRIM_REG0 + otp_addr];

// I2C read output
assign I2C_read_data = ((mem[I2C_READ_ADDR] < 8'h0D) | ((mem[I2C_READ_ADDR] > 8'h19) & (mem[I2C_READ_ADDR] < 8'h33))) ? mem[mem[I2C_READ_ADDR]] : 8'h00;
assign I2C_valid_out = ((mem[I2C_READ_ADDR] < 8'h0D) | ((mem[I2C_READ_ADDR] > 8'h19) & (mem[I2C_READ_ADDR] < 8'h33)));

// Watchdog register output
assign WD_reg = mem[8'h08];

endmodule
