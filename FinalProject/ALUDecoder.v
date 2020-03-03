`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:04:29 03/31/2017 
// Design Name: 
// Module Name:    ALUDecoder 
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
module ALUDecoder( input [2:0] Funct,
						 input [1:0] ALUOp,
						 output reg [2:0] ALUControl);

	////////////////////////////
	// Funct codes to ALU operation
	//
	// 3'b000  ->  and
	// 3'b001  ->  or
	// 3'b010  ->  add
	// 3'b011  ->  xor
	// 3'b100  ->  sll
	// 3'b101  ->  mult
	// 3'b110  ->  sub
	// 3'b111  ->  slt
	//
	///////////////////////////

	always @* 
		case (ALUOp)
			2'b00: ALUControl = 3'b010;  // send addition code to ALUControl signal
			2'b01: ALUControl = 3'b110;  // send subtraction code to 
			default: ALUControl = Funct; // send Funct code to ALUControl
		endcase
		
endmodule
