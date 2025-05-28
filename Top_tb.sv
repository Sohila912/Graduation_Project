module Top_tb();

    // Signals
    logic clk;
    logic rst;
    logic brake_pedal;
    logic time_out;
    logic [6:0] car_speed;
    logic [6:0] distance;
    wire brake_signal;

    // Instantiate the DUT
    Top dut (
        .clk(clk),
        .rst(rst),
        .brake_pedal(brake_pedal),
        .time_out(time_out),
        .car_speed(car_speed),
        .distance(distance),
        .brake_signal(brake_signal)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end


    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        brake_pedal = 0;
        time_out = 0;
        car_speed = 0;
        distance = 0;

        // Apply reset
        repeat (3) @(posedge clk);
        rst = 0;

        // === Test 1: Normal driving, no obstacle ===
        car_speed = 7'd60;   // 60 km/h
        distance  = 7'd50;   // 50 meters
        brake_pedal = 0;
        time_out = 0;
        repeat (5) @(posedge clk);

        //=== Test 2: Obstacle detected close ===
        car_speed = 7'd60;   // Maintain speed
        distance  = 7'd5;    // Close object detected
        brake_pedal = 0;
        time_out = 0;
        repeat (10) @(posedge clk);

        //=== Test 3: Driver applies brake ===
        car_speed = 7'd20;
        distance  = 7'd5;
        brake_pedal = 1;
        time_out = 0;
        repeat (10) @(posedge clk);

        //=== Test 4: Timeout (no object detected) ===
        car_speed = 7'd20;
        distance  = 7'd5;
        brake_pedal = 1;
        time_out = 1;
        repeat (10) @(posedge clk);

        //=== Test 5: Obstacle cleared ===
        car_speed = 7'd20;
        distance  = 7'd60;
        brake_pedal = 0;
        time_out = 0;
        repeat (10) @(posedge clk);

        $stop;
    end

endmodule
