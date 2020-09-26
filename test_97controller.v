`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:28:32 06/06/2019
// Design Name:   ac97_controller
// Module Name:   C:/Users/bmunozga/Desktop/CMPE125_LAB5/test_97controller.v
// Project Name:  CMPE125_LAB5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ac97_controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_97controller;

	// Inputs
	reg SYSCLK;
	reg SYSTEM_RESET;
	reg [19:0] PCM_LR;
	reg [19:0] CMD_ADDR;
	reg [19:0] CMD_DATA;
	reg BIT_CLK;
	reg SDATA_IN;

	// Outputs
	wire [7:0] count_reg;
	wire SYNC;
	wire SDATA_OUT;
	wire RESET;

	// Instantiate the Unit Under Test (UUT)
	ac97_controller uut (
		.SYSCLK(SYSCLK), 
		.SYSTEM_RESET(SYSTEM_RESET), 
		.PCM_LR(PCM_LR), 
		.CMD_ADDR(CMD_ADDR), 
		.CMD_DATA(CMD_DATA), 
		.count_reg(count_reg), 
		.BIT_CLK(BIT_CLK), 
		.SDATA_IN(SDATA_IN), 
		.SYNC(SYNC), 
		.SDATA_OUT(SDATA_OUT), 
		.RESET(RESET)
	);

	initial begin
		// Initialize Inputs
		SYSCLK = 0;
		SYSTEM_RESET = 0;
		PCM_LR = 0;
		CMD_ADDR = 0;
		CMD_DATA = 0;
		BIT_CLK = 0;
		SDATA_IN = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	initial begin
		forever begin
			#5 BIT_CLK = !BIT_CLK;
		end
	end
      
endmodule

