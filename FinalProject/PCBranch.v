//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:28 03/17/2017 
// Design Name: 
// Module Name:    PCBranch 
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
module PCBranch(input signed [15:0] SignImm,
					 input signed [15:0] PCPlus1,
					 output signed [15:0] PCBranch);
					 
	assign PCBranch = SignImm + PCPlus1;

endmodule
