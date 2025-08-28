module OD_time(time_taken, clk, rst, time_out, Object_detected);

input [6:0] time_taken;  // Changed from [22:0] to [6:0]
input clk, rst, time_out;
output Object_detected;

typedef enum logic [1:0] {IDLE, FAR_OBSTACLE, NEAR_COLLISION} Object_state;

Object_state cs, ns;

// Assertions for OD_time Module
property timeout_a;
    @(posedge clk) disable iff (rst) (time_out |-> ns == IDLE);
endproperty

property time_a;
    @(posedge clk) disable iff (rst) (time_taken > 7'd3 && !time_out |-> ns == FAR_OBSTACLE);
endproperty

property time_a2;
    @(posedge clk) disable iff (rst) (time_taken <= 7'd3 && !time_out |-> ns == NEAR_COLLISION);
endproperty

property output_a;
    @(posedge clk) disable iff (rst) (cs == NEAR_COLLISION |-> Object_detected);
endproperty

// Coverage and Assertions for Reset Condition
always_comb begin
    if (rst) begin
        state_rst_a: assert final(cs == IDLE);
        state_rst_c: cover(cs == IDLE);
        output_rst_a: assert final(!Object_detected);
        output_rst_c: cover(!Object_detected);
    end
end

assert property (timeout_a);
cover property (timeout_a);
assert property (time_a);
cover property (time_a);
assert property (time_a2);
cover property (time_a2);
assert property (output_a);
cover property (output_a);

// State memory
always @(posedge clk or posedge rst) begin
    if (rst)
        cs <= IDLE;
    else 
        cs <= ns;
end

// Next state logic
always @(*) begin
    case (cs)
        IDLE: begin
            if (time_out)
                ns = IDLE;
            else if (time_taken > 7'd3)
                ns = FAR_OBSTACLE;
            else
                ns = NEAR_COLLISION;
        end
        FAR_OBSTACLE: begin
            if (time_out)
                ns = IDLE;
            else if (time_taken > 7'd3)
                ns = FAR_OBSTACLE;
            else
                ns = NEAR_COLLISION;
        end
        NEAR_COLLISION: begin
            if (time_out)
                ns = IDLE;
            else if (time_taken > 7'd3)
                ns = FAR_OBSTACLE;
            else
                ns = NEAR_COLLISION;
        end
        default: ns = IDLE;
    endcase
end

// Output Logic
assign Object_detected = (cs == NEAR_COLLISION && !rst) ? 1'b1 : 1'b0;

endmodule
