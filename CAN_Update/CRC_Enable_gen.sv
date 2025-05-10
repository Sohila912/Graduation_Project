module CRC_Enable_gen (
    input pulse_start_crc,   // Trigger when data field starts
    input clk,
    input rst,
    output reg enable_crc    // One-cycle pulse to start CRC
);
initial enable_crc = 0;

parameter waiting_l = 2'b00, on = 2'b01, waiting_h = 2'b10;
reg [1:0] current_state, next_state;

always @ (posedge clk or posedge rst) begin
    if (rst)
        current_state <= waiting_l;
    else
        current_state <= next_state;
end

always @ (current_state or pulse_start_crc) begin
    case (current_state)
        waiting_l: next_state = pulse_start_crc ? on : waiting_l;
        on:        next_state = waiting_h;
        waiting_h: next_state = pulse_start_crc ? waiting_h : waiting_l;
    endcase
end

always @ (current_state or rst) begin
    if (rst)
        enable_crc <= 1'b0;
    else
        enable_crc <= (current_state == on);
end

endmodule
