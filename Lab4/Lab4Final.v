`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:10:01 02/27/2017 
// Design Name: 
// Module Name:    Lab4Final 
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
module Lab4Final( input M_CLOCK,
						input [3:0] IO_PB,			//Input push buttons on IOboard
						input [7:0] IO_DSW,			//Input dip switches on IOBoard
						input inPin,
						output IO_OUT, 	// output to IO board LEDs
						output [7:0] IO_SSEG,  // IO Board 7 Seg
						output [3:0] IO_SSEGD, // 7 seg Digits
						output IO_SSEG_COL,
						output [7:0] IO_LED);

	//==================================
	// instantiate transmitter
	Lab4TX tx00 (
		.M_CLOCK(M_CLOCK),
		.IO_PB(IO_PB),
		.IO_DSW(IO_DSW),
		.IO_LED(IO_OUT)
	);
	
	//==================================
	// instantiate receiver
	Lab4RX rx00 (
		.M_CLOCK(M_CLOCK),
		.inPin(inPin),
		.IO_LED(IO_LED)
	);


	//==================================
	//Turn off seven segment display
	assign IO_SSEG = 8'b11111111;
	assign IO_SSEGD = 4'b1111;
	assign IO_SSEG_COL = 1'b1;
	
endmodule
