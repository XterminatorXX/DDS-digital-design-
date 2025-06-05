//////////////////////////////////////////////////////////////////////////////////
// Internship
// Engineer:  Aniruddh Pandav
// Board:Confidential
// Create Date:    06/01/2025
// Design Name:    Full Sine Wave Generator (DDS)
// Module Name:    full_sine
// Project Name:   DDS Sine/Cosine Generator
// Tool Versions:  [e.g., Vivado 2020.2]
// Description: 
//     This module implements a Direct Digital Synthesizer (DDS) that generates
//     sine and cosine outputs using a phase accumulator and LUT (ROM).
// 
// Dependencies:
//     - Requires pre-initialized `blk_mem_gen_0` block memory with 4096 samples
//       generated in MATLAB and stored in .coe format
//
// Revision:       1.0
// Additional Comments:
//     - Phase accumulator bit width: 12
//     - Output sample width: 14 (signed)
//     - Frequency control via input word `M`
//        
//////////////////////////////////////////////////////////////////////////////////

module full_sine(
    input [11:0] M,          // 12-bit frequency tuning word
    input clk,
    input rst,
    output reg signed [13:0] sin_out,  // 14-bit signed sine output
    output reg signed [13:0] cos_out,  // 14-bit signed cosine output
    output reg [11:0] phase_acc        // 12-bit phase accumulator
);

wire signed [13:0] out, out_cos;

// Sine LUT (12-bit address, 14-bit output)
blk_mem_gen_0 lut_sin (
    .clka(clk),
    .addra(phase_acc),      // 12-bit address
    .douta(out)             // 14-bit output
);

// Cosine LUT (90 degrees phase offset = 1024 addresses)
blk_mem_gen_0 lut_cos (
    .clka(clk),
    .addra(phase_acc + 12'd1024),  
    .douta(out_cos)
);

always @(posedge clk) begin 
    sin_out <= out;
    cos_out <= out_cos;
    if (!rst) 
        phase_acc <= 0;
    else 
        phase_acc <= phase_acc + M;
end
endmodule

`timescale 1ns / 1ps

module full_sine_tb;
    // Inputs
    reg [11:0] M;     // 12-bit
    reg clk;
    reg rst;

    // Outputs
    wire signed [13:0] sin_out;
    wire signed [13:0] cos_out;
    wire [11:0] phase_acc;

    // Instantiate DDS
    full_sine uut (
        .M(M),
        .clk(clk),
        .rst(rst),
        .sin_out(sin_out),
        .cos_out(cos_out),
        .phase_acc(phase_acc)
    );

    // 200 MHz clock
    initial clk = 0;
    always #2.5 clk = ~clk; 

    initial begin
        // Initialize
        M = 12'd64;   // (M/2^N)*fclk=f_out =3.125 MHz
        rst = 0;

        // Reset pulse
        #20 rst = 1;

        // Run for 1000 ns
        #1000 $finish;
    end
endmodule