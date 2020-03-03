`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:08:43 04/11/2017 
// Design Name: 
// Module Name:    SSEGMux 
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
module SSEGMux(input clk,
					input [6:0] digit1,
					input [6:0] digit2,
					input [6:0] digit3,
					input [6:0] digit4,
					output reg [6:0] sseg,
					output reg [3:0] ssegd);

	always @(posedge clk) begin
		case (ssegd) 
			4'b0111: begin
				sseg = digit2;
				ssegd = 4'b1011;
			end
			4'b1011: begin
				sseg = digit3;
				ssegd = 4'b1101;
			end
			4'b1101: begin
				sseg = digit4;
				ssegd = 4'b1110;
			end
			4'b1110: begin
				sseg = digit1;
				ssegd = 4'b0111;
			end
			default: begin
				sseg = digit1;
				ssegd = 4'b0111;
			end
		endcase
	end

endmodule
