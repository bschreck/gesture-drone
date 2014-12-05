`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:10:54 12/03/2014 
// Design Name: 
// Module Name:    hand_locations_display 
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
module hand_locations_display (
   input vclock,	// 65MHz clock
   input reset,		// 1 to initialize module
   input up,		// 1 when paddle should move up
   input down,  	// 1 when paddle should move down
   input [3:0] pspeed,  // puck speed in pixels/tick 
   input [10:0] hcount,	// horizontal index of current pixel (0..1023)
   input [9:0] 	vcount, // vertical index of current pixel (0..767)
   input hsync,		// XVGA horizontal sync signal (active low)
   input vsync,		// XVGA vertical sync signal (active low)
   input blank,		// XVGA blanking (1 means output black pixel)
 	
   output phsync,	// pong game's horizontal sync
   output pvsync,	// pong game's vertical sync
   output pblank,	// pong game's blanking
   output [23:0] pixel	// pong game's pixel  // r=23:16, g=15:8, b=7:0 
   );

   wire [2:0] checkerboard;
	
   assign phsync = hsync;
   assign pvsync = vsync;
   assign pblank = blank;
	
	parameter MAX_Y = 10'd768;
	parameter MAX_X = 11'd1024;
	parameter MAX_Y_KINECT = 600;
	parameter MAX_X_KINECT = 400;
	parameter RESIZE_X = MAX_X/MAX_X_KINECT;
	parameter RESIZE_Y = MAX_Y/MAX_Y_KINECT;
	
	wire [15:0] x1;
	wire [15:0] y1;
	wire [15:0] z1;
	wire [15:0] x2;
	wire [15:0] y2;
	wire [15:0] z2;
	
	reg [15:0] x1_disp;
	reg [15:0] y1_disp;
	reg [15:0] x2_disp;
	reg [15:0] y2_disp;
	
	assign x1 = 15'd200;
	assign y1 = 15'd300;
	assign z1 = 15'd50;
	assign x2 = 15'd300;
	assign y2 = 15'd500;
	assign z2 = 15'd100;
	
	wire [23:0] left_hand_color;
	wire [23:0] right_hand_color;
	wire [23:0] dead_zone_color = 24'h30_30_30 ;
	wire [23:0] divider_color = 24'hFF_FF_FF ;
	
	pitch_color pc1(.z(z1), .reset(reset),.color(left_hand_color));
	pitch_color pc2(.z(z2), .reset(reset),.color(right_hand_color));
	
	wire [23:0] left_hand_pixel;
	wire [23:0] right_hand_pixel;
	wire [23:0] dead_zone_pixel;
	wire [23:0] divider_pixel;
	
	always @(negedge vsync) begin
		x1_disp <= x1*RESIZE_X;
		y1_disp <= y1*RESIZE_Y;
		x2_disp <= x2*RESIZE_X;
		y2_disp <= y2*RESIZE_Y;
	end
	
	//left hand
	blob  #(.WIDTH(64),.HEIGHT(64))
			left_hand(.x(x1_disp),
			          .y(y1_disp),
						 .hcount(hcount),.vcount(vcount),
						 .pixel(left_hand_pixel),
						 .color(left_hand_color));
	//right hand					 
	blob  #(.WIDTH(64),.HEIGHT(64))
			right_hand(.x(x2_disp),
			          .y(y2_disp),
						 .hcount(hcount),.vcount(vcount),
						 .pixel(right_hand_pixel),
						 .color(right_hand_color));
	//dead zone					 
	blob  #(.WIDTH(MAX_X),.HEIGHT(MAX_Y/3))
			dead_zone(.x(0),
			          .y(2*MAX_Y/3),
						 .hcount(hcount),.vcount(vcount),
						 .pixel(dead_zone_pixel),
						 .color(dead_zone_color));
	//center divider					 
	blob  #(.WIDTH(3),.HEIGHT(MAX_Y))
			divider(.x(MAX_X/2),
			          .y(0),
						 .hcount(hcount),.vcount(vcount),
						 .pixel(divider_pixel),
						 .color(divider_color));
						 
	assign pixel = left_hand_pixel | right_hand_pixel | dead_zone_pixel | divider_pixel;
   
endmodule
