`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:05:15 06/01/2019 
// Design Name: 
// Module Name:    ac97_controller 

//////////////////////////////////////////////////////////////////////////////////

module ac97_controller(
	//Internal Interface
	input SYSCLK, //up to 125MHz
	input SYSTEM_RESET,
	input [19:0] PCM_LR,
	input [19:0] CMD_ADDR,
	input [19:0] CMD_DATA,
	output reg [7:0] count_reg,
	
	//External Interface connected to AC'97
	input BIT_CLK, //12.288 MHz
	input SDATA_IN,
	output reg SYNC,
	output reg SDATA_OUT,
	output reg RESET
    );
	 
	initial count_reg = 7'b0;
	 
	reg [5:0] reset_count = 6'b0;
	
	// initialize codec / check system reset
	always @(posedge SYSCLK) begin
		if (SYSTEM_RESET) begin
			reset_count <= 0;
			RESET <= 1'b0;
		end else if (reset_count == 32) begin
			RESET <= 1'b1;
			reset_count <= 6'd32;
		end else
			reset_count <= reset_count + 1'b1;
	end
	
	// validate frame and necessary slots
	always @(posedge BIT_CLK) begin
		if ((count_reg >= 0) && (count_reg <= 15)) begin
			case (count_reg[3:0])
				4'h0:		SDATA_OUT <= 1'b1; // frame
				4'h1:		SDATA_OUT <= 1'b1; // command addr
				4'h2:		SDATA_OUT <= 1'b1; // command data
				4'h3:		SDATA_OUT <= 1'b1; // left input
				4'h4:		SDATA_OUT <= 1'b1; // right input
				default: SDATA_OUT <= 1'b0;
			endcase
		end
		
		// output command address
		else if ((count_reg >= 16) && (count_reg <= 35))
			SDATA_OUT <= CMD_ADDR[35 - count_reg];
		// output command data
		else if ((count_reg >= 36) && (count_reg <= 55))
			SDATA_OUT <= CMD_DATA[55 - count_reg];
		// output left PCM data
		else if ((count_reg >= 56) && (count_reg <= 75))
			SDATA_OUT <= PCM_LR[75 - count_reg];
		// output right PCM data
		else if ((count_reg >= 76) && (count_reg <= 95))
			SDATA_OUT <= PCM_LR[95 - count_reg];
		// ignore rest of frame
		else
			SDATA_OUT <= 1'b0;
		
		// generate sync signal
		if (count_reg == 255)
			SYNC <= 1'b1;
		else if (count_reg == 16)
			SYNC <= 1'b0;
		
		count_reg <= count_reg + 1'b1;
		end
	
	
endmodule
