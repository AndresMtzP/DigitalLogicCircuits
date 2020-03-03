//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer: Andres Martinez Paz
// 
// Create Date:    20:08:42 03/16/2017 
// Design Name: 16bit multiplexer
// Module Name:    Mux16 
// Project Name: 470L Final project 
// Target Devices: FPGA booard
// Tool versions: x.xx
// Description: Basic 16 bit multiplexer to be used in architecture
//
// Dependencies: None, I guess
//
// Revision: 0.1
// Revision 0.01 - File Created
// Additional Comments: None
//
//////////////////////////////////////////////////////////////////////////////////
module Mux16(  input [15:0] in0,
					input [15:0] in1,
					input sel,
					output reg [15:0] out);

	always @(*)
		case (sel)
			1'b0: out = in0;
			1'b1: out = in1;
		endcase

endmodule
