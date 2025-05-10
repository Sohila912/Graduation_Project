module OD_ultrasonic_tb();
    // Testbench signals
    bit clk;
    logic [22:0] time_in_seconds;  // Output from the DUT
    logic rst, echo_pulse, time_out;

    // Instantiate the DUT
    OD_ultrasonic u1 (
        .clk(clk),
        .echo_pulse(echo_pulse),
        .time_in_seconds(time_in_seconds),
        .time_out(time_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #1 clk = ~clk;  // Clock period of 2 time units
    end

    // Test process
    initial begin
        // Initialization
        rst = 1;
        echo_pulse = 0;
        @(posedge clk);
        rst = 0;

        // Run the test for a specified number of cycles
        repeat(100000000) begin
            // Randomly assign values to echo_pulse and rst
            echo_pulse = $random;
            // rst = $random;
            @(posedge clk);
        end

        // End of simulation
        $stop;
    end
endmodule

