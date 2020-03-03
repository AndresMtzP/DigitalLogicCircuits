//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer: Andres Martinez Paz
// 
// Create Date:    20:08:42 03/16/2017 
// Design Name: PCPlus1
// Module Name:    PCPlus1
// Project Name: 470L Final project 
// Target Devices: FPGA booard
// Tool versions: x.xx
// Description: ProgramCounter incrementer
//
// Dependencies: None, I guess
//
// Revision: 0.1
// Revision 0.01 - File Created
// Additional Comments: None
//
//////////////////////////////////////////////////////////////////////////////////
module PCPlus1( input [15:0] PC,
					 output [15:0] PCPlus1);

	assign PCPlus1 = PC + 1;

endmodule
