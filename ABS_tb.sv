module ABS_Controller_tb;
  // Testbench signals
  logic         clk;
  logic         rst;
  logic         brake_pedal;
  logic         Object_detected;
  logic [7:0]   wheel_speed;
  logic         brake_signal;

  // Clock generation as provided
  initial begin
    clk = 0;
    forever #1 clk = ~clk;
  end

  // Instantiate the ABS_Controller DUT
  ABS_Controller dut (
    .clk(clk),
    .rst(rst),
    .brake_pedal(brake_pedal),
    .Object_detected(Object_detected),
    .wheel_speed(wheel_speed),
    .brake_signal(brake_signal)
  );

  // Test sequence using only @(posedge clk) and repeat
  initial begin
    // --- Reset Phase ---
    rst = 1;
    brake_pedal = 0;
    Object_detected = 0;
    wheel_speed = 8'd50;  // Assume the car is moving
    repeat (2) @(posedge clk); // Hold reset for 2 clock cycles

    rst = 0;
    
    // --- Scenario 1: Idle State ---
    // With no inputs asserted, brake_signal should remain 0.
    repeat (5) @(posedge clk);

    // --- Scenario 2: Driver Applies the Brake ---
    // The brake pedal is pressed. With wheel_speed high (50 > 20), expect normal BRAKE state.
    brake_pedal = 1;
    repeat (5) @(posedge clk);

    // --- Scenario 3: Transition to LOCK ---
    // Lower wheel_speed below threshold to simulate rapid deceleration (below 20)
    wheel_speed = 8'd15;
    repeat (5) @(posedge clk);

    // --- Scenario 4: Return to Idle ---
    // Clear the brake pedal and object detection, wheel speed back to normal.
    brake_pedal = 0;
    Object_detected = 0;
    wheel_speed = 8'd50;
    repeat (10) @(posedge clk);

    // --- Scenario 5: Obstacle Detected ---
    // Assert the Object_detected signal to force a full stop (LOCK state).
    Object_detected = 1;
    repeat (5) @(posedge clk);

    // --- Scenario 6: Clear Object Detection ---
    Object_detected = 0;
    repeat (10) @(posedge clk);

    $stop;
  end
endmodule
