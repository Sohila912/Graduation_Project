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

endmodule
