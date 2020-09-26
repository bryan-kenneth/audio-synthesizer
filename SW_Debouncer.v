`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:17:26 06/05/2019 
// Design Name: 
// Module Name:    SW_Debouncer 
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
module SW_Debouncer(
input clk,
			sig_in,
	
	output reg sig_out
    );
	 
	// states
	parameter Low = 1'b0;
	parameter High = 1'b1;


	// generating count down signal
	wire zero_th, zero_tl;
	Debounce_Count DC_h(.clk(clk), .enable(sig_in), .zero(zero_th));
	Debounce_Count DC_l(.clk(clk), .enable(!sig_in), .zero(zero_tl));

	reg state, next;
	
	// state register
	always @(posedge clk)
		state <= next;

	// next-state and output logic
	always @(*) begin
		case (state)
			Low:
				begin
					sig_out = 1'b0;
					if (zero_th)
						next = High;
					else
						next = Low;
				end
				
			High:
					begin
					sig_out = 1'b1;
					if (zero_tl)
						next = Low;
					else
						next = High;
				end
				
			default:
				begin
					sig_out = 1'b0;
					next = Low;
				end
				
		endcase
	end
	
endmodule
