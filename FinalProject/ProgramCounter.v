//////////////////////////////////////////////////////////////////////////////////
// Company: San Diego State University
// Engineer: Andres Martinez Paz
// 
// Create Date:    20:08:42 03/16/2017 
// Design Name: Program counter
// Module Name:    ProgramCounter
// Project Name: 470L Final project 
// Target Devices: FPGA booard
// Tool versions: x.xx
// Description: ProgramCounter register for microarch
//
// Dependencies: None, I guess
//
// Revision: 0.1
// Revision 0.01 - File Created
// Additional Comments: None
//
//////////////////////////////////////////////////////////////////////////////////
module ProgramCounter( input [15:0] PCPrime,
							 input rst,
							 input clk,
							 input write,
							 output reg [15:0] PC);
	
	reg LastWrite = 0;
	reg WriteChanged = 0;
	
	always @(posedge clk) begin
		if (WriteChanged && write) begin	
			case(rst)
				1'b0: PC = PCPrime;
				1'b1: PC = 0;
			endcase
			end
		else WriteChanged = WriteChanged;
		if (write == LastWrite) WriteChanged = 0;
		else begin
			WriteChanged = 1;
			LastWrite = write;
		end
	end

endmodule
