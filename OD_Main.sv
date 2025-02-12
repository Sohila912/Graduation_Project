module OD_Main (clk,echo_pulse,speed,rst, Object_detected);
    parameter SAFE_DIST_TIME = "TIME";

    input clk,rst;
    input echo_pulse;
    input [22:0] speed;     //Highest speed is 255 km/hr
    output Object_detected;

    logic [22:0] time_taken; //time taken by echo signal to go and return back
    logic [22:0] time_reg;
    logic [22:0] distance;  //Highest distance is 4 meters
    logic time_out;
    
    assign time_reg = time_taken/2;  // Converts real to integer (rounds it)

    assign distance = (rst || time_out)? 23'b0: time_reg * speed * 1000 / 3600; //distance = time * speed
    

    //instantiate sensor hna
    OD_ultrasonic u0(clk,echo_pulse,time_taken,time_out);
    generate
        if(SAFE_DIST_TIME == "TIME")
            OD_time u1 (time_reg,clk,rst,time_out,Object_detected);
        else
            OD_distance u2 (distance,clk,rst,time_out,Object_detected);

    endgenerate
endmodule
