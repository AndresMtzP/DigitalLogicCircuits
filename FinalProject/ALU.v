//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:32:09 03/17/2017 
// Design Name: 
// Module Name:    ALU 
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
module ALU(input [2:0] ALUControl,
			  input [15:0] srcA,
			  input [15:0] srcB,
			  output reg [15:0] ALUResult,
			  output reg Zero);

	wire signed [15:0] sgnSrcA;
	wire signed [15:0] sgnSrcB;
	reg [31:0] multResult;
	assign sgnSrcA[15:0] = srcA[15:0];
	assign sgnSrcB[15:0] = srcB[15:0];
	
	always @* begin
		case (ALUControl)
			3'b000: begin		//Code for bitwise and
				ALUResult = srcA & srcB;
				Zero = 1'bx;
			end
			3'b001: begin		// Code for bitwise or
				ALUResult = srcA | srcB;
				Zero = 1'bx;
			end
			3'b010: begin 		//code for add 
				ALUResult = sgnSrcA + sgnSrcB;
				Zero = 1'bx;
			end
			3'b011: begin		//Code for xor
				ALUResult = srcA ^ srcB;
				Zero = 1'bx;
			end
			3'b100: begin	//Code for shift left
				ALUResult = srcA << srcB; 
				Zero = 1'bx;
			end
			3'b101: begin  //Code for mult. Result must be within 16bits, rest will be lost
				multResult = srcA*srcB;
				ALUResult = multResult[15:0];
				Zero = 1'bx;
			end
			3'b110: begin 		//code for subtract
				if (sgnSrcA == sgnSrcB) begin
					ALUResult = sgnSrcA - sgnSrcB;
					Zero = 1'b1;
				end else begin
					ALUResult = sgnSrcA - sgnSrcB;
					Zero = 1'b0;
				end
			end
			3'b111: begin		//code for slt
				if (sgnSrcA <= sgnSrcB) ALUResult = 1'b1;
				else ALUResult = 1'b0;
				Zero = 1'bx;
			end
			default: begin
				ALUResult = 0;
				Zero = 1'bx;
			end
		endcase
	end

endmodule
