`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:30:03 04/27/2017 
// Design Name: 
// Module Name:    InstructionMem 
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
module InstructionMem #(parameter NumOfInstructions = 40)
							(input [7:0] Address,
							 output reg [15:0] ReadData);

	reg [15:0] InstrMem [NumOfInstructions - 1:0];
	
	initial begin
		$readmemh("prog.dat", InstrMem);
	end

	always @* begin
		if (Address < NumOfInstructions) ReadData = InstrMem[Address];
		else ReadData = 0;
	end
endmodule
