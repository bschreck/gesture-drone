`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:15:34 11/13/2014 
// Design Name: 
// Module Name:    on_off_state 
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
module on_off_state(
    input clock,
    input is_on,
    input is_off,
    input reset,
    output reg on_off_s //state of the drone - says whether is on or off (1 = on, 0 = off)
    );
	 
parameter OFF = 1'b0;
parameter ON = 1'b1;

always @(posedge clock) begin
	if (reset || is_off) on_off_s <= OFF;
	else if (is_on) on_off_s <= ON;
end



endmodule
