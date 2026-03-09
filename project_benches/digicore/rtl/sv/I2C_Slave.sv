
module i2c_follower_module #(
   parameter int SLAVE_ADDRESS = 'h22
)(
    input  logic        rst_n,
    input  logic        scl,
    inout  logic        sda,

    input  logic [7:0]  data_in,
    input  logic        valid_in,

    output logic [7:0]  reg_addr_o,
    output logic        op_o,
    output logic [7:0]  data_out_o,
    output logic        valid_out_o
);

  logic [6:0]   slave_addr;
  logic [3:0]   bit_count;
  logic         op;
  logic         sda_drive;
  logic         master_ack;
  logic         stop_detected;
  logic         start_detected;

  //----------------------------------------------------------
  // FSM states
  //----------------------------------------------------------
     typedef enum logic [3:0] {
        WAIT_START      = 4'd1,
        ADDR_RECV       = 4'd2,
        RW_BIT          = 4'd3,
        ACK_1           = 4'd4,
        DATA_SEND       = 4'd5,   // READ
        DATA_RECV_REG   = 4'd6,   // WRITE byte 0
        DATA_RECV_DATA  = 4'd7,   // WRITE byte 1
        M_ACK           = 4'd8,
        ACK_2           = 4'd9,
        ACK_3           = 4'd10,
        WAIT_STOP       = 4'd11
    } state_t;

  state_t state;
  state_t next_state;

  //----------------------------------------------------------
  // Open-drain SDA
  //----------------------------------------------------------
  assign sda = (sda_drive) ? 1'b0 : 1'bz;

/*
  //----------------------------------------------------------
  // START condition (unchanged)
  //----------------------------------------------------------
  always @(negedge sda or negedge rst_n) begin
      if (!rst_n) begin
          // nothing
      end else if (scl == 1) begin
          state <= ADDR_RECV;
          bit_count <= 0;
      end
  end

  //----------------------------------------------------------
  // STOP condition (unchanged)
  //----------------------------------------------------------
  always @(posedge sda or negedge rst_n) begin
      if (!rst_n) begin
          // nothing
      end else if (scl == 1) begin
          state <= WAIT_START;
          bit_count <= 0;
      end
  end
*/

always @(negedge sda) begin
    if(state == WAIT_STOP | state == WAIT_START) begin
        if((scl & !sda) | start_detected) start_detected <= 1;
        else start_detected <= 0;
    end
    else start_detected <= 0;
end

always @(posedge sda) begin
    if(state == WAIT_STOP) begin
        if((scl & sda) | stop_detected) stop_detected <= 1;
        else stop_detected <= 0;
    end
    else stop_detected <= 0;
