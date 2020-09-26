`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Bryan Munoz & Kenneth Mai
// 
// Create Date:    14:41:56 04/29/2019 
// Design Name: 
// Module Name:    Debounce_Count
// Description: 
//
//////////////////////////////////////////////////////////////////////////////////
module Debounce_Count(
	input enable,
			clk,
	
	output zero
    );
	 
	reg [15:0] count_reg;

	always @(posedge clk)
		case(enable)
			1'b0:	count_reg <= 16'hFFFF;
			1'b1: count_reg <= count_reg - 1'b1;
		endcase
		
	assign zero = !(|count_reg);
	
endmodule
