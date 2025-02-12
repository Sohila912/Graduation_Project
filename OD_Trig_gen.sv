module OD_Trig_gen(
    input  logic clk,       // Clock input
    output logic trigger_signal      // trigger_signaler output
);

    // Internal signals
    logic resetCounter;
    logic [23:0] outputCounter;

    // Constants for timing
    localparam logic [23:0] ms100 = 24'b010011000100101101000000; // 100ms in clock cycles  
    localparam logic [23:0] ms100And20us = 24'b010011000100110100110011; // 100ms + 20us    //because each clk cycle is 20 ns

    // Counter module instance (internal)
    OD_Counter #(.n(24)) trigger_signaler_gen (
        .clk(clk),
        .enable(1'b1),
        .reset(resetCounter),
        .counter_output(outputCounter)
    );

    // Process to generate the trigger_signaler signal
    always_ff @(posedge clk) begin
        if (outputCounter > ms100 && outputCounter < ms100And20us)
            trigger_signal <= 1'b1;
        else
            trigger_signal <= 1'b0;

        // Reset counter logic
        if (outputCounter == ms100And20us || outputCounter === 24'bX)
            resetCounter <= 1'b1;  // Reset counter
        else
            resetCounter <= 1'b0;  // Enable counter
    end

endmodule

