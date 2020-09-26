`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:05:03 06/05/2019 
// Design Name: 
// Module Name:    Sin_wave 
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
module Sin_wave(
   input BIT_CLK,
	input [6:0] FP_PERIOD_IN,
	input frame_sig,
	input en,
	output reg [17:0] SN_WAVE,
	output reg [6:0] FP_PERIOD = 7'd48
    );
	
	
	reg [6:0] FRAME_COUNT = 7'b0;
	
	always @(posedge BIT_CLK) begin
		if (FRAME_COUNT == FP_PERIOD)
			FRAME_COUNT <= 7'b0;
		else if (frame_sig)
			FRAME_COUNT <= FRAME_COUNT + 1'b1;
	
		if (frame_sig)
			SN_WAVE <= sin_table[FRAME_COUNT * (18'd89/FP_PERIOD)];
		
		if (en)
			FP_PERIOD <= FP_PERIOD_IN;
	end
	
	
	reg [17:0] sin_table [87:0];
	
	initial begin
		sin_table[0]  = 18'd131071;
		sin_table[1]  = 18'd140422;
		sin_table[2]  = 18'd149724;
		sin_table[3]  = 18'd158932;
		sin_table[4]  = 18'd167998;
		sin_table[5]  = 18'd176876;
		sin_table[6]  = 18'd185520;
		sin_table[7]  = 18'd193887;
		sin_table[8]  = 18'd201934;
		sin_table[9]  = 18'd209619;
		sin_table[10] = 18'd216905;
		sin_table[11] = 18'd223753;
		sin_table[12] = 18'd230128;
		sin_table[13] = 18'd235999;
		sin_table[14] = 18'd241335;
		sin_table[15] = 18'd246110;
		sin_table[16] = 18'd250298;
		sin_table[17] = 18'd253878;
		sin_table[18] = 18'd256833;
		sin_table[19] = 18'd259147;
		sin_table[20] = 18'd260808;
		sin_table[21] = 18'd261809;
		sin_table[22] = 18'd262143;
		sin_table[23] = 18'd261809;
		sin_table[24] = 18'd260808;
		sin_table[25] = 18'd259147;
		sin_table[26] = 18'd256833;
		sin_table[27] = 18'd253878;
		sin_table[28] = 18'd250298;
		sin_table[29] = 18'd246110;
		sin_table[30] = 18'd241335;
		sin_table[31] = 18'd235999;
		sin_table[32] = 18'd230128;
		sin_table[33] = 18'd223753;
		sin_table[34] = 18'd216905;
		sin_table[35] = 18'd209619;
		sin_table[36] = 18'd201934;
		sin_table[37] = 18'd193887;
		sin_table[38] = 18'd185520;
		sin_table[39] = 18'd176876;
		sin_table[40] = 18'd167998;
		sin_table[41] = 18'd158932;
		sin_table[42] = 18'd149724;
		sin_table[43] = 18'd140422;
		sin_table[44] = 18'd131071;
		sin_table[45] = 18'd121720;
		sin_table[46] = 18'd112418;
		sin_table[47] = 18'd103210;
		sin_table[48] = 18'd094144;
		sin_table[49] = 18'd085266;
		sin_table[50] = 18'd076622;
		sin_table[51] = 18'd068255;
		sin_table[52] = 18'd060208;
		sin_table[53] = 18'd052523;
		sin_table[54] = 18'd045237;
		sin_table[55] = 18'd038389;
		sin_table[56] = 18'd032014;
		sin_table[57] = 18'd026143;
		sin_table[58] = 18'd020807;
		sin_table[59] = 18'd016032;
		sin_table[60] = 18'd011844;
		sin_table[61] = 18'd008264;
		sin_table[62] = 18'd005309;
		sin_table[63] = 18'd002995;
		sin_table[64] = 18'd001334;
		sin_table[65] = 18'd000333;
		sin_table[66] = 18'd000000;
		sin_table[67] = 18'd000333;
		sin_table[68] = 18'd001334;
		sin_table[69] = 18'd002995;
		sin_table[70] = 18'd005309;
		sin_table[71] = 18'd008264;
		sin_table[72] = 18'd011844;
		sin_table[73] = 18'd016032;
		sin_table[74] = 18'd020807;
		sin_table[75] = 18'd026143;
		sin_table[76] = 18'd032014;
		sin_table[77] = 18'd038389;
		sin_table[78] = 18'd045237;
		sin_table[79] = 18'd052523;
		sin_table[80] = 18'd060208;
		sin_table[81] = 18'd068255;
		sin_table[82] = 18'd076622;
		sin_table[83] = 18'd085266;
		sin_table[84] = 18'd094144;
		sin_table[85] = 18'd103210;
		sin_table[86] = 18'd112418;
		sin_table[87] = 18'd121720;
	end


endmodule
