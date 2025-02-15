module ABS_Controller (clk,rst,brake_pedal,Object_detected,wheel_speed,brake_signal);
    input           clk;               // System clock
    input           rst;             // Reset signal (active high)
    input           brake_pedal;       // Manual brake input
    input           Object_detected; // Obstacle detection signal
    input   [7:0]   wheel_speed;       // Current wheel speed
    output          brake_signal;       // Signal to the brake actuator


// Parameter for lock detection threshold
parameter logic [7:0] SPEED_THRESHOLD = 8'd20;

// Combine the braking triggers into one signal
logic auto_brake;
assign auto_brake = brake_pedal | Object_detected;

// Define the finite state machine (FSM) states using an enumerated type
typedef enum logic [1:0] { IDLE,BRAKE,LOCK} brake_state;
/*
IDLE: The Idle state where it prevents the wheel from locking by releasing braking force.
BRAKE:This is  where the brakes are applied in the usual manner.
LOCK:Stops completely.
*/

brake_state cs, ns;

//state memory 
always @(posedge clk or posedge rst) begin
    if (rst)
        cs <= IDLE;  //Idle state to release the brakes
    else
        cs <= ns;
end

//next state logic
always @(*) begin
    
    case (cs)

        IDLE: 
            if(brake_pedal)
                ns = BRAKE;
            else if (Object_detected)
                ns = LOCK;
            else
            ns = IDLE;
        BRAKE: //where the driver applies the brakes himself
            if ((brake_pedal && (wheel_speed < SPEED_THRESHOLD)) || Object_detected)
                ns = LOCK;
            else if(!brake_pedal)
                ns = IDLE;
            else
                ns = BRAKE;

        LOCK: //hand brake when the obstacle is detected (Until the car stops)
            if(!auto_brake)
            ns = IDLE;
            else
            ns = LOCK;

        default: ns = IDLE;
    endcase
end

// Output logic
assign brake_signal = ((cs == BRAKE || cs == LOCK) && !rst) ? 1'b1 : (rst)? 1'b0 : 1'b0;

// // --- Assertions ---
//   // Assertion 1: When no braking inputs are present, brake_signal should be 0.
//   property no_brake_when_idle;
//     @(posedge clk) disable iff (rst)
//       (!brake_pedal && !Object_detected) |-> (brake_signal == 1'b0);
//   endproperty

//   // Assertion 2: When the brake pedal is pressed (and no object detected), brake_signal should be 1.
//   property brake_pedal_asserted;
//     @(posedge clk) disable iff (rst)
//       (brake_pedal && !Object_detected) |-> (brake_signal == 1'b1);
//   endproperty

//   // Assertion 3: When an object is detected, brake_signal must be asserted.
//   property object_detected_implies_brake;
//     @(posedge clk) disable iff (rst)
//       (Object_detected) |-> (brake_signal == 1'b1);
//   endproperty

//   // Assertion 4: After inputs are cleared, eventually brake_signal goes low.
//   property eventually_idle;
//     @(posedge clk) disable iff (rst)
//       ((!brake_pedal && !Object_detected) throughout [*2]) |-> (brake_signal == 1'b0);
//   endproperty

//   // Attach the assertions
//   assert property (no_brake_when_idle);
//   cover property (no_brake_when_idle);

//   assert property (brake_pedal_asserted);
//   cover property (brake_pedal_asserted);

//   assert property (object_detected_implies_brake);
//     cover property (object_detected_implies_brake);

//   assert property (eventually_idle);
//     cover property (eventually_idle);
    

endmodule
