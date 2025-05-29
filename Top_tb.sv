module Top_tb();

    // Signals
    logic clk;
    logic rst;
    logic brake_pedal;
    logic time_out;
    logic [6:0] car_speed;
    logic [6:0] distance;
    wire brake_signal;
    int error_count, correct_count;

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

    // Clock generation
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    // Main test process
    initial begin
        error_count = 0;
        correct_count = 0;

        // Reset the DUT
        reset_assert();

        // === Fixed test cases ===
        $display("Running fixed test cases...");
        apply_test(7'd60, 7'd50, 0, 0); // Normal driving
        apply_test(7'd60, 7'd5,  0, 0); // Obstacle close
        apply_test(7'd20, 7'd5,  1, 0); // Driver brakes
        apply_test(7'd20, 7'd5,  1, 1); // Timeout
        apply_test(7'd20, 7'd60, 0, 0); // Obstacle cleared

        // === Randomized test cases ===
        $display("Running randomized test cases...");
        repeat (1000) begin
            car_speed = $urandom_range(0, 7'd100);  // Car speed [0–100]
            distance  = $urandom_range(0, 7'd100);  // Distance [0–100]
            brake_pedal = ($urandom_range(0, 9) == 0); // 10% chance it's 1, 90% it's 0
            time_out = $urandom_range(0, 1);
            apply_test(car_speed, distance, brake_pedal, time_out);
        end

        $display("Simulation complete.");
        $display("Error count = %0d, Correct count = %0d", error_count, correct_count);
        $stop;
    end

    // Helper task to apply and evaluate a test
    task apply_test(
        input logic [6:0] speed,
        input logic [6:0] dist_Applytest,
        input logic pedal,
        input logic timeout
    );
        car_speed = speed;
        distance = dist_Applytest;
        brake_pedal = pedal;
        time_out = timeout;

        repeat (15) @(posedge clk);
        GoldenModel(brake_pedal, time_out, car_speed, distance, rst);
    endtask

    // Golden model reference checker
    task GoldenModel (
        input logic brake_pedal,
        input logic time_out,
        input logic [6:0] car_speed,
        input logic [6:0] distance,
        input logic rst
    );
        logic [6:0] time_taken_GM;
        logic brake_signal_GM;

        time_taken_GM = (car_speed == 0 || rst || time_out) ? 7'b1111111 :
                        (distance * 36) / (car_speed * 10);

        if (brake_pedal || (time_taken_GM <= 7'd3 && !time_out))
            brake_signal_GM = 1;
        else
            brake_signal_GM = 0;

        if (brake_signal_GM !== dut.brake_signal) begin
            $display("Error: Input={spd=%0d, dist=%0d, pedal=%0d, to=%0d}, Expected brake_signal=%0d, Got=%0d @ %0t",
                     car_speed, distance, brake_pedal, time_out,
                     brake_signal_GM, dut.brake_signal, $time);
            error_count++;
        end else begin
            $display("Pass:  Input={spd=%0d, dist=%0d, pedal=%0d, to=%0d}, brake_signal=%0d @ %0t",
                     car_speed, distance, brake_pedal, time_out,
                     dut.brake_signal, $time);
            correct_count++;
        end
    endtask

    // Reset task
    task reset_assert();
        rst = 1;
        brake_pedal = 0;
        time_out = 0;
        car_speed = 0;
        distance = 0;

        repeat (3) @(posedge clk);
        GoldenModel(brake_pedal, time_out, car_speed, distance, rst);
        rst = 0;
    endtask

endmodule
