`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:55:01 04/21/2017 
// Design Name: 
// Module Name:    DataFile 
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
module DataFile( input clk,
					  input WE,
					  input write,
					  input [3:0] Address,
					  input [15:0] WriteData,
					  input [3:0] ShowAddress,
					  output reg [15:0] ReadData,
					  output reg [15:0] ShowData);
	
	
	reg [15:0] DataMem [15:0];
	integer index;
	reg LastWrite = 0;
	reg WriteChanged = 0;
	
	initial begin
		for(index = 0; index < 16; index = index + 1)
			DataMem[index] = 16'b0;
	end
	
	always @* begin
		ReadData = DataMem[Address];
		ShowData = DataMem[ShowAddress];
	end
	
	always @(posedge clk) begin
		if (WriteChanged && write) begin	
			case(WE)
				1'b0: DataMem[Address] = DataMem[Address];
				1'b1: DataMem[Address] = WriteData;
			endcase
			end
		else WriteChanged = WriteChanged;
		if (write == LastWrite) WriteChanged = 0;
		else begin
			WriteChanged = 1;
			LastWrite = write;
		end
	end
	
	/*
	reg [3:0] a;
	wire [15:0] spo;
	
	always @(posedge clk) begin
		a = ShowAddress;
		ShowData = spo;
		a = Address;
		ReadData = spo;
	end
	
	DataMemory dm00 (
				.a(a),
				.d(WriteData),
				.clk(clk),
				.we(WE),
				.spo(spo));
	*/

endmodule
