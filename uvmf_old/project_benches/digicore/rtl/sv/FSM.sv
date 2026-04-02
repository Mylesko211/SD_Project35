`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2025 03:30:01 PM
// Design Name: 
// Module Name: FSM
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


/* 
Main FSM module
*/

parameter
    DVDD_CHECK = 4'h0,
    PORZ_CHECK = 4'h1,
    CLK_GD_I_CHECK = 4'h2,
    READ_TRIM = 4'h3,
    I2C = 4'h4,
    VALID_KEY0 = 4'h5,
    VALID_KEY1 = 4'h6,
    TEST_MODE = 4'hF;

parameter
    TEST_KEY0 = 8'h09,
    TEST_KEY1 = 8'h01,
    TEST_KEY2 = 8'h09;

module FSM(
    input logic clock,
    input logic reset_n,
    input logic DVDD,
    input logic PORZ,
    input logic CLK_GD_I,
    input logic trim_valid,
    input logic trim_reload,

    input logic [7:0] test_reg,
    input logic [7:0] sys_ctrl_reg,
    input logic [7:0] WD_ctrl_reg,
    input logic wd_timeout,

    output logic test_flag,
    output logic trim_enable,
    output logic [3:0] state
);
    reg [3:0] current_state;

    always_ff @(posedge clock) begin
        if (!reset_n | sys_ctrl_reg[7] | (wd_timeout & (!WD_ctrl_reg[3]))) begin
            current_state <= DVDD_CHECK;
            trim_enable <= 1'b0;
        end else begin
            case (current_state)
                DVDD_CHECK: begin
                    if (DVDD) current_state <= PORZ_CHECK;
                    else current_state <= DVDD_CHECK;
                end
                PORZ_CHECK: begin
                    if (PORZ) current_state <= CLK_GD_I_CHECK;
                    else current_state <= PORZ_CHECK;
                end
                CLK_GD_I_CHECK: begin
                    if (CLK_GD_I) begin
                        current_state <= READ_TRIM;
                        trim_enable <= 1'b1;
                    end
                    else begin 
                        current_state <= CLK_GD_I_CHECK;
                        trim_enable <= 1'b0;
                    end
                end
                READ_TRIM: begin
                    if (trim_valid) begin 
                        current_state <= I2C;
                        trim_enable <= 1'b0;
                    end
                    else begin 
                        current_state <= READ_TRIM;
                        trim_enable <= 1'b1;
                    end
                end
                I2C: begin
                    if (test_reg == TEST_KEY0) current_state <= VALID_KEY0;
                    else if (trim_reload) current_state <= READ_TRIM; 
                    else current_state <= I2C;
                end
                VALID_KEY0: begin
                    if (test_reg == TEST_KEY1) current_state <= VALID_KEY1;
                    else if (test_reg == TEST_KEY0) current_state <= VALID_KEY0;
                    else current_state <= I2C;
                end
                VALID_KEY1: begin
                    if (test_reg == TEST_KEY2) current_state <= TEST_MODE;
                    else if (test_reg == TEST_KEY1) current_state <= VALID_KEY1;
                    else current_state <= I2C;
                end
                TEST_MODE: begin
                    if(test_reg != TEST_KEY2) current_state <= I2C;
                    else if (trim_reload) current_state <= READ_TRIM;
                    else current_state <= TEST_MODE;
                end
                default: begin
                    current_state <= DVDD_CHECK;
                end
            endcase
        end
    end


assign state = current_state;
assign test_flag = (current_state == TEST_MODE);

endmodule