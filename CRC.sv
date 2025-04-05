module CRC (
    input [7:0] d,        // 8-bit data input
    input [14:0] c,       // Current CRC value
    output [14:0] next    // Next CRC value
);
    assign next[0]  = d[0] ^ c[14];
    assign next[1]  = d[1] ^ c[0];
    assign next[2]  = d[2] ^ c[1];
    assign next[3]  = d[3] ^ c[2] ^ c[14];
    assign next[4]  = d[4] ^ c[3] ^ c[13];
    assign next[5]  = d[5] ^ c[4] ^ c[12];
    assign next[6]  = d[6] ^ c[5];
    assign next[7]  = d[7] ^ c[6];
    assign next[8]  = c[7];
    assign next[9]  = c[8];
    assign next[10] = c[9] ^ c[14];
    assign next[11] = c[10];
    assign next[12] = c[11] ^ c[14];
    assign next[13] = c[12] ^ c[14];
    assign next[14] = c[13] ^ c[14];
endmodule
