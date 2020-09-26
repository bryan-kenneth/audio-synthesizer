`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:01:54 06/01/2019 
// Design Name: 
// Module Name:    Lab5_Top 
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
module Lab5_Top(
	input gclk,
	input BIT_CLK,
	input SDATA_IN,
	input SYSTEM_RESET,
	input BTNL,
	input BTNR,
	input BTNU, 
	input BTND,
	input [3:0] SW,
	output [7:0] LED,
	output SYNC,
	output SDATA_OUT,
	output RESET
    );
	
	wire frame_sig;
	wire [19:0] CMD_ADDR, CMD_DATA;
	wire [17:0] PCM_LR;
	wire D_BTNL, D_BTNR, D_BTNU, D_BTND, D_SYSTEM_RESET;
	wire [7:0] count_reg;
	wire [3:0] D_SW;
	
	Divide_clk new_clk (.gclk(gclk), .clk(CLK));
	
	Debouncer_FSM deb_reset (.clk(BIT_CLK), .sig_in(!SYSTEM_RESET), .sig_out(D_SYSTEM_RESET));
	
	//Debounce SWs
	SW_Debouncer deb_sw [3:0] (.clk(BIT_CLK), .sig_in(SW), .sig_out(D_SW));
	
	//Volume Control
	Debouncer_FSM deb_L (.clk(BIT_CLK), .sig_in(BTNL), .sig_out(D_BTNL));
	Debouncer_FSM deb_R (.clk(BIT_CLK), .sig_in(BTNR), .sig_out(D_BTNR));
	Volume_Control VC (.BIT_CLK			(BIT_CLK), 
					   .SYSTEM_RESET	(D_SYSTEM_RESET), 
					   .count_reg		(count_reg), 
					   .frame_sig		(frame_sig), 
					   .vol_up			(D_BTNR),
					   .vol_down		(D_BTNL), 
					   .CMD_ADDR		(CMD_ADDR), 
					   .CMD_DATA		(CMD_DATA), 
					   .LED				(LED)
					   );
	
	//Frequency Control
	Debouncer_FSM deb_U (.clk(BIT_CLK), .sig_in(BTNU), .sig_out(D_BTNU));
	Debouncer_FSM deb_D (.clk(BIT_CLK), .sig_in(BTND), .sig_out(D_BTND));
	
	Mix_Controller MC (.BIT_CLK		(BIT_CLK), 
				      .SW			(D_SW), 
				      .frame_sig	(frame_sig), 
				      .freq_up		(D_BTNU), 
				      .freq_down	(D_BTND), 
				      .PCM_LR		(PCM_LR)
				      );

	//Output to codec
	ac97_controller test (.SYSCLK(CLK), .SYSTEM_RESET(D_SYSTEM_RESET), .PCM_LR({2'b00, PCM_LR}), .BIT_CLK(BIT_CLK), .SDATA_IN(SDATA_IN),
								 .CMD_ADDR(CMD_ADDR), .CMD_DATA(CMD_DATA), .count_reg(count_reg), .SYNC(SYNC), .SDATA_OUT(SDATA_OUT), .RESET(RESET));
	 
endmodule
