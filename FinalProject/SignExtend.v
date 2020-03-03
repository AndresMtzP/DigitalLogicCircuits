//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:21:22 03/17/2017 
// Design Name: 
// Module Name:    SignExtend 
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
module SignExtend(input [6:0] imm,
						output reg [15:0] signImm);

	always @* begin
		signImm[6:0] = imm[6:0];
		signImm[15:7] = {9{imm[6]}};
	end
endmodule
