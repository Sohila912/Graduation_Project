// CAN Controller

module CAN(
    input wire clk,
    input wire rst,
    input Identifier,               // ID 0 for higher priority 
    input IDE,                      // identifier extension bit, 0 for standard frame, 1 for extended frame
    input reserved_bit,             // for future use
    input logic ACK_slot,           // receiver sends dominant bit (0) as an ack                                                         
    input wire [15:0] data,         // can be longer, we only going to use 8 bits as the data being sent speed(7) & object detected (1)
    output logic [43:0] Frame
    
);
    //////RTR will be used when receiver wants to send an ack
    //////ID & IDE sender will decide the priority of the frame
 
    // Internal registers
    reg prev_crc_condition;
    wire pulse_start_crc;
    wire enable_crc;
    wire enable_crc_done;                   //flag to show that CRC had finished calculations
    reg CRC_delimiter = 1'b1;               // 1 to confirm crc calculation           
    reg ACK_delimiter = 1'b1;               // 1 to sperate the frame parts
    reg [6:0] end_frame = 7'b1111111;
    reg [2:0] IFS = 3'b000;                 //interframe spacing
    reg start_frame = 1'b1;                 // Trigger to send a frame
    wire [21:0] CRC_out,crc_result;         // 22-bit CRC output  8-bit message + 14-bit CRC 
    wire [3:0] DLC = 4'd2;                  // data length code, maximum 8 bytes in one frame, 2 bytes used 
    
    // // CRC condition: when we're done sending the data field (example range 0–63)
    // wire crc_condition = start_frame;

    logic RTR;                                   // remote transmission request, 0 for data frame, 1 for remote frame request
    assign RTR = (ACK_slot)? 1'b0 : 1'b1 ;      //if the receiver sent ACK then RTR is 1 

    reg [43:0] last_frame;      //reg to hold the last frame so that if ACK is not send the data is not lost
    

    // reg [2:0] frame_counter;
    // reg start_frame_reg;

    // always @(posedge clk or posedge rst) begin
    //     if (rst) begin
    //         frame_counter <= 0;
    //         start_frame_reg <= 0;
    //     end else begin
    //         if (frame_counter == 3'd1)
    //             start_frame_reg <= 1'b1; // Pulse one cycle
    //         else
    //             start_frame_reg <= 1'b0;

    //         frame_counter <= frame_counter + 1;
    //     end
    // end

    // wire crc_condition = start_frame_reg; // one-cycle rising edge trigger





    // // Rising edge detection to generate 1-cycle pulse for CRC start
    // always @(posedge clk or posedge rst) begin
    //     if (rst)
    //         prev_crc_condition <= 0;
    //     else
    //         prev_crc_condition <= crc_condition;
    // end

    // assign pulse_start_crc = crc_condition & ~prev_crc_condition;  // 1-cycle pulse

    // // Instantiate CRC_Enable_gen module & CRC
    // CRC_Enable_gen crc_EN (
    //     .pulse_start_crc(pulse_start_crc),
    //     .clk(clk),
    //     .rst(rst),
    //     .enable_crc(enable_crc)
    // );
   

    // CRC_synthesizable crc_calc (
    //             .clk(clk),
    //             .rst(rst),
    //             .start(enable_crc),
    //             .data_in(data[7:0]),
    //             .done(enable_crc_done),
    //             .data_out(crc_result)
    //         );   

     CRC_synthesizable crc_calc (
                .clk(clk),
                .rst(rst),
                .start(1'b1),
                .data_in(data[7:0]),
                .done(enable_crc_done),
                .data_out(crc_result)
            );       

    //assign CRC_out = (enable_crc_done)? crc_result : 0 ;

    reg [21:0] latched_crc;

    always @(posedge clk or posedge rst) begin
        if (rst)
            latched_crc <= 0;
        else if (enable_crc_done)
            latched_crc <= crc_result;
    end

    assign CRC_out = latched_crc;

    // always @(posedge clk or posedge rst) begin
    //     if (rst) begin
    //         Frame <= 44'd0;
    //         last_frame <= 44'd0;
    //    end else begin
    //         if (ACK_slot == 1'b0) begin
    //             Frame <= {start_frame, Identifier, RTR, IDE, reserved_bit, DLC,
    //                       CRC_out, CRC_delimiter, ACK_slot, ACK_delimiter, end_frame, IFS};
    //             last_frame <= Frame;
    //         end else begin
    //             Frame <= last_frame; // Resend previous frame
    //         end
    //     end
    // end


    logic [43:0] new_frame;

    always_comb begin
        new_frame = {start_frame, Identifier, RTR, IDE, reserved_bit, DLC,
                    CRC_out, CRC_delimiter, ACK_slot, ACK_delimiter, end_frame, IFS};
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Frame <= 44'd0;
            last_frame <= 44'd0;
        end else begin
            if (ACK_slot == 1'b0) begin
                Frame <= new_frame;
                last_frame <= new_frame;
            end else begin
                Frame <= last_frame;     // Resend previous frame
            end
        end
    end


endmodule