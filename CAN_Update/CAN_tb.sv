module CAN_tb ();

    // Declare signals
    logic clk;
    logic rst;
    logic Identifier;                // ID for higher priority
    logic RTR;                       // Remote transmission request
    logic IDE;                       // Identifier extension bit
    logic reserved_bit;              // For future use
    logic [3:0] DLC;                 // Data length code
    logic ACK_slot;                  // Acknowledge slot
    logic [7:0] data;                // Data for CRC
    logic [14:0] CRC_out;            // CRC output

    // Clock generation
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    // Instantiate the CAN module
    CAN uut (
        .clk(clk),
        .rst(rst),
        .Identifier(Identifier),
        .RTR(RTR),
        .IDE(IDE),
        .reserved_bit(reserved_bit),
        .DLC(DLC),
        .ACK_slot(ACK_slot),
        .data(data),
        .CRC_out(CRC_out)
    );

    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        Identifier = 1'b0;            // Set identifier to lower priority
        RTR = 1'b0;                   // Data frame (not remote frame)
        IDE = 1'b0;                   // Standard frame
        reserved_bit = 1'b0;          // Reserved bit for future use
        DLC = 4'b0100;                // Data length code (4 bytes)
        ACK_slot = 1'b1;              // Receiver acknowledge bit
        data = 8'b01000101;           // Example data

        // Reset the system and wait for clock cycles
        repeat (2) @(posedge clk);    // Wait for reset to complete
        rst = 0;

        // Start frame transmission
        data = 8'b01000101;           // Data to transmit (8-bit)
        Identifier = 1'b1;            // Set identifier to higher priority

        // Wait for some clock cycles and stop the simulation
        repeat (20) @(posedge clk);
        $stop;
    end

endmodule
