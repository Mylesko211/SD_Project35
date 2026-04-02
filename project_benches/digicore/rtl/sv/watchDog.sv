`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2025 01:12:45 AM
// Design Name: 
// Module Name: watchDog
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

// params
parameter
    WD_IDLE = 8'h00,
    SET_LIMIT_TIME0_ADD = 8'h11,
    SET_LIMIT_TIME1_ADD = 8'h12,
    SET_LIMIT_TIME2_ADD = 8'h13,
    SET_LIMIT_TIME3_ADD = 8'h14,
    SET_LIMIT_TIME0_SUB = 8'h21,
    SET_LIMIT_TIME1_SUB = 8'h22,
    SET_LIMIT_TIME2_SUB = 8'h23,
    SET_LIMIT_TIME3_SUB = 8'h24,
    ADDING = 8'h15,
    SUBTRACTING = 8'h25,
    TIMEOUT = 8'hFF;

// top module
module watchDog #(parameter real CYCLES_PS = 16000000, parameter COUNTER_WIDTH = 32, parameter real TIME0=0.2, parameter real TIME1=0.5, parameter real TIME2=1, parameter real TIME3=10)(
    input logic clock,
    input logic reset_n,
    input logic [7:0] WD_ctrl_reg,

    output logic wd_timeout
    );
   
    logic [7:0] state;
    // Instantiate datapath and controller
    watchDog_datapath wd_dp_inst (
        .clock(clock),
        .reset_n(reset_n),
        .state(state),
        .WD_reg(WD_ctrl_reg),

        .wd_timeout(wd_timeout)
    );

    watchDog_controller wd_ctrl_inst (
        .clock(clock),
        .reset_n(reset_n),
        .WD_reg(WD_ctrl_reg),
        .wd_timeout(wd_timeout),

        .state(state)
    );


endmodule

module watchDog_datapath#(parameter real CYCLES_PS = 16000000, parameter COUNTER_WIDTH = 32, parameter real TIME0 = 0.2, parameter real TIME1 = 0.5, parameter real TIME2 = 1, parameter real TIME3 = 10)(
    input logic clock,
    input logic reset_n,
    input logic [7:0] state,
    input logic [7:0] WD_reg,

    output logic wd_timeout
);

reg [COUNTER_WIDTH-1:0] counter;
reg [COUNTER_WIDTH-1:0] limit;

localparam
    COUNT0 = TIME0 * CYCLES_PS - 1,
    COUNT1 = TIME1 * CYCLES_PS - 1,
    COUNT2 = TIME2 * CYCLES_PS - 1,
    COUNT3 = TIME3 * CYCLES_PS - 1;

    always_ff@(posedge clock) begin
        if (!reset_n || WD_reg[2]) begin
            counter <= 0;
            limit <= 0;
        end
        else begin
            case (state)
                SET_LIMIT_TIME0_ADD: begin
                    counter <= 0;
                    limit <= COUNT0;
                end
                SET_LIMIT_TIME1_ADD: begin
                    counter <= 0;
                    limit <= COUNT1;
                end
                SET_LIMIT_TIME2_ADD: begin
                    counter <= 0;
                    limit <= COUNT2;
                end
                SET_LIMIT_TIME3_ADD: begin
                    counter <= 0;
                    limit <= COUNT3;
                end
                SET_LIMIT_TIME0_SUB: begin
                    counter <= COUNT0;
                    limit <= 0;
                end
                SET_LIMIT_TIME1_SUB: begin
                    counter <= COUNT1;
                    limit <= 0;
                end
                SET_LIMIT_TIME2_SUB: begin
                    counter <= COUNT2;
                    limit <= 0;
                end
                SET_LIMIT_TIME3_SUB: begin
                    counter <= COUNT3;
                    limit <= 0;
                end
                ADDING: begin
                    if (counter < limit) counter <= counter + 1;
                end
                SUBTRACTING: begin
                    if (counter > limit) counter <= counter - 1;
                end
                default: begin
                    counter <= counter;
                    limit <= limit;
                end
            endcase
        end
    end

assign wd_timeout = ((state == ADDING) | (state == SUBTRACTING)) & (counter == limit);

endmodule

module watchDog_controller(
    input logic clock,
    input logic reset_n,
    input logic [7:0] WD_reg,
    input logic wd_timeout,

    output logic [7:0] state
);
    reg [7:0] current_state;

    always_ff@(posedge clock) begin
        if (!reset_n || WD_reg[2]) begin
            current_state <= WD_IDLE;
        end
        else begin
                casex ({WD_reg, current_state})
                    16'b0xxx_xxxx_xxxx_xxxx: current_state <= WD_IDLE;
                    16'b1xxx_xxxx_0001_xxxx: current_state <= ADDING;
                    16'b1xxx_xxxx_0010_xxxx: current_state <= SUBTRACTING;
                    16'hF000: current_state <= SET_LIMIT_TIME3_SUB;
                    16'hE000: current_state <= SET_LIMIT_TIME2_SUB;
                    16'hD000: current_state <= SET_LIMIT_TIME1_SUB;
                    16'hC000: current_state <= SET_LIMIT_TIME0_SUB;
                    16'hB000: current_state <= SET_LIMIT_TIME3_ADD;
                    16'hA000: current_state <= SET_LIMIT_TIME2_ADD;
                    16'h9000: current_state <= SET_LIMIT_TIME1_ADD;
                    16'h8000: current_state <= SET_LIMIT_TIME0_ADD;
                        
                    default: current_state <= WD_IDLE;
                endcase
            end
    end


    assign state = current_state;

endmodule