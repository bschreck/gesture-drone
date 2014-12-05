`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:56:18 11/13/2014 
// Design Name: 
// Module Name:    Hover 
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
module Hover
	#(parameter MAX_X = 650,   //1024         
               MAX_Y = 460,	//767
					NUM_BUCKETS = 4)
	(input clock,
    input [15:0] y1,
    input [15:0] y2,
    input reset,
	 input on,
    output reg [7:0] hover
    );

reg [16:0] y_sum;
reg [15:0] y; //average y's
//wire [15:0] frac;
parameter b_t = 2*MAX_Y/3;

//if either hand in dead zone, hover = 0
//if one hand is not sent, then only consider the hand that is sending
//else average the hands
always @(*) begin
	if (y1 > b_t || y2 > b_t) y <= 9'd320; 
	else if (y1 == 0) y <= y2; 
	else if (y2 == 0) y <= y1;
	else begin
		y_sum <= y1+y2;
		y <= y_sum[16:1];
	end
end

//convert height to hover signal
//max hover is 50% --> 128 bits
always @(*) begin
	if (y <50) hover <= 8'd128;
	else if (y > 0 && y < b_t && on) hover <= 8'd160 - {y[8:1]}; 
	else hover <= 0;
end


endmodule
