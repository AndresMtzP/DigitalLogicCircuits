`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:43:32 04/06/2017
// Design Name:   RegisterFile
// Module Name:   C:/Users/Andres/Documents/CompE470L/FinalProject/tb_RegisterFile.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RegisterFile
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_RegisterFile;

	// Inputs
	reg clk = 1;
	reg [2:0] Address1;
	reg [2:0] Address2;
	reg [2:0] Address3;
	reg WE;
	reg [15:0] WriteData;
	reg [2:0] ShowAddress;

	// Outputs
	wire [15:0] RD1;
	wire [15:0] RD2;
	wire [15:0] ShowData;
	wire [15:0] test;

	// Instantiate the Unit Under Test (UUT)
	RegisterFile uut (
		.clk(clk), 
		.Address1(Address1), 
		.Address2(Address2), 
		.Address3(Address3), 
		.WE(WE), 
		.WriteData(WriteData),
		.ShowAddress(ShowAddress), 
		.RD1(RD1), 
		.RD2(RD2), 
		.ShowData(ShowData),
		.test(test)
	);
	
	always begin
		#0.5; clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		Address1 = 0;
		Address2 = 0;
		Address3 = 3;
		WE = 0;
		WriteData = 25;
		ShowAddress = 0;
		
		@(posedge clk) WE = 1;
		@(posedge clk) WE = 0;
		@(posedge clk) ShowAddress = 3;

		// Add stimulus here
		#10; $finish;
	end
      
endmodule

