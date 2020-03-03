`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:53:11 03/31/2017 
// Design Name: 
// Module Name:    MainDecoder 
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
module MainDecoder( input [2:0] Op,
						  output reg RegWrite,
						  output reg RegDst,
						  output reg ALUSrc,
						  output reg Branch,
						  output reg MemWrite,
						  output reg MemToReg,
						  output reg Jump,
						  output reg JAL,
						  output reg JumpReg,
						  output reg RegRA,
						  output reg [1:0] ALUOp);
	always @* begin
		case (Op)
			3'b000: begin    //R-type instructions
				RegWrite = 1'b1;
				RegDst = 1'b1;
				ALUSrc = 1'b0;
				Branch = 1'b0;
				MemWrite = 1'b0;
				MemToReg = 1'b0;
				ALUOp = 2'b10;
				Jump = 1'b0;
				JAL = 1'b0;
				JumpReg = 1'b0;
				RegRA = 1'b0;
			end
			3'b001: begin 	  //lw instruction
				RegWrite = 1'b1;
				RegDst = 1'b0;
				ALUSrc = 1'b1;
				Branch = 1'b0;
				MemWrite = 1'b0;
				MemToReg = 1'b1;
				ALUOp = 2'b00;
				Jump = 1'b0;
				JAL = 1'b0;
				JumpReg = 1'b0;
				RegRA = 1'b0;
			end
			3'b010: begin	  //sw instruction
				RegWrite = 1'b0;
				RegDst = 1'bx;
				ALUSrc = 1'b1;
				Branch = 1'b0;
				MemWrite = 1'b1;
				MemToReg = 1'bx;
				ALUOp = 2'b00;
				Jump = 1'b0;
				JAL = 1'b0;
				JumpReg = 1'b0;
				RegRA = 1'b0;
			end
			3'b011: begin	  //j instruction
				RegWrite = 1'b0;
				RegDst = 1'bx;
				ALUSrc = 1'bx;
				Branch = 1'b0;
				MemWrite = 1'b0;
				MemToReg = 1'bx;
				ALUOp = 2'bxx;
				Jump = 1'b1;
				JAL = 1'b0;
				JumpReg = 1'b0;
				RegRA = 1'b0;
			end
			3'b100: begin	  //beq instruction
				RegWrite = 1'b0;
				RegDst = 1'bx;
				ALUSrc = 1'b0;
				Branch = 1'b1;
				MemWrite = 1'b0;
				MemToReg = 1'bx;
				ALUOp = 2'b01;
				Jump = 1'b0;
				JAL = 1'b0;
				JumpReg = 1'b0;
				RegRA = 1'b0;
			end
			3'b101: begin	  //addi instruction
				RegWrite = 1'b1;
				RegDst = 1'b0;
				ALUSrc = 1'b1;
				Branch = 1'b0;
				MemWrite = 1'b0;
				MemToReg = 1'b0;
				ALUOp = 2'b00;
				Jump = 1'b0;
				JAL = 1'b0;
				JumpReg = 1'b0;
				RegRA = 1'b0;
			end
			3'b110: begin	  //jal instruction
				RegWrite = 1'b1;
				RegDst = 1'bx;
				ALUSrc = 1'bx;
				Branch = 1'b0;
				MemWrite = 1'b0;
				MemToReg = 1'bx;
				ALUOp = 2'bxx;
				Jump = 1'b1;
				JAL = 1'b1;
				JumpReg = 1'b0;
				RegRA = 1'b1;
			end
			3'b111: begin	  //jr instruction
				RegWrite = 1'b0;
				RegDst = 1'bx;
				ALUSrc = 1'b0;
				Branch = 1'b0;
				MemWrite = 1'b0;
				MemToReg = 1'b0;
				ALUOp = 2'b00;
				Jump = 1'b0;
				JAL = 1'b0;
				JumpReg = 1'b1;
				RegRA = 1'b0;
			end
		endcase
	end

endmodule
