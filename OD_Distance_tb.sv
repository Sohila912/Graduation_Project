module OD_Distance_tb ();
    bit clk;
    logic [22:0] distance;  //Highest distance is 4 meters
    logic rst,time_out,Object_detected;
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
    OD_distance u1 (.*);
    initial begin
        rst=1;
        distance=0;
        time_out=0;
        @(posedge clk);
        rst=0;
        repeat(1000) begin
            distance=$urandom_range(0,10);
            time_out=$random;
            rst=$random;
            @(posedge clk);
        end
        $stop;
    end
endmodule
