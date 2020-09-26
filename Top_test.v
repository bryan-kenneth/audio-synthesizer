`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:50:28 06/04/2019
// Design Name:   Lab5_Top
// Module Name:   C:/Users/bmunozga/Desktop/CMPE125_LAB5/top_test.v
// Project Name:  CMPE125_LAB5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Lab5_Top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_test;

	// Inputs
	reg gclk;
	reg BIT_CLK;
	reg SDATA_IN;
	reg SYSTEM_RESET;
	reg BTNL;
	reg BTNR;
	reg BTNU;
	reg BTND;
	reg [1:0] SW;

	// Outputs
	wire SYNC;
	wire SDATA_OUT;
	wire RESET;

	// Instantiate the Unit Under Test (UUT)
	Lab5_Top uut (
		.gclk(gclk), 
		.BIT_CLK(BIT_CLK), 
		.SDATA_IN(SDATA_IN), 
		.SYSTEM_RESET(SYSTEM_RESET), 
		.BTNL(BTNL), 
		.BTNR(BTNR), 
		.BTNU(BTNU), 
		.BTND(BTND), 
		.SW(SW), 
		.SYNC(SYNC), 
		.SDATA_OUT(SDATA_OUT), 
		.RESET(RESET)
	);

	initial begin
		// Initialize Inputs
		gclk = 0;
		BIT_CLK = 0;
		SDATA_IN = 0;
		SYSTEM_RESET = 0;
		BTNL = 0;
		BTNR = 0;
		BTNU = 0;
		BTND = 0;
		SW = 0;

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

