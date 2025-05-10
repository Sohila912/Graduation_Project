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

    repeat (1000) begin
      rst = $random;
      brake_pedal = $random;
      Object_detected = $random;
      wheel_speed = $random;
      repeat (2) @(posedge clk);
    end
    $stop;
  end
endmodule
