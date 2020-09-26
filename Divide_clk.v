`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// 
// Create Date:    04/29/2019 
// Design Name: 
// Module Name:    Divide_clk 
// Description: 
//
//////////////////////////////////////////////////////////////////////////////////
module Divide_clk(
	input gclk,
	output clk
    );

	IBUFG gclkin_buf (.O(clk_in), .I(gclk));
	DCM_SP clk_divider (.CLKFB(feedback_clk2),
							  .CLKIN(clk_in),
							  .CLKDV(divided_clk),
							  .CLK0(feedback_clk),
							  .PSEN(1'b0),
							  .LOCKED(locked_int),
							  .RST(1'b0));
								
	defparam clk_divider.CLKDV_DIVIDE = 4.0;
	defparam clk_divider.CLKIN_PERIOD = 10.0;
	defparam clk_divider.CLK_FEEDBACK = "1X";
	defparam clk_divider.CLKIN_DIVIDE_BY_2 = "FALSE";
	defparam clk_divider.CLKOUT_PHASE_SHIFT = "NONE";
	defparam clk_divider.DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
	defparam clk_divider.DFS_FREQUENCY_MODE = "LOW";
	defparam clk_divider.DLL_FREQUENCY_MODE = "LOW";
	defparam clk_divider.DSS_MODE = "NONE";
	defparam clk_divider.DUTY_CYCLE_CORRECTION = "TRUE";
	defparam clk_divider.PHASE_SHIFT = 0;
	defparam clk_divider.STARTUP_WAIT = "FALSE";
	defparam clk_divider.FACTORY_JF = 16'hC080;
	
	BUFG feedback_BUFG (.I(feedback_clk), .O(feedback_clk2));
	// we will use clk for all flip-flops
	BUFG out_BUFG (.I(divided_clk), .O(clk));

endmodule
