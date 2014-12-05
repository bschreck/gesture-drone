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
   input [10:0] hcount,	// horizontal index of current pixel (0..1023)
   input [9:0] 	vcount, // vertical index of current pixel (0..767)
   input hsync,		// XVGA horizontal sync signal (active low)
   input vsync,		// XVGA vertical sync signal (active low)
   input blank,		// XVGA blanking (1 means output black pixel)
 	
	input [15:0] x1,
	input [15:0] y1,
	input [15:0] z1,
	input [15:0] x2,
	input [15:0] y2,
	input [15:0] z2,

   output phsync,	// horizontal sync
   output pvsync,	// vertical sync
   output pblank,	// blanking
   output [23:0] pixel	// pong game's pixel  // r=23:16, g=15:8, b=7:0 
   );
	
   assign phsync = hsync;
   assign pvsync = vsync;
   assign pblank = blank;
	
	parameter MAX_Y = 10'd768;
	parameter MAX_X = 11'd1024;
	parameter MAX_Y_KINECT = 460;
	parameter MAX_X_KINECT = 650;
	parameter RESIZE_X = MAX_X/MAX_X_KINECT;
	parameter RESIZE_Y = MAX_Y/MAX_Y_KINECT;
		
	reg [15:0] x1_disp;
	reg [15:0] y1_disp;
	reg [15:0] x2_disp;
	reg [15:0] y2_disp;
	
	wire [23:0] left_hand_color;
	wire [23:0] right_hand_color;
	wire [23:0] dead_zone_color = 24'h30_30_30 ;
	wire [23:0] divider_color = 24'hFF_FF_FF ;
	
	pitch_color pc1(.z(z1),.color(left_hand_color));
	pitch_color pc2(.z(z2),.color(right_hand_color));
	
	wire [23:0] left_hand_pixel;
	wire [23:0] right_hand_pixel;
	wire [23:0] dead_zone_pixel;
	wire [23:0] divider_pixel;
	
	always @(negedge vsync) begin
//		x1_disp <= x1*RESIZE_X;
//		y1_disp <= y1*RESIZE_Y;
//		x2_disp <= x2*RESIZE_X;
//		y2_disp <= y2*RESIZE_Y;
		x1_disp <= (x1/2)*3;
		y1_disp <= (y1/2)*3;
		x2_disp <= (x2/2)*3;
		y2_disp <= (y2/2)*3;

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
						 
	//dividing lines for on gesture
	parameter vline1 = MAX_X/3;
	parameter vline2 = 2*MAX_X/3;
	parameter hline1 = MAX_Y/3;
	parameter hline2 = 2*MAX_Y/3;
	wire [23:0] vline1_pixel,vline2_pixel,hline1_pixel,hline2_pixel;
	wire [23:0] gesture_lines_color = 24'h50_50_50 ;
					 
	blob  #(.WIDTH(MAX_X),.HEIGHT(3))
			hl1(.x(0),
			          .y(hline1),
						 .hcount(hcount),.vcount(vcount),
						 .pixel(hline1_pixel),
						 .color( gesture_lines_color ));
					 
	blob  #(.WIDTH(MAX_X),.HEIGHT(3))
			hl2(.x(0),
			          .y(hline2),
						 .hcount(hcount),.vcount(vcount),
						 .pixel(hline2_pixel),
						 .color( gesture_lines_color ));
				 
	blob  #(.WIDTH(3),.HEIGHT(MAX_Y))
			vl1(.x(vline1),
			          .y(0),
						 .hcount(hcount),.vcount(vcount),
						 .pixel(vline1_pixel),
						 .color( gesture_lines_color ));
						 
	blob  #(.WIDTH(3),.HEIGHT(MAX_Y))
			vl2(.x(vline2),
			          .y(0),
						 .hcount(hcount),.vcount(vcount),
						 .pixel(vline2_pixel),
						 .color( gesture_lines_color ));
						 
	assign pixel = left_hand_pixel | right_hand_pixel | dead_zone_pixel | divider_pixel |vline1_pixel|vline2_pixel|hline1_pixel|hline2_pixel;
   
endmodule
