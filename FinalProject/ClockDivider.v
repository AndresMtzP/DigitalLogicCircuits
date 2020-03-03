`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:50:58 04/30/2017 
// Design Name: 
// Module Name:    ClockDivider 
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
module ClockDivider(input inClk,
					 output reg outClk);
	
	reg [12:0] counter = 0;
	
	always @(posedge inClk) begin
		if (counter >= 8000) begin
			outClk = ~outClk;
			counter = 0;
		end else counter = counter + 1;
	end

endmodule
