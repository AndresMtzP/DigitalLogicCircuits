//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:47:07 02/25/2017 
// Design Name: 
// Module Name:    Lab4RX 
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
module Lab4RX(	input M_CLOCK,
					input inPin,
					output reg [7:0] IO_LED);

	reg receiving = 0;
	reg endReceive;
	reg [2:0] index = 0;
	reg [12:0] counter = 2605;
	reg firstCheck;
	
	always @(posedge M_CLOCK) begin
		if (receiving) begin
			if (counter >= 5208) begin
				IO_LED[index] = inPin;		
				counter = 0;
				
				if (index >= 7) begin
					index = 0;
					receiving = 0;
					endReceive = 1;
				end else index = index + 1;
				
			end else counter = counter + 1;
		end else begin
			if (counter >= 2604) begin
				if (endReceive) begin
					if (~firstCheck) begin
						if (inPin) firstCheck = 1;
						else begin
							firstCheck = 0;
						end
					end else begin
						if (inPin) begin
							firstCheck = 0;
							index = 0;
							endReceive = 0;
						end
					end
					counter = 0;
				end else begin
					if (~firstCheck) begin
						if (~inPin) firstCheck = 1;
						else firstCheck = 0;
						counter = 0;
					end else begin
						if (~inPin) begin
							firstCheck = 0;
							receiving = 1;
						end else begin
							firstCheck = 0;
							counter = 0;
						end
					end
				end
			end else counter = counter + 1;
		end
	end


endmodule








