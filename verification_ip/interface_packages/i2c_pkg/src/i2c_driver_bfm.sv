//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
`timescale 1ns / 1ps
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the i2c signal driving.  It is
//     accessed by the uvm i2c driver through a virtual interface
//     handle in the i2c configuration.  It drives the singals passed
//     in through the port connection named bus of type i2c_if.
//
//     Input signals from the i2c_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within i2c_if based on INITIATOR/RESPONDER and/or
//     ARBITRATION/GRANT status.  
//
//     The output signal connections are as follows:
//        signal_o -> bus.signal
//
//                                                                                           
//      Interface functions and tasks used by UVM components:
//
//             configure:
//                   This function gets configuration attributes from the
//                   UVM driver to set any required BFM configuration
//                   variables such as 'initiator_responder'.                                       
//                                                                                           
//             initiate_and_get_response:
//                   This task is used to perform signaling activity for initiating
//                   a protocol transfer.  The task initiates the transfer, using
//                   input data from the initiator struct.  Then the task captures
//                   response data, placing the data into the response struct.
//                   The response struct is returned to the driver class.
//
//             respond_and_wait_for_next_transfer:
//                   This task is used to complete a current transfer as a responder
//                   and then wait for the initiator to start the next transfer.
//                   The task uses data in the responder struct to drive protocol
//                   signals to complete the transfer.  The task then waits for 
//                   the next transfer.  Once the next transfer begins, data from
//                   the initiator is placed into the initiator struct and sent
//                   to the responder sequence for processing to determine 
//                   what data to respond with.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

// Force recompile
import uvmf_base_pkg_hdl::*;
import i2c_pkg_hdl::*;
import i2c_pkg::*;


interface i2c_driver_bfm #(
  int I2C_ADDR_WIDTH = 7,
  int I2C_DATA_WIDTH = 8,
  int I2C_SLAVE_ADDRESS = 8'h22
  )

  (i2c_if bus);

`ifndef XRTL
// This code is to aid in debugging parameter mismatches between the BFM and its corresponding agent.
// Enable this debug by setting UVM_VERBOSITY to UVM_DEBUG
// Setting UVM_VERBOSITY to UVM_DEBUG causes all BFM's and all agents to display their parameter settings.
// All of the messages from this feature have a UVM messaging id value of "CFG"
// The transcript or run.log can be parsed to ensure BFM parameter settings match its corresponding agents parameter settings.
import uvm_pkg::*;
`include "uvm_macros.svh"
initial begin : bfm_vs_agent_parameter_debug
  `uvm_info("CFG", 
      $psprintf("The BFM at '%m' has the following parameters: I2C_ADDR_WIDTH=%x I2C_DATA_WIDTH=%x I2C_SLAVE_ADDRESS=%x ", I2C_ADDR_WIDTH,I2C_DATA_WIDTH,I2C_SLAVE_ADDRESS),
      UVM_DEBUG)
