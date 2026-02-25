
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
        ACK_3           = 4'd10
    } state_t;

  state_t state;

  //----------------------------------------------------------
  // Open-drain SDA
  //----------------------------------------------------------
  assign sda = (sda_drive) ? 1'b0 : 1'bz;

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

        case (state)

        WAIT_START: begin
        end

        ADDR_RECV: begin
            slave_addr <= {slave_addr[5:0], sda};
            bit_count  <= bit_count + 1;
            if (bit_count == 6) begin
                bit_count <= 0;
                state <= RW_BIT;
            end
        end

        RW_BIT: begin
            op <= sda;
            if (slave_addr == SLAVE_ADDRESS)
                state <= ACK_1;
            else
                state <= WAIT_START;
        end

        ACK_1: begin
            op_o <= op;
            if (op) begin
                // READ
                state <= DATA_SEND;
                bit_count <= 7;
            end else begin
                // WRITE → first byte = register address
                state <= DATA_RECV_REG;
                bit_count <= 0;
            end
        end

        ACK_2: begin
            // WRITE → first byte = register address
            state <= DATA_RECV_DATA;
            bit_count <= 0;
        end
        
        ACK_3: begin
            valid_out_o <= 1'b0;
            // WRITE → first byte = register address
            state <= WAIT_START;
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
                state <= ACK_2;  // ACK reg address
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
                state <= ACK_3;
            end
        end

        // -------------------------
        // READ path (unchanged)
        // -------------------------
        DATA_SEND: begin
            if (bit_count == 0)
                state <= M_ACK;
            else
                bit_count <= bit_count - 1;
        end

        M_ACK: begin
            if (~sda) begin
                bit_count <= 7;
                state <= DATA_SEND;
            end else begin
                // After reg addr ACK, move to data byte
                if (!op)
                    state <= DATA_RECV_DATA;
                else
                    state <= WAIT_START;
            end
        end

        default: state <= WAIT_START;
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