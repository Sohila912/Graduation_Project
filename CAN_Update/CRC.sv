module CRC (
    input wire clk,                // Clock input
    input wire rst,                // Reset input
    input wire [7:0] data_in,      // 8-bit data input (one byte at a time)
    output reg [14:0] crc_out      // 15-bit CRC output
);

    // Polynomial: 0x4599 (CRC-15 CAN)
    localparam POLYNOMIAL = 15'h4599;
    localparam WIDTH = 15; // CRC width

    // Internal register to hold CRC value
    reg [WIDTH-1:0] crc_reg;

    // Shift register and XOR operation for CRC calculation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc_reg <= {WIDTH{1'b1}};  // Initialize CRC to all 1's
        end else begin
            // Shift-in the incoming data and XOR with polynomial
            crc_reg[WIDTH-1:8] <= crc_reg[WIDTH-1:8]; // Shift left
            crc_reg[7:0] <= crc_reg[7:0] ^ data_in;  // XOR with incoming data

            // Apply polynomial division by checking the MSB
            if (crc_reg[WIDTH-1]) begin
                crc_reg <= (crc_reg << 1) ^ POLYNOMIAL;  // Shift and XOR with polynomial
            end else begin
                crc_reg <= crc_reg << 1;  // Just shift if no XOR needed
            end
        end
    end

    // Output the CRC value
    assign crc_out = crc_reg;

endmodule