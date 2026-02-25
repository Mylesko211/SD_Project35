
module otp_ctrl (

  // ------- System Signals -------
  input clk_i,
  input reset_n,
  
  // ------- Trim Signals -------
  input trim_enable,
  output logic trim_done,

  // ------- Reg Map Signals -------
  input cmd_valid,
  input [6:0] reg_addr,
  input [7:0] reg_cmd,
  input [7:0] reg_data,

  output logic reg_addr_counter,
  output logic otp_ready,
  output logic otp_data_valid,
  output logic [127:0] otp_data,
  output logic [4:0] otp_status,

  // ------- OTP Signals -------
  input [7:0] otp_do_i,

  output logic otp_cs_o,
  output logic otp_prog_o,
  output logic otp_read_o,
  output logic otp_en_prog_vpp_o,
  output logic otp_en_read_vpp_o,
  output logic [3:0] otp_adr_o,
  output logic [7:0] otp_din_o

);

  typedef enum bit[2:0] {
    IDLE 		= 'd0,
    READY 		= 'd1,
    RELOAD		= 'd2,
    PROGRAM 	= 'd3,
    PROG_BIT 	= 'd4,
  	STATUS		= 'd5, // idk yet
    INVALID		= 'd6,
    READ        = 'd7
  } states;
    
  states ctrl_state;
  
  //bit reload_state;
  
  // assign reload_state = (reg_cmd == 
  bit reload_finish = 'd0;
  bit program_finish = 'd0;
  bit [4:0] addr_counter = 'd0;
  
  assign otp_prog_o = clk_i && otp_en_prog_vpp_o;
    
  always@(posedge clk_i or negedge reset_n) begin
    
    if (!reset_n) begin
		ctrl_state <= IDLE;
		addr_counter <= 'd0;
		reg_addr_counter <= 'd0;
		reload_finish <= 'd0;
		otp_cs_o <= 'd0;
		//otp_prog_o <= 'd0;
		otp_read_o <= 'd0;
		otp_en_prog_vpp_o <= 'd0;
		otp_en_read_vpp_o <= 'd0;
		otp_adr_o <= 'd0;
		otp_din_o <= 'd0;
		otp_ready <= 'd0;
		otp_data_valid <= 'd0;
		otp_data[7:0] <= 'd0;
		otp_status[4:0] <= 'd0;
      
    end else begin
      
      case (ctrl_state)
        
      	IDLE		: ctrl_state <= READY;
        
        READY		: begin
		  addr_counter <= 'd0; // reset counter
		  reg_addr_counter <= 'd0;
          otp_cs_o <= 'd0; // reset all outputs
          //otp_prog_o <= 'd0;
          otp_read_o <= 'd0;
          otp_en_prog_vpp_o <= 'd0;
          otp_en_read_vpp_o <= 'd0;
          otp_adr_o <= 'd0;
          otp_din_o <= 'd0;
          otp_ready <= 'd1; // otp ctrl ready
          otp_data <= 'd0;
          otp_data_valid <= 'd0;
          otp_status <= 5'b00000;
          trim_done <= 'd0;
          if (trim_enable) begin
              ctrl_state <= READ;
          end
          else if (cmd_valid) begin
			case (reg_cmd)
			  8'h5A: ctrl_state <= RELOAD;
			  8'hA5: ctrl_state <= PROGRAM;
			  8'h32: ctrl_state <= PROG_BIT;
			  default: otp_status <= 5'b01000; // invalid command
			endcase
          end
        end
        
        READ        : begin
		  otp_ready <= 'd0;
          otp_cs_o <= 'd1;
          otp_en_read_vpp_o <= 'd1;
          otp_read_o <= 'd1;
          otp_adr_o <= addr_counter;
          otp_data <= {otp_do_i, otp_data[127:8]};
          if (addr_counter >= 'd16) begin // takes one cycle to retrieve data from OTP 128 bit
            otp_data_valid <= 'd1;
            trim_done <= 'd1;
            reload_finish <= 'd1;
            otp_status <= 5'b00010;
            ctrl_state <= READY;
          end else
            addr_counter <= addr_counter + 1;
        end
        
        RELOAD		: begin
		  otp_ready <= 'd0;
          otp_cs_o <= 'd1;
          otp_en_read_vpp_o <= 'd1;
          otp_read_o <= 'd1;
          otp_adr_o <= addr_counter;
          otp_data <= {otp_do_i, otp_data[127:8]};
          if (addr_counter >= 'd16) begin // takes one cycle to retrieve data from OTP 128 bit
            otp_data_valid <= 'd1;
            reload_finish <= 'd1;
            otp_status <= 5'b00010;
            ctrl_state <= READY;
          end else
            addr_counter <= addr_counter + 1;
        end
        
        PROGRAM		: begin 
		  otp_ready <= 'd0;
          otp_en_prog_vpp_o <= 'd1;
          otp_cs_o <= 'd1;
          otp_adr_o <= addr_counter;
		  reg_addr_counter <= addr_counter;
          otp_din_o <= reg_data;		// make Myles send data
          if (addr_counter >= 'd15) begin
            program_finish <= 'd1;
            otp_status <= 5'b10001;
            ctrl_state <= READY;
          end else
            addr_counter <= addr_counter + 1;
        end

        PROG_BIT	: begin
		  otp_ready <= 'd0;
          otp_cs_o <= 'd1;
          otp_en_prog_vpp_o <= 'd1;
          otp_adr_o <= reg_addr >> 3;
          otp_din_o <= reg_data;
          otp_status <= 5'b00001; 
          ctrl_state <= READY;
        end
        
        default 	: ctrl_state <= READY;
        
      endcase
    end
  end
  
    
  
endmodule