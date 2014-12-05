`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:37:09 12/03/2014 
// Design Name: 
// Module Name:    pitch_color 
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
module pitch_color(
    input [15:0] z,
    input reset,
    output reg [23:0] color);

	parameter MAX_Z = 300;
	parameter b = MAX_Z/8; //bucket size
	parameter gray_b = 25;
		 
	always @(*) begin
		if (z>7*b) color <= {8'd75,8'd75,8'd75};
		else if(z > 6*b) color <= {8'd100,8'd100,8'd100};
		else if(z > 5*b) color <= {8'd125,8'd125,8'd125};
		else if(z > 4*b) color <= {8'd150,8'd150,8'd150};
		else if(z > 3*b) color <= {8'd175,8'd175,8'd175};
		else if(z > 2*b) color <= {8'd200,8'd200,8'd200};
		else if(z > 1*b) color <= {8'd225,8'd225,8'd225};
		else color <= 24'hFF_FF_FF;
	end


endmodule
