module OD_Time_tb ();
    bit clk;
    // logic [2:0] distance;  //Highest distance is 4 meters
    // logic [7:0] speed;     //Highest speed is 255 km/hr
    logic [22:0] time_taken;
    logic rst,time_out,Object_detected;
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
    OD_time u1 (time_taken/2,clk,rst,time_out,Object_detected);
    initial begin
        rst=1;
        time_taken=0;
        time_out=0;
        @(posedge clk);
        rst=0;
        repeat(100) begin
            time_taken=$urandom_range(0, 5);
            time_out=$random;
            @(posedge clk);
        end
        time_out=0;
        time_taken=10;
        repeat(4) @(posedge clk);
        $stop;
    end
endmodule

