module OD_time(time_taken,clk,rst,time_out,Object_detected);

// input [2:0] distance;  //Highest distance is 4 meters
// input [7:0] speed;     //Highest speed is 255 km/hr
input [22:0] time_taken;
input clk,rst,time_out;
output Object_detected;


typedef enum logic [1:0] {IDLE,FAR_OBSTACLE,NEAR_COLLISION} Object_state;

Object_state cs,ns;

// Assertions for OD_time Module
property timeout_a;
    @(posedge clk) disable iff (rst) (time_out |-> ns == IDLE); // Timeout should lead to IDLE state
endproperty

property time_a;
    @(posedge clk) disable iff (rst) (time_taken > 11'd3 && !time_out |-> ns == FAR_OBSTACLE); // Long time taken should result in FAR_OBSTACLE
endproperty

property time_a2;
    @(posedge clk) disable iff (rst) (time_taken <= 11'd3 && !time_out |-> ns == NEAR_COLLISION); // Short time taken should result in NEAR_COLLISION
endproperty

property output_a;
    @(posedge clk) disable iff (rst) (cs == NEAR_COLLISION |-> Object_detected); // NEAR_COLLISION should trigger Object_detected signal
endproperty


// Coverage and Assertions for Reset Condition
always_comb begin
    if (rst) begin
        state_rst_a: assert final(cs == IDLE); // Ensure the system resets to IDLE
        state_rst_c: cover(cs == IDLE);       // Cover point for reset state being IDLE
        output_rst_a: assert final(!Object_detected); // Ensure Object_detected is inactive after reset
        output_rst_c: cover(!Object_detected);        // Cover point for Object_detected being inactive
    end
end

// Assert and Cover the Properties
assert property (timeout_a);
cover property (timeout_a);
assert property (time_a);
cover property (time_a);
assert property (time_a2);
cover property (time_a2);
assert property (output_a);
cover property (output_a);



// assign time_taken = (speed == 0 || rst || time_out)? 11'b11111111111: (distance/speed); //time taken to reach the object   //11 ones is a dummy value for the time taken to know that it's not valid

//state memory 
always @(posedge clk or posedge rst) begin
    if(rst)
    cs <= IDLE;
    else 
    cs <= ns;
end

//next state logic

always @(*) begin
case (cs) 
//First Case
IDLE: begin
     if(time_out) //timeout error from the sensor
     ns = IDLE;  
     else if(time_taken > 11'd3)  //Max time is 3 seconds
        ns = FAR_OBSTACLE;
    else    
    ns = NEAR_COLLISION;
end

//Second Case
FAR_OBSTACLE: begin
    if(time_out) //timeout error from the sensor
     ns = IDLE;
     else if(time_taken > 11'd3) //Max time is 3 seconds
        ns = FAR_OBSTACLE;
    else
    ns = NEAR_COLLISION;
    
end

//Third Case
NEAR_COLLISION: begin
    if(time_out) //timeout error from the sensor
     ns = IDLE;
     else if(time_taken > 11'd3) //Max time is 3 seconds
        ns = FAR_OBSTACLE;
    else
    ns = NEAR_COLLISION;
    
end
default: ns = IDLE;

endcase
end

//Output Logic
assign Object_detected = (cs==NEAR_COLLISION && !rst)? 1'b1 : (rst)? 1'b0 : 1'b0;

endmodule

