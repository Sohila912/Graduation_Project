// CAN Controller Partial Module with Integrated CRC Trigger Logic

module CAN(
    input wire clk,
    input wire rst,
    input wire [7:0] data,         // Example: total data for CRC (can be longer)
    input wire start_frame,          // Trigger to send a frame
    output wire [14:0] CRC_out      // 15-bit CRC output
);

    // Internal registers
    reg [5:0] bit_counter;          // Tracks how many bits have been sent
    reg prev_crc_condition;
    wire pulse_start_crc;
    wire enable_crc;

    // CRC condition: when we're done sending the data field (example range 0–63)
    wire crc_condition = (bit_counter == 4'b1000) && start_frame;

    // Rising edge detection to generate 1-cycle pulse for CRC start
    always @(posedge clk or posedge rst) begin
        if (rst)
            prev_crc_condition <= 0;
        else
            prev_crc_condition <= crc_condition;
    end

    assign pulse_start_crc = crc_condition & ~prev_crc_condition;  // 1-cycle pulse

    // Instantiate CRC_Enable_gen module
    CRC_Enable_gen crc_EN (
        .pulse(pulse_start_crc),
        .clk(clk),
        .rst(rst),
        .out(enable_crc)
    );

    // Instantiate parallel CRC module (CRC-15 polynomial used in CAN)
    wire [14:0] crc_next;
    reg [14:0] crc_reg;

    CRC crc_calc (
        .c(crc_reg),
        .d(data),  // Example: calculating CRC on 8 bits at a time
        .next(crc_next)
    );

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            crc_reg <= 15'd0;
        else if (enable_crc)
            crc_reg <= crc_next;
    end

    assign crc_out = crc_reg;

    // Simulated bit counter (e.g., for serialization)
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            bit_counter <= 0;
        else if (start_frame && bit_counter < 6'd63)
            bit_counter <= bit_counter + 1;
    end

endmodule
