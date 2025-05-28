module OD_distance(distance, clk, rst, time_out, Object_detected);

input [6:0] distance;  // Highest distance is 4 meters
input clk, rst, time_out;
output Object_detected;

typedef enum logic [1:0] {IDLE, FAR_OBSTACLE, NEAR_COLLISION} Object_state;

Object_state cs, ns;

/////////// Assertions
property timeout_a;
    @(posedge clk) disable iff (rst) (time_out |-> ns == IDLE);
endproperty

property distance_a;
    @(posedge clk) disable iff (rst) (distance > 7'd4 && !time_out |-> ns == FAR_OBSTACLE);
endproperty

property distance_a2;
    @(posedge clk) disable iff (rst) (distance <= 7'd4 && !time_out |-> ns == NEAR_COLLISION);
endproperty

always_comb begin
    if (rst) begin
        state_rst_a: assert final(cs == IDLE);
        state_rst_c: cover final(cs == IDLE);
        output_rst_a: assert final(!Object_detected);
        output_rst_c: cover final(!Object_detected);
    end
    else if (cs == NEAR_COLLISION) begin
        output_a: assert final(Object_detected);
        output_c: cover final(Object_detected);
    end
end

assert property (timeout_a);
cover property (timeout_a);
assert property (distance_a);
cover property (distance_a);
assert property (distance_a2);
cover property (distance_a2);

// State Memory
always @(posedge clk or posedge rst) begin
    if (rst)
        cs <= IDLE;
    else 
        cs <= ns;
end

// Next State Logic
always @(*) begin
    case (cs)
        IDLE: begin
            if (time_out)
                ns = IDLE;
            else if (distance > 7'd4)
                ns = FAR_OBSTACLE;
            else
                ns = NEAR_COLLISION;
        end

        FAR_OBSTACLE: begin
            if (time_out)
                ns = IDLE;
            else if (distance <= 7'd4)
                ns = NEAR_COLLISION;
            else
                ns = FAR_OBSTACLE;
        end

        NEAR_COLLISION: begin
            if (time_out)
                ns = IDLE;
            else if (distance > 7'd4)
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
