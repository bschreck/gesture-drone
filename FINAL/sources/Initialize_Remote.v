`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:27:21 12/05/2014 
// Design Name: 
// Module Name:    Initialize_Remote 
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
module Initialize_Remote(
		input clock,
		//input on_pulse,
		output reg [7:0] initial_signal
    );

parameter TURN_ON = 1;
parameter IDLE = 0;
reg on_pulse;

reg state;
reg [4:0] counter;
//when you get an on pulse,
//send out 0 for 16 cycles,
//then 255 for 16 cycles, then
//0
always @(clock) begin
	case (state)
	TURN_ON:
	begin
		if (counter > 4'd14 && counter < 4'd30) begin
			initial_signal <= 8'b1111_1111;
		end else if (counter > 4'd30) begin
		   initial_signal <= 0;
			state <= IDLE;
			on_pulse <= 1; //only until on fsm works
		end else initial_signal <= 0;
		
		counter <= counter +1;
	end
	default:
	begin
	   counter <= 0;
		//if (on_pulse) state <= TURN_ON;
		if (!on_pulse) state <= TURN_ON;
	end
	endcase
end


endmodule