end

  //----------------------------------------------------------
  // NEXT state logic
  //----------------------------------------------------------
  always_comb begin
    casex ({sda, scl, state})  
            6'b01_0001: next_state = ADDR_RECV;       // START condition (in WAIT_START)
            6'bx1_0010: begin // (ADDR_RECV)
                if(bit_count == 5) next_state = RW_BIT;  // After receiving 7 bits of address
                else next_state = ADDR_RECV;
            end
            6'bx1_0011: begin // (RW_BIT)
                if (slave_addr == SLAVE_ADDRESS) next_state = ACK_1;
                else next_state = WAIT_START; 
            end
            6'bx1_0100: begin // (ACK_1)
                if (op) next_state = DATA_SEND;  // READ
                else next_state = DATA_RECV_REG; // WRITE
            end
            6'bx1_0101: begin // (DATA_SEND)
                if (bit_count == 0) next_state = M_ACK; // After sending 8 bits
                else next_state = DATA_SEND;
            end
            6'bx1_0110: begin // (DATA_RECV_REG)
                if(bit_count == 7) next_state = ACK_2; // After receiving 8 bits (reg addr)
                else next_state = DATA_RECV_REG;
            end
            6'bx1_0111: begin // (DATA_RECV_DATA)
                if(bit_count == 7) next_state = ACK_3; // After receiving 8 bits (data)
                else next_state = DATA_RECV_DATA;
            end
            6'b01_1000: begin // (M_ACK)
                next_state = DATA_SEND; 
            end
            6'b11_1000: begin // (M_ACK)
                if(op) next_state = WAIT_STOP;  
                else next_state = DATA_RECV_DATA; 
            end
            6'bx1_1001: begin // (ACK_2)
                next_state = DATA_RECV_DATA;
            end
            6'bx1_1010: begin // (ACK_3)
                next_state = WAIT_STOP;
            end
            6'bxx_1011: begin
                if(stop_detected & start_detected) next_state = ADDR_RECV;
                else if(stop_detected) next_state = WAIT_START;
                else next_state = WAIT_STOP;
            end
            default: next_state = state;  // Hold current state
    endcase
  end

  //----------------------------------------------------------
  // Main FSM (posedge SCL ONLY)
  //----------------------------------------------------------
  always_ff @(posedge scl or negedge rst_n) begin
    if (!rst_n) begin
        state       <= WAIT_START;
        slave_addr  <= 7'd0;
        reg_addr_o  <= 8'd0;
        data_out_o  <= 8'd0;
        valid_out_o <= 1'b0;
        bit_count   <= 4'd0;
        op          <= 1'b0;
        op_o        <= 1'b0;
    end else begin
        state <= next_state;  // Update state on clock edge
        case (state)

        WAIT_START: begin
            slave_addr  <= 7'd0;
            reg_addr_o  <= 8'd0;
            data_out_o  <= 8'd0;
            valid_out_o <= 1'b0;
            bit_count   <= 4'd0;
            op          <= 1'b0;
            op_o        <= 1'b0;
        end

        ADDR_RECV: begin
            if (bit_count == 5) begin
                bit_count <= 0;
                slave_addr <= {slave_addr[5:0], sda};
            end    
            else begin
                slave_addr <= {slave_addr[5:0], sda};
                bit_count  <= bit_count + 1;
            end
        end

        RW_BIT: begin
            op <= sda;
        end

        ACK_1: begin
            op_o <= op;
            if (op) begin
                bit_count <= 7;
            end else begin
                bit_count <= 0;
            end
        end

        ACK_2: begin
            bit_count <= 0;
        end
        
        ACK_3: begin
            valid_out_o <= 1'b0;
            bit_count <= 0;
        end
        // -------------------------
        // WRITE byte 0: register address
        // -------------------------
        DATA_RECV_REG: begin
            reg_addr_o <= {reg_addr_o[6:0], sda};
            bit_count <= bit_count + 1;

            if (bit_count == 7) begin
                bit_count <= 0;
            end
        end

        // -------------------------
        // WRITE byte 1: data payload
        // -------------------------
        DATA_RECV_DATA: begin
            data_out_o <= {data_out_o[6:0], sda};
            bit_count <= bit_count + 1;

            if (bit_count == 7) begin
                valid_out_o <= 1'b1;  //
                bit_count <= 0;
                // state <= ACK_3;
            end
        end

        // -------------------------
        // READ path (unchanged)
        // -------------------------
        DATA_SEND: begin
            if (bit_count != 0) bit_count <= bit_count - 1;
        end

        M_ACK: begin
            if (~sda) bit_count <= 7;
            /*
            if (~sda) begin
                bit_count <= 7;
                // state <= DATA_SEND;
            end else begin
                // After reg addr ACK, move to data byte
                if (!op)
                    // state <= DATA_RECV_DATA;
                else
                    // state <= WAIT_START;
            end
            */
        end

        default: begin 
            slave_addr  <= 7'd0;
            reg_addr_o  <= 8'd0;
            data_out_o  <= 8'd0;
            valid_out_o <= 1'b0;
            bit_count   <= 4'd0;
            op          <= 1'b0;
            op_o        <= 1'b0;
        end
        endcase
    end
end


  //----------------------------------------------------------
  // SDA drive logic (negedge SCL ONLY)
  //----------------------------------------------------------
  always_ff @(negedge scl or negedge rst_n) begin
      if (!rst_n) begin
          sda_drive <= 1'b0;
      end else begin
          case (state)

          ACK_1, ACK_2, ACK_3: begin
              sda_drive <= 1'b1;  // ACK = pull low
          end

          DATA_SEND: begin
              if (valid_in)
                  sda_drive <= data_in[bit_count] ? 1'b0 : 1'b1;
              else
                  sda_drive <= 1'b0;
          end

          M_ACK: begin
              sda_drive <= 1'b0;  // release for master ACK/NACK
          end

          default: begin
              sda_drive <= 1'b0;
          end
          endcase
      end
  end

endmodule