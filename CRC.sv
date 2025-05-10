module CRC (
    input  logic        clk,
    input  logic        rst,
    input  logic        start,
    input  logic [7:0]  data_in,
    output logic        done,
    output logic [21:0] data_out  // 8-bit message + 14-bit CRC
);

    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        ENCODE  = 2'b01,
        FINISH  = 2'b10
    } state_t;

    state_t current_state, next_state;

    logic [7:0]  message_reg;
    logic [13:0] crc_reg;
    logic [21:0] result;

    // Polynomial: x^14 + x^10 + x^8 + x^7 + x^4 + x^3 + 1
    function automatic logic [13:0] compute_crc14(input logic [7:0] data);
        logic [13:0] crc, next_crc;
        integer i;
        begin
            crc = 14'b0;
            for (i = 7; i >= 0; i--) begin
                next_crc[0]  = data[i] ^ crc[13];
                next_crc[1]  = crc[0];
                next_crc[2]  = crc[1];
                next_crc[3]  = crc[2] ^ next_crc[0];
                next_crc[4]  = crc[3] ^ next_crc[0];
                next_crc[5]  = crc[4];
                next_crc[6]  = crc[5];
                next_crc[7]  = crc[6] ^ next_crc[0];
                next_crc[8]  = crc[7] ^ next_crc[0];
                next_crc[9]  = crc[8];
                next_crc[10] = crc[9] ^ next_crc[0];
                next_crc[11] = crc[10];
                next_crc[12] = crc[11];
                next_crc[13] = crc[12];
                crc = next_crc;
            end
            return crc;
        end
    endfunction

    // FSM Sequential Logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
            crc_reg       <= 14'b0;
            message_reg   <= 8'b0;
            result        <= 22'b0;
            done          <= 1'b0;
        end else begin
            current_state <= next_state;

            case (current_state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        message_reg <= data_in;
                    end
                end

                ENCODE: begin
                    crc_reg <= compute_crc14(message_reg);
                end

                FINISH: begin
                    result <= {message_reg, crc_reg};
                    done   <= 1'b1;
                end
            endcase
        end
    end

    // FSM Combinational Logic
    always_comb begin
        case (current_state)
            IDLE:    next_state = (start) ? ENCODE : IDLE;
            ENCODE:  next_state = FINISH;
            FINISH:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    assign data_out = result;

endmodule
