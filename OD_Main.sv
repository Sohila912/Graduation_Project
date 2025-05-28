module OD_Main (clk,rst,time_out,Car_speed,distance,Identifier,IDE,reserved_bit,data);
    parameter SAFE_DIST_TIME = "TIME";

    input clk,rst;
    input time_out;                //signal from the ultrasonic indicating that there's no valid distance measurement.
    input [6:0] Car_speed;
    input [6:0] distance;       
    output logic Identifier;
    output logic IDE;
    output logic reserved_bit;
    output logic [15:0] data;


    wire [6:0] time_taken;
    wire Object_detected;

    //Distance from the ultrasonic is in meters (m)
    //Car speed is in km/h
    //Time to Collision (TTC) in seconds (s)
    //convert car speed from km/h to m/s speed(m/s)=(speed (km/h)x1000)/3600 = speed (km/h)/3.6
    //time to collision = Distance (m) / speed (m/s) = (Distance (m) x 3.6)/ speed (km/h)

    assign time_taken = (Car_speed == 0 || rst || time_out) ? 7'b1111111 : (distance * 36) / (Car_speed * 10);

    generate
        if(SAFE_DIST_TIME == "TIME")
            OD_time u1 (time_taken,clk,rst,time_out,Object_detected);
        else
            OD_distance u2 (distance,clk,rst,time_out,Object_detected);

    endgenerate


    // CAN Frame Fields
    assign Identifier    = 1'b0;
    assign IDE           = 1'b0;
    assign reserved_bit  = 1'b0;
    assign ACK_slot      = 1'b1;            //default as it will be overwritten by the ABS(receiver) to 0
    assign data          = {8'b0, Car_speed, Object_detected}; // padded with 8 zeros
    
endmodule
