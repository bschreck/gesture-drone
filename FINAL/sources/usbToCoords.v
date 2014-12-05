`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:43:41 12/03/2014 
// Design Name: 
// Module Name:    usbToCoords 
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
module usbToCoords(
    input clock, reset,
	 input [7:0] data,
	 input rxf,
	 output rd,
	 output ready,
	 output [3:0] btc_state,
	 output [3:0] debug,
	 output [15:0] left_x,
	                left_y,
						 left_z,
						 right_x,
						 right_y,
						 right_z
    );
wire [15:0] x1,y1,z1,x2,y2,z2;
wire newout;
Bytes_to_Coords btc(	.clock(clock),
    .reset(reset),
	 .rxf(rxf),
	 .rd(rd),
    .data(data),
	 .ready(ready),
    .x1(x1),
    .y1(y1),
    .z1(z1),
    .x2(x2),
    .y2(y2),
    .z2(z2),
	 .newout(newout),
	 .state(btc_state),
	 .debug(debug));
setHandLocations set_hands(
    .x1(x1),
    .y1(y1),
    .z1(z1),
    .x2(x2),
    .y2(y2),
    .z2(z2),
	 .left_x(left_x),
    .left_y(left_y),
    .left_z(left_z),
    .right_x(right_x),
    .right_y(right_y),
    .right_z(right_z)
    );
endmodule