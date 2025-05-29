module Top (
    input clk,
    input rst,
    input brake_pedal,
    input time_out,
    input [6:0] car_speed,
    input [6:0] distance,
    output brake_signal
);

    logic Identifier, IDE, reserved_bit;
    logic [15:0] data;
    logic [43:0] CAN_frame;
    logic ACK_slot;

    wire [6:0] time_taken_asserted;
    assign time_taken_asserted = (car_speed == 0 || rst || time_out) ? 7'b1111111 : (distance * 36) / (car_speed * 10);

    // OD Module
    OD_Main od_inst (
        .clk(clk),
        .rst(rst),
        .time_out(time_out),
        .Car_speed(car_speed),
        .distance(distance),
        .Identifier(Identifier),
        .IDE(IDE),
        .reserved_bit(reserved_bit),
        .data(data)
    );

    // CAN Controller
    CAN can_inst (
        .clk(clk),
        .rst(rst),
        .Identifier(Identifier),
        .IDE(IDE),
        .reserved_bit(reserved_bit),
        .ACK_slot(ACK_slot),
        .data(data),
        .Frame(CAN_frame)
    );

    // ABS Controller
    ABS_Controller abs_inst (
        .clk(clk),
        .rst(rst),
        .brake_pedal(brake_pedal),
        .CAN_frame(CAN_frame),
        .brake_signal(brake_signal),
        .ACK_slot(ACK_slot)
    );

    // ========== Assertions ==========
    
    // Property: When reset is active, brake_signal must be low
    property rst_holds_brake_low;
    @(posedge clk) disable iff (!rst)
    rst |-> ##[1:15] brake_signal == 0;
endproperty
assert property (rst_holds_brake_low);
cover property (rst_holds_brake_low);



    // Property: If the brake pedal is pressed and timeout is low, braking should eventually occur
    property brake_pedal_response;
        @(posedge clk) disable iff (rst || !brake_pedal || time_out)
        (brake_pedal && !time_out) |-> ##[1:15] brake_signal;
    endproperty
    assert property (brake_pedal_response);
    cover property (brake_pedal_response);

    // Property: If car is fast and obstacle is near, brake_signal should assert within 15 cycles
property obstacle_close_response;
    @(posedge clk) disable iff (rst || time_out)
    (time_taken_asserted <= 7'd3) |-> ##[1:15] brake_signal;
endproperty
assert property (obstacle_close_response);
cover property (obstacle_close_response);

// Property: If no danger and brake_pedal is not pressed, brake_signal should stay low for 15 cycles
property no_danger_no_brake;
    @(posedge clk) disable iff (rst)
    (!brake_pedal && time_taken_asserted > 7'd3 && !time_out) |-> ##[1:15] brake_signal == 0;
endproperty
assert property (no_danger_no_brake);
cover property (no_danger_no_brake);


    // Only check forwarding when ACK_slot is active
property ack_forwarding_active;
    @(posedge clk) disable iff (rst)
    abs_inst.ACK_slot |=> (abs_inst.ACK_slot == can_inst.ACK_slot);
endproperty
assert property (ack_forwarding_active);
cover property (ack_forwarding_active);



endmodule
