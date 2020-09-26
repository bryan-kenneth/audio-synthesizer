`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:30:07 06/05/2019 
// Design Name: 
// Module Name:    Cust_wave 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Cust_wave(
	input BIT_CLK,
	input [6:0] DELAY_SCALE_IN,
	input frame_sig,
	input en,
	output reg [17:0] C_WAVE,
	output reg [6:0] DELAY_SCALE
    );
	 
	reg [6:0] FRAME_COUNT = 7'b0;
	reg [6:0] DELAY_COUNT = 7'b0;
	reg [3:0] DELAY_MAG = 4'b0;
	reg [2:0] NOTE_COUNT = 3'b0;
	
	always @(posedge BIT_CLK) begin
		if (FRAME_COUNT == NOTE_PERIOD) begin
			FRAME_COUNT <= 7'b0;
			DELAY_COUNT <= DELAY_COUNT + 1'b1;
			if (DELAY_COUNT == DELAY_SCALE) begin
				DELAY_COUNT <= 7'b0;
				DELAY_MAG <= DELAY_MAG + 1'b1;
				if (&DELAY_MAG)
					NOTE_COUNT <= NOTE_COUNT + 1'b1;
			end
		end else if (frame_sig)
			FRAME_COUNT <= FRAME_COUNT + 1'b1;
		
		if (en)
			DELAY_SCALE = DELAY_SCALE_IN;
	end
	
	reg [6:0] NOTE_PERIOD;
	
	always @(*)
		case (NOTE_COUNT)
			3'b000: NOTE_PERIOD = 7'd48;
			3'b001: NOTE_PERIOD = 7'd40;
			3'b010: NOTE_PERIOD = 7'd36;
			3'b011: NOTE_PERIOD = 7'd48;
			3'b100: NOTE_PERIOD = 7'd40;
			3'b101: NOTE_PERIOD = 7'd36;
			3'b110: NOTE_PERIOD = 7'd48;
			3'b111: NOTE_PERIOD = 7'd40;
		endcase
	
	always @(*)
		case (FRAME_COUNT >= NOTE_PERIOD / 7'd2)
			1'b0: C_WAVE = 18'b00_0000_0000_0000_0000;
			1'b1: C_WAVE = 18'b11_1111_1111_1111_1111;
		endcase

endmodule
