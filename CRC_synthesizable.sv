module CRC_synthesizable (
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
    logic [13:0] crc_stage [0:8];  // Intermediate CRC values (9 stages)
    logic [21:0] result;
    logic [13:0] crc_comb;

    // CRC combinational calculation (one-cycle)
    assign crc_stage[0] = 14'b0;

    genvar i;
    generate
        for (i = 0; i < 8; i++) begin : crc_gen
            wire fb = message_reg[7 - i] ^ crc_stage[i][13];
            assign crc_stage[i+1][0]  = fb;
            assign crc_stage[i+1][1]  = crc_stage[i][0];
            assign crc_stage[i+1][2]  = crc_stage[i][1];
            assign crc_stage[i+1][3]  = crc_stage[i][2] ^ fb;
            assign crc_stage[i+1][4]  = crc_stage[i][3] ^ fb;
            assign crc_stage[i+1][5]  = crc_stage[i][4];
            assign crc_stage[i+1][6]  = crc_stage[i][5];
            assign crc_stage[i+1][7]  = crc_stage[i][6] ^ fb;
            assign crc_stage[i+1][8]  = crc_stage[i][7] ^ fb;
            assign crc_stage[i+1][9]  = crc_stage[i][8];
            assign crc_stage[i+1][10] = crc_stage[i][9] ^ fb;
            assign crc_stage[i+1][11] = crc_stage[i][10];
            assign crc_stage[i+1][12] = crc_stage[i][11];
            assign crc_stage[i+1][13] = crc_stage[i][12];
        end
    endgenerate

    assign crc_comb = crc_stage[8];  // Final result after 8 bits

    // FSM Sequential Logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
            done          <= 1'b0;
            result        <= 22'b0;
            message_reg   <= 8'b0;
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
                    // CRC is computed combinationally from message_reg
                end

                FINISH: begin
                    result <= {message_reg, crc_comb};
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
