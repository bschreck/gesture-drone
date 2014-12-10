`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:59:06 12/06/2014 
// Design Name: 
// Module Name:    Pitch 
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
module Pitch
	#(parameter MAX_Y = 650)
	(input clock,
    input [15:0] z1,
    input [15:0] z2,
    input reset,
    output reg [7:0] pitch
    );
	 
	//parameters for pitch
	parameter MIN_Z_DEAD_ZONE = 800;
	parameter MAX_Z_DEAD_ZONE = 1050;
	
	parameter MOVE_BACK = 8'd58;
	parameter MOVE_FORWARD = 8'd174;
	parameter STAY = 8'd116;
	
	
	wire [16:0] z_sum = z1+z2;
	wire [15:0] z = z_sum[16:1]; //average z's
	
	 always @(posedge clock) begin

		//if either hand is in the dead zone, stay in place
		if (z1 > MIN_Z_DEAD_ZONE && z1 < MAX_Z_DEAD_ZONE) pitch <=STAY;
		else if (z2 > MIN_Z_DEAD_ZONE &&  z2< MAX_Z_DEAD_ZONE) pitch <=STAY;
	 	//if the average is in the forward zone, move forward
		else if (z < MIN_Z_DEAD_ZONE) pitch <= MOVE_FORWARD;//
		//if the average is in the dead zone, stay
		else if (z < MAX_Z_DEAD_ZONE) pitch <= STAY;//
		//if the average is in the backwards zone, move back
		else pitch <= MOVE_BACK;
		
	 end


endmodule
