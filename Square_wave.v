`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:31:28 06/01/2019 
// Design Name: 
// Module Name:    Square_wave 
// Description: 
//
//////////////////////////////////////////////////////////////////////////////////

module Square_wave(
	input BIT_CLK,
	input [6:0] FP_PERIOD_IN,
	input frame_sig,
	input en,
	output reg [17:0] SQ_WAVE,
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
	end
	
	always @(*)
		case (FRAME_COUNT >= FP_PERIOD / 7'd2)
			1'b0: SQ_WAVE = 18'b00_0000_0000_0000_0000;
			1'b1: SQ_WAVE = 18'b11_1111_1111_1111_1111;
		endcase

endmodule
