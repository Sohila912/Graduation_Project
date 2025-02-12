module OD_distance(distance,clk,rst,time_out,Object_detected);

input [22:0] distance;  //Highest distance is 4 meters
// input [7:0] speed;     //Highest speed is 255 km/hr
input clk,rst,time_out;
output Object_detected;

typedef enum logic [1:0] {IDLE,FAR_OBSTACLE,NEAR_COLLISION} Object_state;

Object_state cs,ns;
///////////assertions 
property timeout_a;
    @(posedge clk) disable iff (rst) (time_out |-> ns == IDLE); //3ala ns 3alshan l if conditions deh bt2asr fl ns
endproperty
property distance_a;
    @(posedge clk) disable iff (rst) (distance > 3'b100 && !time_out |-> ns == FAR_OBSTACLE);
endproperty
property distance_a2;
    @(posedge clk) disable iff (rst) (distance <= 3'b100 && !time_out |-> ns == NEAR_COLLISION);
endproperty
property output_a;
    @(posedge clk) disable iff (rst) (cs==NEAR_COLLISION |-> Object_detected);
endproperty
always_comb begin
    if(rst) begin
        state_rst_a:assert final(cs==IDLE);
        state_rst_c:cover(cs==IDLE);
        output_rst_a:assert final(!Object_detected);
        output_rst_c:cover(!Object_detected);
    end
end
assert property (timeout_a);
cover property (timeout_a);
assert property (distance_a);
cover property (distance_a);
assert property (distance_a2);
cover property (distance_a2);
assert property (output_a);
cover property (output_a);


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
            else if(distance > 23'b100)  //Max distance
                ns = FAR_OBSTACLE;
            else    
                ns = NEAR_COLLISION;
        end

        //Second Case
        FAR_OBSTACLE: begin
            if(time_out) //timeout error from the sensor
                ns = IDLE;
            else if(distance <= 23'b100) 
                ns = NEAR_COLLISION;
            else
                ns = FAR_OBSTACLE;
        end

        //Third Case
        NEAR_COLLISION: begin
            if(time_out) //timeout error from the sensor
                ns = IDLE;
            else if(distance > 23'b100) //Max distance
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
