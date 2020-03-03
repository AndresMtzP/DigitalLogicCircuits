`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:45:42 03/31/2017 
// Design Name: 
// Module Name:    ControlUnit 
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
module ControlUnit( input [2:0] Op,
							input [2:0] Funct,
							output MemToReg,
							output MemWrite,
							output Branch,
							output [2:0] ALUControl,
							output ALUSrc,
							output RegDst,
							output RegWrite,
							output Jump,
							output JAL,
							output JumpReg,
							output RegRA);
	
	wire [1:0] ALUOp;
	
	//instantiate main decoder for control unit
	MainDecoder u00 (.Op(Op),
						  .RegWrite(RegWrite),
						  .RegDst(RegDst),
						  .ALUSrc(ALUSrc),
						  .Branch(Branch),
						  .MemWrite(MemWrite),
						  .MemToReg(MemToReg),
						  .Jump(Jump),
						  .JAL(JAL),
						  .JumpReg(JumpReg),
						  .RegRA(RegRA),
						  .ALUOp(ALUOp)
						  );
	
	
	//instantiate Alu decoder for control unit
	ALUDecoder u01 (.Funct(Funct),
						 .ALUOp(ALUOp),
						 .ALUControl(ALUControl)
						 );

endmodule
