`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:01:15 06/04/2019 
// Design Name: 
// Module Name:    Sawtooth_wave  
// Description: 
//
//////////////////////////////////////////////////////////////////////////////////

module Sawtooth_wave(
	input BIT_CLK,
	input [6:0] FP_PERIOD_IN,
	input frame_sig,
	input en,
	output reg [17:0] ST_WAVE,
	output reg [6:0] FP_PERIOD = 7'd48
    );

	reg [6:0] FRAME_COUNT = 7'b0;
	
	always @(posedge BIT_CLK) begin
		if (FRAME_COUNT == FP_PERIOD)
			FRAME_COUNT <= 7'b0;
		else if (frame_sig)
			FRAME_COUNT <= FRAME_COUNT + 1'b1;
		
		if (en)
			FP_PERIOD <= FP_PERIOD_IN;
			
		if (frame_sig)
			case (FRAME_COUNT != 7'd0)
				1'b0: ST_WAVE <= 18'b00_0000_0000_0000_0000;
				1'b1: ST_WAVE <= ST_WAVE + (18'b11_1111_1111_1111_1111 / FP_PERIOD);
			endcase
	end
endmodule
