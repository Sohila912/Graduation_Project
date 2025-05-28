module Main_tb();
    logic clk;
    logic rst;
    logic time_out;
    logic [6:0] Car_speed;     // in km/h
    logic [6:0] distance;      // in meters
    logic Object_detected;

    // Clock generation
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    // Instantiate DUT
    OD_Main u1 (.*); 

    // Stimulus
    initial begin
        rst = 1;
        time_out = 0;
        Car_speed = 0;
        distance = 0;

        @(posedge clk);
        rst = 0;
        
        @(posedge clk);

        // Run random test for 1000 clock cycles
        repeat (1000) begin
            time_out = $urandom_range(0, 1);
            rst = $urandom_range(0, 5) == 0; // 20% chance of reset
            Car_speed = $urandom_range(0, 127); // 7-bit speed
            distance = $urandom_range(0, 127);  // 7-bit distance
            @(posedge clk);
        end

        $stop;
    end
endmodule
