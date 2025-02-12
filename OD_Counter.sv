module OD_Counter #(
    parameter int n = 10 // Width of the counter
) (
    input logic clk,               // Clock input
    input logic enable,            // Enable signal
    input logic reset,             // Active-high reset signal
    output logic [n-1:0] counter_output // Counter output
);
    logic [n-1:0] count; // Internal counter

    // Counter process
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= {n{1'b0}}; // Reset counter to zero
        end else if (enable) begin
            count <= count + 1; // Increment counter when enabled
        end
    end

    assign counter_output = count; // Output current count value
endmodule
