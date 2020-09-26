`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:49:06 06/02/2019 
// Design Name: 
// Module Name:    Volume_Control 
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
module Volume_Control(
	input SYSTEM_RESET,
	input BIT_CLK,
	input [7:0] count_reg,
	input vol_up,
	input vol_down,
	
	output reg [19:0] CMD_ADDR,
	output reg [19:0] CMD_DATA,
	output reg frame_sig,
	output reg [7:0] LED
    );
	 
	reg [1:0] frame_count = 2'b00;
	reg [4:0] vol_reg = 5'b01111;
	
	always @(*)
		casex (vol_reg)
			5'b000_xx: LED = 8'b1111_1111;
			5'b001_xx: LED = 8'b1111_1110;
			5'b010_xx: LED = 8'b1111_1100;
			5'b011_xx: LED = 8'b1111_1000;
			5'b100_xx: LED = 8'b1111_0000;
			5'b101_xx: LED = 8'b1110_0000;
			5'b110_xx: LED = 8'b1100_0000;
			5'b111_xx: LED = 8'b1000_0000;
		endcase
	
	always @(posedge BIT_CLK) begin
		if (SYSTEM_RESET) begin
			frame_count <= 2'b00;
			frame_sig <= 1'b0;
		end else if (count_reg == 255) begin
			if (!(&frame_count))
				frame_count <= frame_count + 1'b1;
			frame_sig <= 1'b1;
		end else
			frame_sig <= 1'b0;
		
		if (vol_down && (vol_reg < 5'b11111)) begin
			vol_reg <= vol_reg + 1'b1;
		end
		
		if (vol_up && (vol_reg > 5'b00000)) begin
			vol_reg <= vol_reg - 1'b1;
		end

		case (frame_count)
			2'b01: 	begin 
							CMD_ADDR <= 20'h04_000;
							CMD_DATA <= 20'b0000_01000_000_01000_000;
						end
			default: begin
							CMD_ADDR <= 20'h18_000;
							CMD_DATA <= {{4{1'b0}}, vol_reg, {3{1'b0}}, vol_reg, {3{1'b0}}};
						end
		endcase
	end	

endmodule
