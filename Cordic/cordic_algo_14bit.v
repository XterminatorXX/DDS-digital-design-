`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Internship
// Engineer: Aniruddh Pandav
// 
// Create Date: 06/02/2025 07:36:43 PM
// Design Name: 
// Module Name: cordic_sin_cos_14bit
// Project Name: Cordic_algo
// Target Devices: RF-SOC 
// Tool Versions: Version 1
// Description: Module to implement CORDIC algorithm for generation of sine and cosine waves
// Dependencies: No external modules required
// Additional Comments:
// -pipelined structure, latency=no of CORDIC iterations 
// - no requirement of exteral modules/ block memory
// -single clock based module 
//////////////////////////////////////////////////////////////////////////////////

module cordic_algo_14bit (
    input wire clk,
    input wire reset, //active high
    input wire signed [13:0] angle,  // 14-bit input angle 14'sd4096 mapped to pi/2
    output reg signed [13:0] sin_out, // 14-bit sine output (-8191 to +8191)
    output reg signed [13:0] cos_out  // 14-bit cosine output (-8191 to +8191)
);

// Precomputed arctan(2^-i) 
reg signed [13:0] atan_table [0:12];

// Registers for CORDIC pipeline
reg signed [13:0] x[0:12], y[0:12], z[0:12];
integer i;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize atan table (scaled by 8192/pi)
        atan_table[0]  <= 14'd2048;  // atan(2^-0) = 0.785398 rad
        atan_table[1]  <= 14'd1209;  // atan(2^-1) = 0.463648 rad
        atan_table[2]  <= 14'd639;   // atan(2^-2) = 0.244979 rad
        atan_table[3]  <= 14'd324;   // atan(2^-3) = 0.124355 rad
        atan_table[4]  <= 14'd163;   // atan(2^-4) = 0.062419 rad
        atan_table[5]  <= 14'd81;    // atan(2^-5) = 0.031240 rad
        atan_table[6]  <= 14'd41;    // atan(2^-6) = 0.015624 rad
        atan_table[7]  <= 14'd20;    // atan(2^-7) = 0.007812 rad
        atan_table[8]  <= 14'd10;    // atan(2^-8) = 0.003906 rad
        atan_table[9]  <= 14'd5;     // atan(2^-9) = 0.001953 rad
        atan_table[10] <= 14'd3;     // atan(2^-10) = 0.000977 rad
        atan_table[11] <= 14'd1;     // atan(2^-11) = 0.000488 rad
        atan_table[12] <= 14'd1;     // atan(2^-12) = 0.000244 rad
        atan_table[13] <= 14'd0;     // atan(2^-13) = 0.000122 rad
        
        // Reset all pipeline stages
        for (i = 0; i < 13; i = i + 1) begin
            x[i] <= 0;
            y[i] <= 0;
            z[i] <= 0;
        end
        sin_out <= 0;
        cos_out <= 0;
    end else begin
        // Initialize first stage
        x[0] <= 14'd4096;  //Initialize CORDIC with coordinates given by(1,0)
        y[0] <= 0;
        z[0] <= angle;    // z0 = input angle (14-bit)

        // Pipeline stages (13 iterations)
        for (i = 0; i < 13; i = i + 1) begin
            if (z[i][13]) begin  // Check sign bit (for rotation direction)
                x[i+1] <= x[i] + (y[i] >>> i);
                y[i+1] <= y[i] - (x[i] >>> i);
                z[i+1] <= z[i] + atan_table[i];
            end else begin
                x[i+1] <= x[i] - (y[i] >>> i);
                y[i+1] <= y[i] + (x[i] >>> i);
                z[i+1] <= z[i] - atan_table[i];
            end
        end

        // Final output (14-bit sine and cosine)-> last iteration in the pipeline
        sin_out <= y[12];  
        cos_out <= x[12];  
    end
end

endmodule


module tb_cordic_algo();
    reg clk, reset;
    reg signed [13:0] angle;
    wire signed [13:0] sin_out, cos_out;
    
    //Instantiate module
    cordic_algo_14bit dut (
        .clk(clk),
        .reset(reset),
        .angle(angle),
        .sin_out(sin_out),
        .cos_out(cos_out)
    );

    
    //200MHz clock(device specific)
    initial begin
        clk = 0;
        forever #2.5 clk = ~clk;
    end

    initial begin
        reset = 1;
        angle = 0;
        #20 reset = 0;

        // Test angle = -pi/4 (2048 in 14-bit scaling)
        angle = -14'd2048;
        #100;     
        
        $finish;
    end

endmodule