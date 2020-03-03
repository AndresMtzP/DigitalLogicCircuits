`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:16:18 04/11/2017 
// Design Name: 
// Module Name:    muxClock 
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
module muxClock(input inClk,
					 output reg outClk);
	
	reg [9:0] counter = 0;
	
	always @(posedge inClk) begin
		if (counter >= 1000) begin
			outClk = ~outClk;
			counter = 0;
		end else counter = counter + 1;
	end

endmodule
