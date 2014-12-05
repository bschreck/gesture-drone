`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:25:53 11/14/2014 
// Design Name: 
// Module Name:    Roll 
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
module Roll
   #(parameter MAX_X = 12,   //1024         
               MAX_Y = 24,	//767
					NUM_BUCKETS = 4)
	(input clock,
    input [15:0] y1, //left hand
    input [15:0] y2, //right hand
    input reset,
    output reg [7:0] roll_mag,
	 output reg [1:0] direction
    );

wire [16:0] y;
assign y = y1 >y2 ? y1-y2:y2-y1;

parameter NO_ROLL = 2'd0;
parameter LEFT = 2'd1;
parameter RIGHT = 2'd2;

parameter b_t = 2*MAX_Y/3; //bottom 1/3


always @(*) begin

	if (y < 6'd38 || y1==0 || y2==0 || y1>b_t || y2>b_t) direction <= NO_ROLL;
	else if (y1>y2) direction <= RIGHT;
	else if (y2>y1) direction <= LEFT;
	else direction <= NO_ROLL;

 
	if (direction == RIGHT) begin
		if (y< 8'd230) roll_mag <= 8'd116-(y-8'd38)/4; //proportional
		else roll_mag <= 8'd68; //if above threshold,set to 25 %
	end
	else if(direction == LEFT) begin
		if (y< 8'd230) roll_mag <= 8'd116+(y-8'd38)/4; //proportional
		else roll_mag <= 8'd184; //if above threshold,set to 75 %
	end
	else roll_mag <= 8'd116;
end

endmodule
