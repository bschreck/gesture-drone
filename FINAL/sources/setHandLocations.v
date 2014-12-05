`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:35:25 11/24/2014 
// Design Name: 
// Module Name:    setHandLocations 
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
module setHandLocations(
    input [15:0] x1,
    input [15:0] y1,
    input [15:0] z1,
    input [15:0] x2,
    input [15:0] y2,
    input [15:0] z2,
	 output reg[15:0] left_x,
    output reg[15:0] left_y,
    output reg[15:0] left_z,
    output reg[15:0] right_x,
    output reg[15:0] right_y,
    output reg[15:0] right_z
    );

//set the left coords to equal the coords of the smaller x
//if only 1 hand is above the dead zone(bottom 1/3 of screen), set the other
//y value equal to the same value
always @(*) begin
  if (x1 > x2) begin
    left_x <= x2;
	 left_y <= y2;
	 left_z <= z2;
	 right_x <= x1;
	 right_y <= y1;
	 right_z <= z1;
  end else begin
    left_x <= x1;
	 left_y <= y1;
	 left_z <= z1;
	 right_x <= x2;
	 right_y <= y2;
	 right_z <= z2;
  end
end

endmodule
