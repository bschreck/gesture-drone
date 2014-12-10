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
		input on_state,
		output reg [7:0] initial_signal,
		output reg debug
    );

parameter TURN_ON = 1;
parameter IDLE = 0;

reg state;
reg [25:0] counter;
reg first_time;

initial counter = 0;
initial first_time = 0;
//when you get an on pulse,
//send out 0 for 16 cycles,
//then 255 for 16 cycles, then
//0
always @(clock) begin
	
	case (state)
	TURN_ON:
	begin
		first_time <= 1;
		//if (counter > 26'd280 && counter < 26'd540) begin
		if (counter > 26'd28000000 && counter < 26'd54000000) begin
			initial_signal <= 8'b1111_1111;
		end else if (counter > 26'd54000000) begin
		//end else if (counter > 26'd540) begin
		   initial_signal <= 0;
			state <= IDLE;
		end else initial_signal <= 0;
		
		counter <= counter +1;
		debug <= state;
	end
	default:
	begin
		initial_signal <= 0;
		if (!first_time) state <= TURN_ON;
		else 		state <= IDLE;
	end
	endcase
end


endmodule
