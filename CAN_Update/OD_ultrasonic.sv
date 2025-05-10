module OD_ultrasonic(
    input  logic clk,      // FPGA clock
    input  logic echo_pulse,        // Echo input
    output [22:0] time_in_seconds,  //real time of echo signal
    output logic time_out  //time out signal
);

    // Signals
    logic [21:0] echo_pulse_width;
    logic trigg;

    // Counter to measure echo pulse width
    OD_Counter #(.n(22)) counter_echo_pulse (
        .clk(clk),
        .enable(echo_pulse),
        .reset(~trigg),
        .counter_output(echo_pulse_width)
    );

    // Trigger generator
    OD_Trig_gen trigger_gen (
        .clk(clk),
        .trigger_signal(trigg)
    );

     always_ff @(posedge clk) begin
        if (echo_pulse_width < 55000)  //55000 is the threshold value
            time_out <= 0;
        else
            time_out <= 1;
    end

assign time_in_seconds = (echo_pulse_width * 20) / 1_000_000_000;

endmodule
