`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



module otp_model (
    // Inputs
    input        otp_cs_i,            // chip select
    input        otp_prog_i,          // program strobe (pulse)
    input        otp_read_i,          // read enable
    input        otp_en_prog_vpp_i,   // enable program VPP
    input        otp_en_read_vpp_i,   // enable read VPP
    input  [3:0] otp_adr_i,           // 0..15 (byte address)
    input  [7:0] otp_din_i,           // 8-bit data for programming

    // Outputs
    output [7:0] otp_do_o             // 8-bit data out
);

    // 128-bit fuse array (16 x 8-bit)
    reg [127:0] otp_mem = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;

    // Program operation: only 0 -> 1 allowed
    always @(posedge otp_prog_i) begin
        if (otp_cs_i && otp_en_prog_vpp_i) begin
            otp_mem[otp_adr_i*8 +: 8] <= otp_mem[otp_adr_i*8 +: 8] | otp_din_i;
        end
    end

    // Read operation: combinational
    assign otp_do_o = (otp_cs_i && otp_read_i && otp_en_read_vpp_i) ?
                      otp_mem[otp_adr_i*8 +: 8] : 8'h00;

endmodule
