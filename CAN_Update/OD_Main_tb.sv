module Main_tb();
    logic clk;
    // logic [22:0] time_taken;
    // logic [22:0] distance;  //Highest distance is 4 meters
    logic [22:0] speed;     //Highest speed is 255 km/hr
    logic rst;
    logic Object_detected;
    logic echo_pulse;

initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
    OD_Main u1 (.*);
    initial begin
        rst=1;
        echo_pulse=0;
         @(posedge clk);
        rst=0;
        @(posedge clk);
        repeat(1000) begin     
            echo_pulse=$random;
            rst=$random;
            speed=$urandom_range(0,255);
            @(posedge clk);
        end
        $stop;
    end
//     #sim:/Main_tb/u1/genblk1/u1/cs \
// #sim:/Main_tb/u1/genblk1/u1/ns
endmodule
