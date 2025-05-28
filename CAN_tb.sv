module CAN_tb;

    // Declare signals
    logic clk;
    logic rst;
    logic Identifier;
    logic IDE;
    logic reserved_bit;
    logic ACK_slot;
    logic [15:0] data;
    logic [43:0] Frame;

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    // Instantiate the CAN module
    CAN uut (
        .clk(clk),
        .rst(rst),
        .Identifier(Identifier),
        .IDE(IDE),
        .reserved_bit(reserved_bit),
        .ACK_slot(ACK_slot),
        .data(data),
        .Frame(Frame)
    );

    // Stimulus
    initial begin
        // Initial reset
        rst = 1;
        Identifier = 0;
        IDE = 0;
        reserved_bit = 0;
        ACK_slot = 0;
        data = 16'b0;
        repeat (10) @(posedge clk);
        rst = 0;

        // Test Case 1
        data = {7'd100,1'b1};
        repeat (10) @(posedge clk);
       

        // Test Case 2
        data = { 7'd50,1'b0};
        repeat (10) @(posedge clk);


        // Test Case 3
        data = { 7'd75,1'b1};
        ACK_slot = 1;
        repeat (10) @(posedge clk);

        $stop;
    end

endmodule
