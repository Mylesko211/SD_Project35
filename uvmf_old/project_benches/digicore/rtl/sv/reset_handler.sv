
`timescale 1ns / 1ps

module reset_handler(
    input logic reset,
    input logic WD_timeout,
    output logic system_reset
    );

    assign system_reset = reset & (~WD_timeout);
endmodule
