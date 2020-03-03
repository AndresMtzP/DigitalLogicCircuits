`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:42:19 03/07/2017 
// Design Name: 
// Module Name:    lab6 
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
module lab6( input M_CLOCK,
				 input [3:0] IO_PB,
				 input [7:0] IO_DSW,
				 output [7:0] IO_LED,
				 output [3:0] F_LED,
				 output reg [7:0] IO_SSEG,
				 output reg [3:0] IO_SSEGD,
				 output reg IO_SSEG_COL); 
	
	assign IO_LED = IO_DSW;
	assign F_LED = {state[0], state[1], state[2], 1'b0};
	
	reg [7:0] sseg1;
	reg [7:0] sseg2;
	reg [7:0] sseg3;
	reg [7:0] sseg4;
	reg [3:0] digit;
	reg [31:0] counter = 0;
	reg muxClk = 0;
	reg [6:0] secCount = 0;
	reg alarmSet = 0;
	reg alarmRinging = 0;
	reg runStop = 0;
	reg resetStop = 0;
	
	//state descriptions:
	//	state 0 -> clock w/ alarm
	// state 1 -> setting clock
	// state 2 -> displaying/setting alarm
	// state 4 -> date display
	// state 3 ->  stopwatch
	// state 5 -> countdown
	reg [2:0] state = 0;
	
	reg [5:0] sec = 0;
	reg [3:0] min1 = 6;
	reg [2:0] min2 = 3;
	reg [3:0] hour1 = 2;
	reg [1:0] hour2 = 1;
	
	reg [3:0] alarmMin1 = 0;
	reg [2:0] alarmMin2 = 0;
	reg [3:0] alarmHour1 = 2;
	reg [1:0] alarmHour2 = 1;
	
	reg [3:0] stopDSec = 0;
	reg [3:0] stopSec1 = 0;
	reg [2:0] stopSec2 = 0;
	reg [3:0] stopMin = 0;
	
	always @(posedge M_CLOCK) begin
		if (counter >= 125000) begin
			muxClk = ~muxClk;
			counter = 0;
		end else counter = counter + 1;
	end
	
	//control multiplexing
	always @(posedge muxClk) begin
		case (IO_SSEGD)
			4'b0111: begin
				IO_SSEG = sseg4;
				IO_SSEGD = 4'b1110;
			end
			4'b1110: begin
				IO_SSEG = sseg3;
				IO_SSEGD = 4'b1101;
			end
			4'b1101: begin
				IO_SSEG = sseg2;
				IO_SSEGD = 4'b1011;
			end
			4'b1011: begin
				IO_SSEG = sseg1;
				IO_SSEGD = 4'b0111;
			end
			default: begin
				IO_SSEG = sseg1;
				if (alarmRinging) IO_SSEGD = IO_SSEGD;
				else IO_SSEGD = 4'b1110;
			end
		endcase
		
		if (state == 3) begin
			if (runStop) begin
				if (secCount % 20 == 0) begin
					if (stopDSec >= 9) begin
						stopDSec = 0;
						if (stopSec1 >= 9) begin
							stopSec1 = 0;
							if (stopSec2 >= 5) begin
								stopSec2 = 0;
								if (stopMin >= 9) stopMin = 9;
								else stopMin = stopMin + 1;
							end else stopSec2 = stopSec2 + 1;
						end else stopSec1 = stopSec1 + 1;
					end else stopDSec = stopDSec + 1;
				end else begin
					stopDSec = stopDSec;
					stopSec1 = stopSec1;
					stopSec2 = stopSec2;
					stopMin = stopMin;
				end
			end else begin
				stopDSec = stopDSec;
				stopSec1 = stopSec1;
				stopSec2 = stopSec2;
				stopMin = stopMin;
			end
			if (resetStop) begin
				stopDSec = 0;
				stopSec1 = 0;
				stopSec2 = 0;
				stopMin = 0;
			end else begin
				stopDSec = stopDSec;
				stopSec1 = stopSec1;
				stopSec2 = stopSec2;
				stopMin = stopMin;
			end
		end else begin
			stopDSec = stopDSec;
				stopSec1 = stopSec1;
				stopSec2 = stopSec2;
				stopMin = stopMin;
		end
		
		if (secCount >= 100) begin
			secCount = 0;
			sseg1[7] = ~sseg1[7];
			if (alarmRinging) begin
				if (IO_SSEGD == 4'b1111) IO_SSEGD = 4'b0111;
				else IO_SSEGD = 4'b1111;
			end else IO_SSEGD = IO_SSEGD;
		end else secCount = secCount + 1;
	end
	
	always @(posedge sseg1[7]) begin
		if (alarmSet) begin
			if ((alarmMin1 == min1) && (alarmMin2 == min2) && (alarmHour1 == hour1) && (alarmHour2 == hour2)) alarmRinging = 1'b1;
			else alarmRinging = 1'b0;
		end else alarmRinging = 1'b0;
		case (state)
			3'b000: begin
				sseg2[7] = 1'b1;
				sseg3[7] = 1'b1;
				sseg4[7] = 1'b1;
				IO_SSEG_COL = 1'b0;
				if (sec >= 59) begin
					sec = 0;
					if (min1 >= 9) begin
						min1 = 0;
						if (min2 >= 5) begin
							min2 = 0;
							case (hour2)
								2'b00: begin
									if (hour1 >= 9) begin
										hour1 = 0;
										hour2 = 1;
									end else hour1 = hour1 + 1;
								end
								2'b01: begin
									if (hour1 >= 9) begin
										hour1 = 0;
										hour2 = 2;
									end else hour1 = hour1 + 1;
								end
								default: begin
									if (hour1 >= 3) begin
										hour1 = 0;
										hour2 = 0;
									end else hour1 = hour1 + 1;
								end
							endcase
						end else min2 = min2 + 1;
					end else min1 = min1 + 1;
				end else sec = sec + 1;
			end
			3'b001: begin
				sseg2[7] = 1'b1;
				sseg3[7] = 1'b1;
				sseg4[7] = 1'b1;
				IO_SSEG_COL = ~IO_SSEG_COL;
				case(IO_PB[0])
					1'b0: begin
						if (min1 >= 9) min1 = 0;
						else min1 = min1 + 1;
					end
					default: min1 = min1;
				endcase
				case(IO_PB[1])
					1'b0: begin
						if (min2 >= 5) min2 = 0;
						else min2 = min2 + 1;
					end
					default: min2 = min2;
				endcase
				case(IO_PB[2])
					1'b0: begin
						case(hour2)
							2'b00: begin
								if (hour1 >= 9) hour1 = 0;
								else hour1 = hour1 + 1; 
							end
							2'b01: begin
								if (hour1 >= 9) hour1 = 0;
								else hour1 = hour1 + 1;
							end
							default: begin
								if (hour1 >= 3) hour1 = 0;
								else hour1 = hour1 + 1;
							end
						endcase
					end
					default: hour1 = hour1;
				endcase
				case(IO_PB[3])
					1'b0: begin
						if (hour1 >= 4) begin
							if (hour2 == 1) begin
								hour2 = 2;
								hour1 = 0;
							end else if (hour2 >= 2) hour2 = 0;
							else hour2 = 1;
						end else begin
							if (hour2 >= 2) hour2 = 0;
							else hour2 = hour2 + 1;
						end
					end
					default: hour2 = hour2;
				endcase
			end
			3'b010: begin
				sseg2[7] = 1'b1;
				sseg3[7] = 1'b1;
				sseg4[7] = 1'b1;
				if (alarmSet) IO_SSEG_COL = 1'b0;
				else IO_SSEG_COL = ~IO_SSEG_COL;
				case(IO_PB[0])
					1'b0: begin
						if (alarmMin1 >= 9) alarmMin1 = 0;
						else alarmMin1 = alarmMin1 + 1;
					end
					default: alarmMin1 = alarmMin1;
				endcase
				case(IO_PB[1])
					1'b0: begin
						if (alarmMin2 >= 5) alarmMin2 = 0;
						else alarmMin2 = alarmMin2 + 1;
					end
					default: alarmMin2 = alarmMin2;
				endcase
				case(IO_PB[2])
					1'b0: begin
						case(alarmHour2)
							2'b00: begin
								if (alarmHour1 >= 9) alarmHour1 = 0;
								else alarmHour1 = alarmHour1 + 1; 
							end
							2'b01: begin
								if (alarmHour1 >= 9) alarmHour1 = 0;
								else alarmHour1 = alarmHour1 + 1;
							end
							default: begin
								if (alarmHour1 >= 3) alarmHour1 = 0;
								else alarmHour1 = alarmHour1 + 1;
							end
						endcase
					end
					default: alarmHour1 = alarmHour1;
				endcase
				case(IO_PB[3])
					1'b0: begin
						if (alarmHour1 >= 4) begin
							if (alarmHour2 == 1) begin
								alarmHour2 = 2;
								alarmHour1 = 0;
							end else if (alarmHour2 >= 2) alarmHour2 = 0;
							else alarmHour2 = 1;
						end else begin
							if (alarmHour2 >= 2) alarmHour2 = 0;
							else alarmHour2 = alarmHour2 + 1;
						end
					end
					default: alarmHour2 = alarmHour2;
				endcase
			end
			4'b0011: begin
				IO_SSEG_COL = 1'b1;
				sseg2[7] = 1'b0;
				sseg3[7] = 1'b1;
				sseg4[7] = 1'b0;
			end
			default: begin
				if (sec >= 59) sec = 0;
				else sec = sec + 1;
				alarmMin1 = alarmMin1;
				alarmMin2 = alarmMin2;
				alarmHour1 = alarmHour1;
				alarmHour2 = alarmHour2;
			end
		endcase
	end
	
	always @(negedge IO_PB[0], negedge IO_PB[1]) begin
		case (state)
			3'b011: begin
				case (IO_PB[1:0])
					2'b10: runStop = ~runStop;
					2'b01: begin
						resetStop = 1'b1;
						runStop = 1'b0;
					end
					default: begin
						resetStop = 1'b0;
						runStop = runStop;
					end
				endcase
			end
			default: begin
				runStop = runStop;
				resetStop = 1'b0;
			end
		endcase
	end
	
	always @(IO_DSW) begin
		case (~IO_DSW[2:0])
			3'b000: state = 0;
			3'b001: state = 1;
			3'b010: state = 2;
			3'b011: state = 3;
			3'b100: state = 4;
			default: state = 0;
		endcase
		case (~IO_DSW[7])
			1'b0: alarmSet = 1'b0;
			1'b1: alarmSet = 1'b1;
		endcase
	end
	
	always @(*) begin
		case (state)
			3'b000: begin
				case (min1) 
					4'b0000: sseg1[6:0] = 7'b1000000; // 0
					4'b0001: sseg1[6:0] = 7'b1111001; // 1
					4'b0010: sseg1[6:0] = 7'b0100100; // 2
					4'b0011: sseg1[6:0] = 7'b0110000; // 3 
					4'b0100: sseg1[6:0] = 7'b0011001; // 4
					4'b0101: sseg1[6:0] = 7'b0010010; // 5
					4'b0110: sseg1[6:0] = 7'b0000010; // 6
					4'b0111: sseg1[6:0] = 7'b1011000; // 7
					4'b1000: sseg1[6:0] = 7'b0000000; // 8
					4'b1001: sseg1[6:0] = 7'b0010000; // 9
					4'b1010: sseg1[6:0] = 7'b0001000; // A
					4'b1011: sseg1[6:0] = 7'b0000011; // b
					4'b1100: sseg1[6:0] = 7'b1000110; // C
					4'b1101: sseg1[6:0] = 7'b0100001; // d
					4'b1110: sseg1[6:0] = 7'b0000110; // E
					4'b1111: sseg1[6:0] = 7'b0001110; // F
					default: sseg1[6:0] = 7'b1111111; // empty
				endcase
				case (min2)
					3'b000: sseg2[6:0] = 7'b1000000; // 0
					3'b001: sseg2[6:0] = 7'b1111001; // 1
					3'b010: sseg2[6:0] = 7'b0100100; // 2
					3'b011: sseg2[6:0] = 7'b0110000; // 3
					3'b100: sseg2[6:0] = 7'b0011001; // 4
					3'b101: sseg2[6:0] = 7'b0010010; // 5
					3'b110: sseg2[6:0] = 7'b0000010; // 6
					3'b111: sseg2[6:0] = 7'b1011000; // 7
					default: sseg2[6:0] = 7'b1111111; // empty
				endcase
				case (hour1)
					4'b0000: sseg3[6:0] = 7'b1000000; // 0
					4'b0001: sseg3[6:0] = 7'b1111001; // 1
					4'b0010: sseg3[6:0] = 7'b0100100; // 2
					4'b0011: sseg3[6:0] = 7'b0110000; // 3 
					4'b0100: sseg3[6:0] = 7'b0011001; // 4
					4'b0101: sseg3[6:0] = 7'b0010010; // 5
					4'b0110: sseg3[6:0] = 7'b0000010; // 6
					4'b0111: sseg3[6:0] = 7'b1011000; // 7
					4'b1000: sseg3[6:0] = 7'b0000000; // 8
					4'b1001: sseg3[6:0] = 7'b0010000; // 9
					4'b1010: sseg3[6:0] = 7'b0001000; // A
					4'b1011: sseg3[6:0] = 7'b0000011; // b
					4'b1100: sseg3[6:0] = 7'b1000110; // C
					4'b1101: sseg3[6:0] = 7'b0100001; // d
					4'b1110: sseg3[6:0] = 7'b0000110; // E
					4'b1111: sseg3[6:0] = 7'b0001110; // F
					default: sseg3[6:0] = 7'b1111111; // empty
				endcase
				case (hour2)
					2'b00: sseg4[6:0] = 7'b1000000; // 0
					2'b01: sseg4[6:0] = 7'b1111001; // 1
					2'b10: sseg4[6:0] = 7'b0100100; // 2
					default: sseg4[6:0] = 7'b1111111; // empty
				endcase
			end
			3'b001: begin
				case (min1) 
					4'b0000: sseg1[6:0] = 7'b1000000; // 0
					4'b0001: sseg1[6:0] = 7'b1111001; // 1
					4'b0010: sseg1[6:0] = 7'b0100100; // 2
					4'b0011: sseg1[6:0] = 7'b0110000; // 3 
					4'b0100: sseg1[6:0] = 7'b0011001; // 4
					4'b0101: sseg1[6:0] = 7'b0010010; // 5
					4'b0110: sseg1[6:0] = 7'b0000010; // 6
					4'b0111: sseg1[6:0] = 7'b1011000; // 7
					4'b1000: sseg1[6:0] = 7'b0000000; // 8
					4'b1001: sseg1[6:0] = 7'b0010000; // 9
					4'b1010: sseg1[6:0] = 7'b0001000; // A
					4'b1011: sseg1[6:0] = 7'b0000011; // b
					4'b1100: sseg1[6:0] = 7'b1000110; // C
					4'b1101: sseg1[6:0] = 7'b0100001; // d
					4'b1110: sseg1[6:0] = 7'b0000110; // E
					4'b1111: sseg1[6:0] = 7'b0001110; // F
					default: sseg1[6:0] = 7'b1111111; // empty
				endcase
				case (min2)
					3'b000: sseg2[6:0] = 7'b1000000; // 0
					3'b001: sseg2[6:0] = 7'b1111001; // 1
					3'b010: sseg2[6:0] = 7'b0100100; // 2
					3'b011: sseg2[6:0] = 7'b0110000; // 3
					3'b100: sseg2[6:0] = 7'b0011001; // 4
					3'b101: sseg2[6:0] = 7'b0010010; // 5
					3'b110: sseg2[6:0] = 7'b0000010; // 6
					3'b111: sseg2[6:0] = 7'b1011000; // 7
					default: sseg2[6:0] = 7'b1111111; // empty
				endcase
				case (hour1)
					4'b0000: sseg3[6:0] = 7'b1000000; // 0
					4'b0001: sseg3[6:0] = 7'b1111001; // 1
					4'b0010: sseg3[6:0] = 7'b0100100; // 2
					4'b0011: sseg3[6:0] = 7'b0110000; // 3 
					4'b0100: sseg3[6:0] = 7'b0011001; // 4
					4'b0101: sseg3[6:0] = 7'b0010010; // 5
					4'b0110: sseg3[6:0] = 7'b0000010; // 6
					4'b0111: sseg3[6:0] = 7'b1011000; // 7
					4'b1000: sseg3[6:0] = 7'b0000000; // 8
					4'b1001: sseg3[6:0] = 7'b0010000; // 9
					4'b1010: sseg3[6:0] = 7'b0001000; // A
					4'b1011: sseg3[6:0] = 7'b0000011; // b
					4'b1100: sseg3[6:0] = 7'b1000110; // C
					4'b1101: sseg3[6:0] = 7'b0100001; // d
					4'b1110: sseg3[6:0] = 7'b0000110; // E
					4'b1111: sseg3[6:0] = 7'b0001110; // F
					default: sseg3[6:0] = 7'b1111111; // empty
				endcase
				case (hour2)
					2'b00: sseg4[6:0] = 7'b1000000; // 0
					2'b01: sseg4[6:0] = 7'b1111001; // 1
					2'b10: sseg4[6:0] = 7'b0100100; // 2
					default: sseg4[6:0] = 7'b1111111; // empty
				endcase
			end
			3'b010: begin
				case (alarmMin1) 
					4'b0000: sseg1[6:0] = 7'b1000000; // 0
					4'b0001: sseg1[6:0] = 7'b1111001; // 1
					4'b0010: sseg1[6:0] = 7'b0100100; // 2
					4'b0011: sseg1[6:0] = 7'b0110000; // 3 
					4'b0100: sseg1[6:0] = 7'b0011001; // 4
					4'b0101: sseg1[6:0] = 7'b0010010; // 5
					4'b0110: sseg1[6:0] = 7'b0000010; // 6
					4'b0111: sseg1[6:0] = 7'b1011000; // 7
					4'b1000: sseg1[6:0] = 7'b0000000; // 8
					4'b1001: sseg1[6:0] = 7'b0010000; // 9
					4'b1010: sseg1[6:0] = 7'b0001000; // A
					4'b1011: sseg1[6:0] = 7'b0000011; // b
					4'b1100: sseg1[6:0] = 7'b1000110; // C
					4'b1101: sseg1[6:0] = 7'b0100001; // d
					4'b1110: sseg1[6:0] = 7'b0000110; // E
					4'b1111: sseg1[6:0] = 7'b0001110; // F
					default: sseg1[6:0] = 7'b1111111; // empty
				endcase
				case (alarmMin2)
					3'b000: sseg2[6:0] = 7'b1000000; // 0
					3'b001: sseg2[6:0] = 7'b1111001; // 1
					3'b010: sseg2[6:0] = 7'b0100100; // 2
					3'b011: sseg2[6:0] = 7'b0110000; // 3
					3'b100: sseg2[6:0] = 7'b0011001; // 4
					3'b101: sseg2[6:0] = 7'b0010010; // 5
					3'b110: sseg2[6:0] = 7'b0000010; // 6
					3'b111: sseg2[6:0] = 7'b1011000; // 7
					default: sseg2[6:0] = 7'b1111111; // empty
				endcase
				case (alarmHour1)
					4'b0000: sseg3[6:0] = 7'b1000000; // 0
					4'b0001: sseg3[6:0] = 7'b1111001; // 1
					4'b0010: sseg3[6:0] = 7'b0100100; // 2
					4'b0011: sseg3[6:0] = 7'b0110000; // 3 
					4'b0100: sseg3[6:0] = 7'b0011001; // 4
					4'b0101: sseg3[6:0] = 7'b0010010; // 5
					4'b0110: sseg3[6:0] = 7'b0000010; // 6
					4'b0111: sseg3[6:0] = 7'b1011000; // 7
					4'b1000: sseg3[6:0] = 7'b0000000; // 8
					4'b1001: sseg3[6:0] = 7'b0010000; // 9
					4'b1010: sseg3[6:0] = 7'b0001000; // A
					4'b1011: sseg3[6:0] = 7'b0000011; // b
					4'b1100: sseg3[6:0] = 7'b1000110; // C
					4'b1101: sseg3[6:0] = 7'b0100001; // d
					4'b1110: sseg3[6:0] = 7'b0000110; // E
					4'b1111: sseg3[6:0] = 7'b0001110; // F
					default: sseg3[6:0] = 7'b1111111; // empty
				endcase
				case (alarmHour2)
					2'b00: sseg4[6:0] = 7'b1000000; // 0
					2'b01: sseg4[6:0] = 7'b1111001; // 1
					2'b10: sseg4[6:0] = 7'b0100100; // 2
					default: sseg4[6:0] = 7'b1111111; // empty
				endcase
			end
			4'b011: begin
				case (stopDSec) 
					4'b0000: sseg1[6:0] = 7'b1000000; // 0
					4'b0001: sseg1[6:0] = 7'b1111001; // 1
					4'b0010: sseg1[6:0] = 7'b0100100; // 2
					4'b0011: sseg1[6:0] = 7'b0110000; // 3 
					4'b0100: sseg1[6:0] = 7'b0011001; // 4
					4'b0101: sseg1[6:0] = 7'b0010010; // 5
					4'b0110: sseg1[6:0] = 7'b0000010; // 6
					4'b0111: sseg1[6:0] = 7'b1011000; // 7
					4'b1000: sseg1[6:0] = 7'b0000000; // 8
					4'b1001: sseg1[6:0] = 7'b0010000; // 9
					4'b1010: sseg1[6:0] = 7'b0001000; // A
					4'b1011: sseg1[6:0] = 7'b0000011; // b
					4'b1100: sseg1[6:0] = 7'b1000110; // C
					4'b1101: sseg1[6:0] = 7'b0100001; // d
					4'b1110: sseg1[6:0] = 7'b0000110; // E
					4'b1111: sseg1[6:0] = 7'b0001110; // F
					default: sseg1[6:0] = 7'b1111111; // empty
				endcase
				case (stopSec1)
					4'b0000: sseg2[6:0] = 7'b1000000; // 0
					4'b0001: sseg2[6:0] = 7'b1111001; // 1
					4'b0010: sseg2[6:0] = 7'b0100100; // 2
					4'b0011: sseg2[6:0] = 7'b0110000; // 3 
					4'b0100: sseg2[6:0] = 7'b0011001; // 4
					4'b0101: sseg2[6:0] = 7'b0010010; // 5
					4'b0110: sseg2[6:0] = 7'b0000010; // 6
					4'b0111: sseg2[6:0] = 7'b1011000; // 7
					4'b1000: sseg2[6:0] = 7'b0000000; // 8
					4'b1001: sseg2[6:0] = 7'b0010000; // 9
					4'b1010: sseg2[6:0] = 7'b0001000; // A
					4'b1011: sseg2[6:0] = 7'b0000011; // b
					4'b1100: sseg2[6:0] = 7'b1000110; // C
					4'b1101: sseg2[6:0] = 7'b0100001; // d
					4'b1110: sseg2[6:0] = 7'b0000110; // E
					4'b1111: sseg2[6:0] = 7'b0001110; // F
					default: sseg2[6:0] = 7'b1111111; // empty
				endcase
				case (stopSec2)
					3'b000: sseg3[6:0] = 7'b1000000; // 0
					3'b001: sseg3[6:0] = 7'b1111001; // 1
					3'b010: sseg3[6:0] = 7'b0100100; // 2
					3'b011: sseg3[6:0] = 7'b0110000; // 3 
					3'b100: sseg3[6:0] = 7'b0011001; // 4
					3'b101: sseg3[6:0] = 7'b0010010; // 5
					3'b110: sseg3[6:0] = 7'b0000010; // 6
					3'b111: sseg3[6:0] = 7'b1011000; // 7
					default: sseg3[6:0] = 7'b1111111; // empty
				endcase
				case (stopMin)
					4'b0000: sseg4[6:0] = 7'b1000000; // 0
					4'b0001: sseg4[6:0] = 7'b1111001; // 1
					4'b0010: sseg4[6:0] = 7'b0100100; // 2
					4'b0011: sseg4[6:0] = 7'b0110000; // 3 
					4'b0100: sseg4[6:0] = 7'b0011001; // 4
					4'b0101: sseg4[6:0] = 7'b0010010; // 5
					4'b0110: sseg4[6:0] = 7'b0000010; // 6
					4'b0111: sseg4[6:0] = 7'b1011000; // 7
					4'b1000: sseg4[6:0] = 7'b0000000; // 8
					4'b1001: sseg4[6:0] = 7'b0010000; // 9
					4'b1010: sseg4[6:0] = 7'b0001000; // A
					4'b1011: sseg4[6:0] = 7'b0000011; // b
					4'b1100: sseg4[6:0] = 7'b1000110; // C
					4'b1101: sseg4[6:0] = 7'b0100001; // d
					4'b1110: sseg4[6:0] = 7'b0000110; // E
					4'b1111: sseg4[6:0] = 7'b0001110; // F
					default: sseg4[6:0] = 7'b1111111; // empty
				endcase
			end
			default: begin
				case (min1) 
					4'b0000: sseg1[6:0] = 7'b1000000; // 0
					4'b0001: sseg1[6:0] = 7'b1111001; // 1
					4'b0010: sseg1[6:0] = 7'b0100100; // 2
					4'b0011: sseg1[6:0] = 7'b0110000; // 3 
					4'b0100: sseg1[6:0] = 7'b0011001; // 4
					4'b0101: sseg1[6:0] = 7'b0010010; // 5
					4'b0110: sseg1[6:0] = 7'b0000010; // 6
					4'b0111: sseg1[6:0] = 7'b1011000; // 7
					4'b1000: sseg1[6:0] = 7'b0000000; // 8
					4'b1001: sseg1[6:0] = 7'b0010000; // 9
					4'b1010: sseg1[6:0] = 7'b0001000; // A
					4'b1011: sseg1[6:0] = 7'b0000011; // b
					4'b1100: sseg1[6:0] = 7'b1000110; // C
					4'b1101: sseg1[6:0] = 7'b0100001; // d
					4'b1110: sseg1[6:0] = 7'b0000110; // E
					4'b1111: sseg1[6:0] = 7'b0001110; // F
					default: sseg1[6:0] = 7'b1111111; // empty
				endcase
				case (min2)
					3'b000: sseg2[6:0] = 7'b1000000; // 0
					3'b001: sseg2[6:0] = 7'b1111001; // 1
					3'b010: sseg2[6:0] = 7'b0100100; // 2
					3'b011: sseg2[6:0] = 7'b0110000; // 3
					3'b100: sseg2[6:0] = 7'b0011001; // 4
					3'b101: sseg2[6:0] = 7'b0010010; // 5
					3'b110: sseg2[6:0] = 7'b0000010; // 6
					3'b111: sseg2[6:0] = 7'b1011000; // 7
					default: sseg2[6:0] = 7'b1111111; // empty
				endcase
				case (hour1)
					4'b0000: sseg3[6:0] = 7'b1000000; // 0
					4'b0001: sseg3[6:0] = 7'b1111001; // 1
					4'b0010: sseg3[6:0] = 7'b0100100; // 2
					4'b0011: sseg3[6:0] = 7'b0110000; // 3 
					4'b0100: sseg3[6:0] = 7'b0011001; // 4
					4'b0101: sseg3[6:0] = 7'b0010010; // 5
					4'b0110: sseg3[6:0] = 7'b0000010; // 6
					4'b0111: sseg3[6:0] = 7'b1011000; // 7
					4'b1000: sseg3[6:0] = 7'b0000000; // 8
					4'b1001: sseg3[6:0] = 7'b0010000; // 9
					4'b1010: sseg3[6:0] = 7'b0001000; // A
					4'b1011: sseg3[6:0] = 7'b0000011; // b
					4'b1100: sseg3[6:0] = 7'b1000110; // C
					4'b1101: sseg3[6:0] = 7'b0100001; // d
					4'b1110: sseg3[6:0] = 7'b0000110; // E      
					4'b1111: sseg3[6:0] = 7'b0001110; // F
					default: sseg3[6:0] = 7'b1111111; // empty
				endcase
				case (hour2)
					2'b00: sseg4[6:0] = 7'b1000000; // 0
					2'b01: sseg4[6:0] = 7'b1111001; // 1
					2'b10: sseg4[6:0] = 7'b0100100; // 2
					default: sseg4[6:0] = 7'b1111111; // empty
				endcase
			end
		endcase
	end

endmodule