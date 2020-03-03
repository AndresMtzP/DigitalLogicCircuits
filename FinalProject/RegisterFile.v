//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:10:56 03/17/2017 
// Design Name: 
// Module Name:    RegisterMemory 
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
module RegisterFile( input clk,
							input [2:0] Address1,
							input [2:0] Address2,
							input [2:0] Address3,
							input WE,
							input write,
							input [15:0] WriteData,
							input [2:0] ShowAddress,
							output reg [15:0] RD1,
							output reg [15:0] RD2,
							output reg [15:0] ShowData);
							
	reg [15:0] RegFile [7:0];
	reg LastWrite = 0;
	reg WriteChanged = 0;
	
	initial begin
		RegFile[3'd0] = 15'b0;
		RegFile[3'd1] = 15'b0;
		RegFile[3'd2] = 15'b0;
		RegFile[3'd3] = 15'b0;
		RegFile[3'd4] = 15'b0;
		RegFile[3'd5] = 15'b0;
		RegFile[3'd6] = 15'b0;
		RegFile[3'd7] = 15'b0;
	end
	
	always @* begin
		RD1 = RegFile[Address1];
		RD2 = RegFile[Address2];
		ShowData = RegFile[ShowAddress];
	end
	
	always @(posedge clk) begin
		if (WriteChanged && write) begin
			case(WE)
				1'b0: RegFile[Address3] = RegFile[Address3];
				1'b1: RegFile[Address3] = WriteData;
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