end
`endif

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase
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
  tri scl_i;
  tri reset_n_i;

  // Signal list (all signals are capable of being inputs and outputs for the sake
  // of supporting both INITIATOR and RESPONDER mode operation. Expectation is that 
  // directionality in the config file was from the point-of-view of the INITIATOR

  // INITIATOR mode input signals

  // INITIATOR mode output signals

  // Bi-directional signals
  tri  sda_i;
  reg  sda_o = 'b0;
  

  assign scl_i = bus.scl;
  assign reset_n_i = bus.reset_n;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)

  assign     sda_i = bus.sda;

  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.
  assign bus.sda = sda_o;

  // Proxy handle to UVM driver
  i2c_pkg::i2c_driver #(
    .I2C_ADDR_WIDTH(I2C_ADDR_WIDTH),
    .I2C_DATA_WIDTH(I2C_DATA_WIDTH),
    .I2C_SLAVE_ADDRESS(I2C_SLAVE_ADDRESS)
    )
  proxy;


  // ****************************************************************************
// pragma uvmf custom reset_condition_and_response begin
  // Always block used to return signals to reset value upon assertion of reset
  always @( negedge reset_n_i )
     begin
       // RESPONDER mode output signals
       // INITIATOR mode output signals
       // Bi-directional signals
       sda_o <= 'b0;
 
     end    
// pragma uvmf custom reset_condition_and_response end

  // pragma uvmf custom interface_item_additional begin
  // pragma uvmf custom interface_item_additional end

  //******************************************************************
  // The configure() function is used to pass agent configuration
  // variables to the driver BFM.  It is called by the driver within
  // the agent at the beginning of the simulation.  It may be called 
  // during the simulation if agent configuration variables are updated
  // and the driver BFM needs to be aware of the new configuration 
  // variables.
  //

  function void configure(i2c_configuration 
                         #(
                         I2C_ADDR_WIDTH,
                         I2C_DATA_WIDTH,
                         I2C_SLAVE_ADDRESS
                         )

                         i2c_configuration_arg
                         );  
    initiator_responder = i2c_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction                                                                             

// pragma uvmf custom initiate_and_get_response begin
// ****************************************************************************
// UVMF_CHANGE_ME
// This task is used by an initator.  The task first initiates a transfer then
// waits for the responder to complete the transfer.
    task initiate_and_get_response( i2c_transaction 
                                  #(
                                  I2C_ADDR_WIDTH,
                                  I2C_DATA_WIDTH,
                                  I2C_SLAVE_ADDRESS
                                  )

                                  initiator_trans  
                                  );

       // 
       // Variables within the initiator_trans:
       //   bit [I2C_ADDR_WIDTH-1:0] addr ;
       //   bit [I2C_DATA_WIDTH-1:0] data [];
       //   i2c_op_t op ;
       //
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge scl_i);
       //    
       //    How to assign a initiator_trans variable, named xyz, from a signal.   
       //    All available initiator input and inout signals listed.
       //    Initiator input signals:
       //    Initiator inout signals:
       //      initiator_trans.xyz = sda_i;  //     
       //    How to assign a signal, named xyz, from a initiator_trans varaiable.   
       //    All available initiator output and inout signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       //    Initiator output signals:
       //    Initiator inout signals:
       //      sda_o <= initiator_trans.xyz;  //     
    // Initiate a transfer using the data received.
    //@(posedge scl_i);
    //@(posedge scl_i);
    // Wait for the responder to complete the transfer then place the responder data into 
    // initiator_trans.
    //@(posedge scl_i);
    //@(posedge scl_i);


  /////////////////////////////////////////////////////
  // Myles Edits
  ////////////////////////////////////////////////////
  logic [7:0] response_data;
  #300us;
  read_indirect(.i2c_slave_addr(I2C_SLAVE_ADDRESS), .read_addr(I2C_READ_ADDR), .target_reg(GEN_REG0), .data_byte(response_data));
  read_indirect(.i2c_slave_addr(I2C_SLAVE_ADDRESS), .read_addr(I2C_READ_ADDR), .target_reg(GEN_REG1), .data_byte(response_data));
  read_indirect(.i2c_slave_addr(I2C_SLAVE_ADDRESS), .read_addr(I2C_READ_ADDR), .target_reg(GEN_REG2), .data_byte(response_data));
  read_indirect(.i2c_slave_addr(I2C_SLAVE_ADDRESS), .read_addr(I2C_READ_ADDR), .target_reg(GEN_REG3), .data_byte(response_data));
  read_indirect(.i2c_slave_addr(I2C_SLAVE_ADDRESS), .read_addr(I2C_READ_ADDR), .target_reg(GEN_REG4), .data_byte(response_data));
  read_indirect(.i2c_slave_addr(I2C_SLAVE_ADDRESS), .read_addr(I2C_READ_ADDR), .target_reg(GEN_REG5), .data_byte(response_data));
  read_indirect(.i2c_slave_addr(I2C_SLAVE_ADDRESS), .read_addr(I2C_READ_ADDR), .target_reg(GEN_REG6), .data_byte(response_data));
  read_indirect(.i2c_slave_addr(I2C_SLAVE_ADDRESS), .read_addr(I2C_READ_ADDR), .target_reg(GEN_REG7), .data_byte(response_data));
  endtask        
// pragma uvmf custom initiate_and_get_response end

// pragma uvmf custom respond_and_wait_for_next_transfer begin
// ****************************************************************************
// The first_transfer variable is used to prevent completing a transfer in the 
// first call to this task.  For the first call to this task, there is not
// current transfer to complete.
bit first_transfer=1;

// UVMF_CHANGE_ME
// This task is used by a responder.  The task first completes the current 
// transfer in progress then waits for the initiator to start the next transfer.
  
  task respond_and_wait_for_next_transfer( i2c_transaction 
                                         #(
                                         I2C_ADDR_WIDTH,
                                         I2C_DATA_WIDTH,
                                         I2C_SLAVE_ADDRESS
                                         )

                                         responder_trans  
                                         );     
  // Variables within the responder_trans:
  //   bit [I2C_ADDR_WIDTH-1:0] addr ;
  //   bit [I2C_DATA_WIDTH-1:0] data [];
  //   i2c_op_t op ;
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge scl_i);
       //    
       //    How to assign a responder_trans member, named xyz, from a signal.   
       //    All available responder input and inout signals listed.
       //    Responder input signals
       //    Responder inout signals
       //      responder_trans.xyz = sda_i;  //     
       //    How to assign a signal from a responder_trans member named xyz.   
       //    All available responder output and inout signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       ///   Responder output signals
       //    Responder inout signals
       //      sda_o <= responder_trans.xyz;  //     
    

  @(posedge scl_i);
  if (!first_transfer) begin
    // Perform transfer response here.   
    // Reply using data recieved in the responder_trans.
    @(posedge scl_i);
    // Reply using data recieved in the transaction handle.
    @(posedge scl_i);
  end
    // Wait for next transfer then gather info from intiator about the transfer.
    // Place the data into the responder_trans handle.
    @(posedge scl_i);
    @(posedge scl_i);
    first_transfer = 0;
  endtask
//////////////////////////////////////////////////////////////////////////////////
// Start of Myles Edits:
//////////////////////////////////////////////////////////////////////////////////
  
  // TASKS and FUNCTIONS
 
  // I2C Master Tasks
  task wait_scl_low();
    while (scl_i !== 1'b0) #1;
  endtask
  
  task wait_scl_high();
    while (scl_i !== 1'b1) #1;
  endtask
  
  task master_send_bit(input logic bitval);
    begin
      wait_scl_low();
      sda_o = (bitval == 1'b0);
      wait_scl_high();
      wait_scl_low();
    end
  endtask
  
  task master_read_bit(output logic bitval);
    begin
      wait_scl_low();
      sda_o = 1'b0;
      wait_scl_high();
      bitval = scl_i;
      wait_scl_low();
    end
  endtask
  
  task i2c_start();
    begin
      sda_o = 1'b0;
      wait_scl_high();
      #1 sda_o = 1'b1;
      #1 wait_scl_low();
    end
  endtask
  
  task i2c_stop();
    begin
      wait_scl_low();
      sda_o = 1'b1;
      wait_scl_high();
      #1 sda_o = 1'b0;
      #1;
    end
  endtask
  
  task master_send_byte (input [7:0] data_byte);
    integer i;
    for (i = I2C_DATA_WIDTH-1; i >= 0; i--) master_send_bit(data_byte[i]);
  endtask
  
  task master_read_byte (output [7:0] data_byte);
    integer i;
    logic b;
    begin
      for (i = I2C_DATA_WIDTH-1; i >= 0; i--) begin
        master_read_bit(b);
        data_byte[i] = b;
      end
    end
  endtask
  
  task master_read_ack(output logic ack_ok);
    logic b;
    begin
      master_read_bit(b);
      ack_ok = (b == 1'b0);
    end
  endtask
  
  task master_send_ack(input logic ack);
    master_send_bit(ack ? 1'b0 : 1'b1);
  endtask
  
  // Standard I2C write
  task write(input [6:0] i2c_slave_addr = 7'h22, input [7:0] reg_addr, input [7:0] data_byte);
    logic ack;
    begin
      i2c_start();
      master_send_byte({i2c_slave_addr, 1'b0});
      master_read_ack(ack);
      master_send_byte(reg_addr);
      master_read_ack(ack);
      master_send_byte(data_byte);
      master_read_ack(ack);
      i2c_stop();
    end
  endtask
  
  // Indirect read: Write target address to I2C_READ_ADDR, then read from I2C_READ_ADDR
  task read_indirect (input [6:0] i2c_slave_addr = 7'h22, input [7:0] read_addr, input [7:0] target_reg, output [7:0] data_byte);

    logic ack;
    begin
      // Step 1: Write the target register address to I2C_READ_ADDR
      i2c_start();
      master_send_byte({i2c_slave_addr, 1'b0});  // Write operation
      master_read_ack(ack);
      master_send_byte(read_addr); // Point to I2C_READ_ADDR register
      master_read_ack(ack);
      master_send_byte(target_reg);    // Write target address
      master_read_ack(ack);
      i2c_stop();
      
      i2c_start();                     // Repeated start
      master_send_byte({i2c_slave_addr, 1'b1});  // Read operation
      master_read_ack(ack);
      master_read_byte(data_byte);     // Read the data
      master_send_ack(1'b0);           // NACK to end read
      i2c_stop();
    end
  endtask
//////////////////////////////////////////////////////////////////////////////////
// End of Myles Edits
//////////////////////////////////////////////////////////////////////////////////

// pragma uvmf custom respond_and_wait_for_next_transfer end

 
endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

