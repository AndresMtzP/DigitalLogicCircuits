`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:21:18 04/22/2017 
// Design Name: 
// Module Name:    InterfaceModule 
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
module InterfaceModule( input M_CLOCK,
								input PB_DataMem,
								input PB_InstrMem,
								input [15:0] Instr,
								input [15:0] ProgramCounter,
								input [15:0] RegValue,
								input [15:0] MemValue,
								output [6:0] IO_SSEG,
								output [3:0] IO_SSEGD,
								output [7:0] IO_LED,
								output reg [3:0] F_LED);
	
	wire muxClk;
	reg [3:0] data1;
	reg [3:0] data2;
	reg [3:0] data3;
	reg [3:0] data4;
	wire [6:0] dig1;
	wire [6:0] dig2;
	wire [6:0] dig3;
	wire [6:0] dig4;
	
	assign IO_LED = ProgramCounter[7:0];
	
	//instantiate clock divider
	muxClock u00 (.inClk(M_CLOCK),
					  .outClk(muxClk));
					  
	//instantiate seven segment multiplexer
	SSEGMux u01 (.clk(muxClk),
					 .digit1(dig1),
					 .digit2(dig2),
					 .digit3(dig3),
					 .digit4(dig4),
					 .sseg(IO_SSEG),
					 .ssegd(IO_SSEGD));
	
	segmenter s01 (.in(data1),
						.segs(dig1));
	
	segmenter s02 (.in(data2),
						.segs(dig2));
	
	segmenter s03 (.in(data3),
						.segs(dig3));
	
	segmenter s04 (.in(data4),
						.segs(dig4));
						
	always @(*)
		case ({PB_DataMem, PB_InstrMem})
			2'b00: begin   // default case, both pressed. Display register
				data4 = RegValue[15:12];
				data3 = RegValue[11:8];
				data2 = RegValue[7:4];
				data1 = RegValue[3:0];
				F_LED = 4'b0000;
			end
			2'b01: begin  // DataMem pressed, display Data Memory value
				data4 = MemValue[15:12];
				data3 = MemValue[11:8];
				data2 = MemValue[7:4];
				data1 = MemValue[3:0];
				F_LED = 4'b0001;
			end
			2'b10: begin  // InstrMem pressed, display Instruction
				data4 = Instr[15:12];
				data3 = Instr[11:8];
				data2 = Instr[7:4];
				data1 = Instr[3:0];
				F_LED = 4'b0011;
			end
			2'b11: begin  // no button pressed, display register
				data4 = RegValue[15:12];
				data3 = RegValue[11:8];
				data2 = RegValue[7:4];
				data1 = RegValue[3:0];
				F_LED = 4'b0000;
			end
		endcase
						
endmodule
