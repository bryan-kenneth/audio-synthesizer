`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:04:12 06/04/2019 
// Design Name: 
// Module Name:    Mix_Controller 
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
module Mix_Controller(
	input BIT_CLK,
	input freq_up,
	input freq_down,
	input [3:0] SW,
	input frame_sig,
	
	output [17:0] PCM_LR
    );
	 
	//Freq Control
	reg [6:0] FRAME_COUNT = 7'b0;
	reg [6:0] FRAMES_PER_PERIOD = 7'd48;
	
	always @(posedge BIT_CLK) begin
		FIFO_push <= 1'b0;
		if (sel != p_sel) begin
			case (sel)
				4'b0001: FRAMES_PER_PERIOD <= FP_PERIOD_STORED[0];
				4'b0010: FRAMES_PER_PERIOD <= FP_PERIOD_STORED[1];
				4'b0100: FRAMES_PER_PERIOD <= FP_PERIOD_STORED[2];
				4'b1000: FRAMES_PER_PERIOD <= FP_PERIOD_STORED[3];
				default: FRAMES_PER_PERIOD <= 7'd48;
			endcase
		end
		
		if ((SW > P_SW) && (sel != FIFO[0])) // prevent duplicates pushed
			FIFO_push <= 1'b1;
		
		if (freq_up && (FRAMES_PER_PERIOD >= 7'd8))
			FRAMES_PER_PERIOD <= FRAMES_PER_PERIOD - 7'd4;
		
		if (freq_down && (FRAMES_PER_PERIOD <= 7'd88))
			FRAMES_PER_PERIOD <= FRAMES_PER_PERIOD + 7'd4;
			
		if (FIFO_push) begin
			FIFO[4] <= FIFO[3];
			FIFO[3] <= FIFO[2];
			FIFO[2] <= FIFO[1];
			FIFO[1] <= FIFO[0];
			FIFO[0] <= sel;
			FIFO_push <= 1'b0;
		end
		P_SW <= SW;
		p_sel <= sel;
	end
	
	// FIFO for selector
	reg [3:0] FIFO [4:0];
	initial FIFO[0] = 4'b0000;
	reg FIFO_push;
	reg [3:0] sel, p_sel; 
	reg [3:0] P_SW = 4'd0;
	
	always @(posedge BIT_CLK) begin
		if (SW != P_SW) begin
			if (SW > P_SW)
				sel = SW ^ P_SW;
			else begin
				sel = SW & sel;
				if (sel == 4'd0) sel = SW & FIFO[0];
				if (sel == 4'd0) sel = SW & FIFO[1];
				if (sel == 4'd0) sel = SW & FIFO[2];
				if (sel == 4'd0) sel = SW & FIFO[3];
				if (sel == 4'd0) sel = SW & FIFO[4];
			end
		end
	end
	 
	// Waves
	wire [17:0] SQ_WAVE, ST_WAVE, SN_WAVE, C_WAVE;
	wire [6:0] FP_PERIOD_STORED [3:0];
	
	Square_wave sq_wave 	 (.BIT_CLK(BIT_CLK), .frame_sig(frame_sig), .en(sel[0]), .FP_PERIOD_IN(FRAMES_PER_PERIOD), .SQ_WAVE(SQ_WAVE), .FP_PERIOD(FP_PERIOD_STORED[0]));
	Sawtooth_wave st_wave (.BIT_CLK(BIT_CLK), .frame_sig(frame_sig), .en(sel[1]), .FP_PERIOD_IN(FRAMES_PER_PERIOD), .ST_WAVE(ST_WAVE), .FP_PERIOD(FP_PERIOD_STORED[1]));
	Sin_wave	sn_wave 		 (.BIT_CLK(BIT_CLK), .frame_sig(frame_sig), .en(sel[2]), .FP_PERIOD_IN(FRAMES_PER_PERIOD), .SN_WAVE(SN_WAVE), .FP_PERIOD(FP_PERIOD_STORED[2]));
	Cust_wave c_wave 		 (.BIT_CLK(BIT_CLK), .frame_sig(frame_sig), .en(sel[3]), .DELAY_SCALE_IN(FRAMES_PER_PERIOD), .C_WAVE(C_WAVE), .DELAY_SCALE(FP_PERIOD_STORED[3]));
	
	wire [3:0] sw_sum;
	wire [17:0] num_waves;
	assign sw_sum = {3'b000, SW[3]} + {3'b000, SW[2]} + {3'b000, SW[1]} + {3'b000, SW[0]};
	assign num_waves = {{14{1'b0}}, sw_sum};
	assign PCM_LR = ((C_WAVE & {18{SW[3]}}) / num_waves) + ((SN_WAVE & {18{SW[2]}}) / num_waves) +
						 ((ST_WAVE & {18{SW[1]}}) / num_waves) + ((SQ_WAVE & {18{SW[0]}}) / num_waves);

endmodule
