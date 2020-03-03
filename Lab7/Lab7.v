`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:02:35 04/03/2017 
// Design Name: 
// Module Name:    Lab7 
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
module Lab7(input M_CLOCK,
				input [3:0] IO_PB,
				input [7:0] IO_DSW,
				output [7:0] IO_LED,
				output [7:0] IO_SSEG,
				output [3:0] IO_SSEGD,
				output IO_SSEG_COL,
				output reg outPin);

	wire clk1;
	wire clk2;
	wire clk3;
	
	SuperCoolClk sck00 (.CLK_IN1(M_CLOCK),
							  .RESET(~IO_PB[0]),
							  .CLK_OUT1(clk1),
							  .CLK_OUT2(clk2),
							  .CLK_OUT3(clk3));
							  
	always @* begin
		case (IO_PB[3:1])
			3'b111: outPin = clk1;
			3'b110: outPin = clk2;
			3'b101: outPin = clk3;
			default: outPin = 1'b1;
		endcase
	end
	
	assign IO_LED = IO_DSW;
	assign IO_SSEG = 8'b11111111;
	assign IO_SSEGD = 4'b1111;
	assign IO_SSEG_COL = 1'b1;

endmodule
