`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Bryan Munoz & Kenneth Mai
// 
// Create Date:    04/29/2019 
// Design Name: 
// Module Name:    Debouncer_FSM
// Description: 
//
//////////////////////////////////////////////////////////////////////////////////
module Debouncer_FSM(
	input clk,
			sig_in,
	
	output reg sig_out
    );
	 
	// states
	parameter Idle  = 2'b00;
	parameter Count = 2'b01;
	parameter Pulse = 2'b10;
	parameter Hold  = 2'b11;

	// generating count down signal
	wire enable, zero;
	Debounce_Count DC(.clk(clk), .enable(enable), .zero(zero));

	reg [1:0] state, next;
	
	// state register
	always @(posedge clk)
		state <= next;

	// next-state and output logic
	always @(*) begin
		case (state)
			Idle:
				begin
					sig_out = 1'b0;
					if (sig_in)
						next = Count;
					else
						next = Idle;
				end
				
			Count:
				begin
					sig_out = 1'b0;
					if (!sig_in)
						next = Idle;
					else if (zero)
						next = Pulse;
					else
						next = Count;
				end
					
			Pulse:
				begin
					sig_out = 1'b1;
					next = Hold;
				end
			
			Hold:
				begin
					sig_out = 1'b0;
					if (!sig_in)
						next = Idle;
					else
						next = Hold;
				end
				
			default:
				begin
					sig_out = 1'b0;
					next = Idle;
				end
				
		endcase
	end
	
	assign enable = (state == Count);
	
endmodule