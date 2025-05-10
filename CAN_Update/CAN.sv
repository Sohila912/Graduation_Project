// CAN Controller

module CAN(
    input wire clk,
    input wire rst,
    input Identifier,               //ID 0 for higher priority 
    input RTR,                      // remote transmission request, 0 for data frame, 1 for remote frame request
    input IDE,                      // identifier extension bit, 0 for standard frame, 1 for extended frame
    input reserved_bit,             //for future use
    input [3:0] DLC,                // data length code, maximum 8 bytes in one frame
    input ACK_slot,                 //receiver sends dominant bit (0) as an ack                                                         
    input wire [7:0] data,          // Example: total data for CRC (can be longer)
    output wire [14:0] CRC_out      // 15-bit CRC output
);

    // Internal registers
    reg prev_crc_condition;
    wire pulse_start_crc;
    wire enable_crc;
    reg CRC_delimiter = 1'b1;             // 1 to confirm crc calculation           
    reg ACK_delimiter = 1'b1;             // 1 to sperate the frame parts
    reg [6:0] end_frame = 7'b1111111;
    reg [2:0] IFS = 3'b000;                 //interframe spacing
    reg start_frame = 1'b1;         // Trigger to send a frame

    // CRC condition: when we're done sending the data field (example range 0–63)
    wire crc_condition = start_frame;
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
        .pulse_start_crc(pulse_start_crc),
        .clk(clk),
        .rst(rst),
        .enable_crc(enable_crc)
    );

    // Instantiate parallel CRC module (CRC-15 polynomial used in CAN)
    wire [14:0] crc_result;
    always_comb begin 
        if (enable_crc) begin
            CRC crc_calc (
                .clk(clk),
                .rst(rst),
                .data_in(data),
                .crc_out(crc_result)
            );
        end
    end
    


    assign CRC_out = crc_result;


endmodule