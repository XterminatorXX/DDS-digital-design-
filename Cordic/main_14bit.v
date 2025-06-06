`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Internship
// Engineer: Aniruddh Pandav
// 
// Create Date: 06/02/2025 07:36:43 PM
// Design Name: 
// Module Name: main_phase
// Project Name: Cordic_algo
// Target Devices: RF-SOC 
// Tool Versions: Version 1
// Description: Module to connect phase accumulator with CORDIC algorithm for generation of sine and cosine waves
// Dependencies: Instantiate the module of cordic algorithm
// Additional Comments:
// - a FSM based approach for implementing quarter wave phase accumulator
// - pipelined structure, latency=no of CORDIC iterations 
// - no requirement of exteral modules/ block memory
// - single clock based module 
// -(DAC specific) Its 14 bit in this case , might change according to users board. 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module main_phase_14bit(
    input wire signed [13:0] M,          // 14-bit frequency control word
    input clk,
    input rst, //active high
    output reg signed [13:0] sin_out,    // 14-bit sine output
    output reg signed [13:0] cos_out,    // 14-bit cosine output
    output reg signed [13:0] phase_acc,  //phase accumulator value, later acts as input to cordic algorithm module
    output reg [1:0] state //state for FSM 
);

//temp wires for cordic output
wire signed [13:0] sin_out_temp; 
wire signed [13:0] cos_out_temp; 

// Instantiate 14-bit CORDIC module
cordic_algo_14bit mod_1(
    .clk(clk),
    .reset(rst),
    .angle(phase_acc),      // 14-bit phase input
    .sin_out(sin_out_temp), // 14-bit sine output
    .cos_out(cos_out_temp)  // 14-bit cosine output
);
   
parameter n = 14'sd4096;; // pi/2 for logic of phase accumulator
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11; //S0->1st quadrant S1->2nd quadrant S2->3rd quadrant S3->4th quadrant
reg [1:0] state_pipeline [0:13];  // 14-stage shift register pipeline for state synchronization


always @(posedge clk) begin
    //reset state and accumulator
    if(rst) begin
        state <= S0;
        phase_acc <= 0;
        for (integer i = 0; i < 14; i = i + 1)
            state_pipeline[i] <= S0;
    end
    else begin
        // Shift the state through the pipeline
        state_pipeline[0] <= state;
        for (integer i = 1; i < 14; i = i + 1)
            state_pipeline[i] <= state_pipeline[i-1];
        
        // Phase accumulator state machine
        case (state)
            S0: if (phase_acc + M > 14'sd4096) begin  //quadrant change condition
                    state <= S1;
                    phase_acc <= n + n - phase_acc - M;
                end
                else phase_acc <= phase_acc + M; 
                
            S1: if (phase_acc - M < 14'sd0) begin  //quadrant change condition
                    state <= S2;
                    phase_acc <= phase_acc - M;
                end
                else phase_acc <= phase_acc - M;
                
            S2: if (phase_acc - M < -14'sd4096) begin  //quadrant change condition
                    state <= S3;
                    phase_acc <= -n - n - phase_acc + M;
                end
                else phase_acc <= phase_acc - M;
                
            S3: if (phase_acc + M > 14'sd0) begin  //quadrant change condition
                    state <= S0;
                    phase_acc <= phase_acc + M;
                end
                else phase_acc <= phase_acc + M;
        endcase
        
        
        sin_out <= sin_out_temp ;
        // Handle quadrant correction since cosine is always positive in cordic algorithm(-pi/2 to pi/2)
        if (state_pipeline[13] == S0 || state_pipeline[13] == S3)
            cos_out <= cos_out_temp ;
        else
            cos_out <= -cos_out_temp;
    end
end

endmodule


module main_phase_14bit_tb;

  // Inputs
  reg signed [13:0] M;
  reg clk;
  reg rst;

  // Outputs
  wire signed [13:0] sin_out, cos_out;
  wire signed [13:0] phase_acc;
  wire [1:0] state;

  // Instantiate the Unit Under Test (UUT)
  main_phase_14bit uut (
    .M(M),
    .clk(clk),
    .rst(rst),
    .sin_out(sin_out),
    .cos_out(cos_out),
    .phase_acc(phase_acc),
    .state(state)
  );

  // Clock generation
  always #2.5 clk = ~clk;  // 200 MHz

  // Initial stimulus
  initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;
    M = 14'd200;    // phase step
    
    // Release reset after 10ns
    #10 rst = 0;
    
    // Run simulation
    #1000;
    $finish;
  end
endmodule