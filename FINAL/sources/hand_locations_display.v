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
	input [15:0] z1, //left
	input [15:0] x2,
	input [15:0] y2,
	input [15:0] z2, //right
	input [7:0] hover,
	input [7:0] roll,
	input [7:0] pitch,
	input on,

   output phsync,	// horizontal sync
   output pvsync,	// vertical sync
   output pblank,	// blanking
   output [23:0] pixel	// pong game's pixel  // r=23:16, g=15:8, b=7:0 
   );
	
   assign phsync = hsync;
   assign pvsync = vsync;
   assign pblank = blank;
	
	parameter MAX_Y = 10'd768; //max of display
	parameter MAX_X = 11'd1024; //max of display
	parameter MAX_Y_KINECT = 460;
	parameter MAX_X_KINECT = 650;
	
	//parameters for pitch
	parameter MIN_Z_DEAD_ZONE = 800;
	parameter MAX_Z_DEAD_ZONE = 1050;
	
	//parameters for colors
	parameter RED = 24'hD0_00_00 ;
	parameter WHITE = 24'hFF_FF_FF;
	parameter BLUE = 24'h00_33_CC;
	parameter YELLOW = 24'hFF_FF_00;
	parameter DEAD_ZONE_COLOR = 24'h30_30_30;
	parameter BLACK = 24'h00_00_00;
	parameter gesture_lines_color = 24'h50_50_50 ;
		
	reg [15:0] x1_disp;
	reg [15:0] y1_disp;
	reg [15:0] x2_disp;
	reg [15:0] y2_disp;
	
	reg [23:0] left_hand_color;
	reg [23:0] right_hand_color;
	wire [23:0] divider_color = WHITE ;
	
	wire [23:0] left_hand_pixel;
	wire [23:0] right_hand_pixel;
	wire [23:0] dead_zone_pixel;
	wire [23:0] divider_pixel;
	wire [23:0] dead_zone_line_pixel;
	wire [23:0] on_pixel;
	
	always @(negedge vsync) begin
		x1_disp <= (x1/2)*3;
		y1_disp <= (y1/2)*3;
		x2_disp <= (x2/2)*3;
		y2_disp <= (y2/2)*3;
		
		if (z1 < MIN_Z_DEAD_ZONE) left_hand_color <= BLUE;//
		else if (z1 < MAX_Z_DEAD_ZONE) left_hand_color <= WHITE;//
		else left_hand_color <= RED;
		
		if (z2 < MIN_Z_DEAD_ZONE) right_hand_color <= BLUE;//
		else if (z2 < MAX_Z_DEAD_ZONE) right_hand_color <= WHITE;//
		else right_hand_color <= RED;

	end
	
	
////////////////////////////////////////////////////////////////////////////
//
// Hands
//
////////////////////////////////////////////////////////////////////////////

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
						 
////////////////////////////////////////////////////////////////////////////
//
//  Dividers
//
////////////////////////////////////////////////////////////////////////////

	//dead zone					 
	blob  #(.WIDTH(MAX_X),.HEIGHT(MAX_Y/3))
			dead_zone(.x(0),
			          .y(2*MAX_Y/3),
						 .hcount(hcount),.vcount(vcount),
						 .pixel(dead_zone_pixel),
						 .color(DEAD_ZONE_COLOR));
						 
	blob  #(.WIDTH(MAX_X),.HEIGHT(3))
			dead_zone_line(.x(0),
			          .y(2*MAX_Y/3),
						 .hcount(hcount),.vcount(vcount),
						 .pixel(dead_zone_line_pixel),
						 .color( gesture_lines_color ));
	//center divider					 
	blob  #(.WIDTH(3),.HEIGHT(MAX_Y))
			divider(.x(MAX_X/2),
			          .y(0),
						 .hcount(hcount),.vcount(vcount),
						 .pixel(divider_pixel),
						 .color(divider_color));
	
////////////////////////////////////////////////////////////////////////////
//
// Dividing lines for off gesture
//
////////////////////////////////////////////////////////////////////////////
	
	parameter line1 = MAX_X/5;
	parameter line2 = 2*MAX_X/5;
	parameter line3 = 3*MAX_X/5;
	parameter line4 = 4*MAX_X/5;
	wire [23:0] line1_pixel,line2_pixel,line3_pixel,line4_pixel;
	
	blob  #(.WIDTH(3),.HEIGHT(2*MAX_Y/3))
			l1(.x(line1),
			          .y(2*MAX_Y/3),
						 .hcount(hcount),.vcount(vcount),
						 .pixel(line1_pixel),
						 .color( gesture_lines_color ));
	
	blob  #(.WIDTH(3),.HEIGHT(2*MAX_Y/3))
			l2(.x(line2),.y(2*MAX_Y/3),.hcount(hcount),.vcount(vcount),
				.pixel(line2_pixel), .color( gesture_lines_color ));
						 
	blob  #(.WIDTH(3),.HEIGHT(2*MAX_Y/3))
			l3(.x(line3),.y(2*MAX_Y/3),.hcount(hcount),.vcount(vcount),
				.pixel(line3_pixel),.color( gesture_lines_color ));
						 
	blob  #(.WIDTH(3),.HEIGHT(2*MAX_Y/3))
			l4(.x(line4),.y(2*MAX_Y/3),.hcount(hcount),.vcount(vcount),
				.pixel(line4_pixel),.color( gesture_lines_color ));


////////////////////////////////////////////////////////////////////////////
//
// ON
//
////////////////////////////////////////////////////////////////////////////

	
	wire [23:0] on_blob_color;
	assign on_blob_color	= on? YELLOW:BLACK;
	blob  #(.WIDTH(64 ),.HEIGHT(64))
			on1(.x(MAX_X-64),.y(0),.hcount(hcount),.vcount(vcount),
				.pixel(on_pixel),.color( on_blob_color ));
						 
						 
	//draw mags for hover, pitch and roll
	
	wire [23:0] h_rec_pixel,h_mag_pixel;
	parameter GRAY = 24'h98_98_98;
	parameter GREEN = 24'h00_66_33;
	wire [23:0] h_mag_val1;
	wire [23:0] h_mag_val;
	parameter b_t = 2*MAX_Y/3;
	assign h_mag_val1 = hover[7:0]*b_t;
	assign h_mag_val[23:0] = {8'b0, h_mag_val1[23:16]};
//	
	//bounding rectangle for hover
//	blob  #(.WIDTH(100),.HEIGHT(2*MAX_Y/3))
//			hover_rec(.x(0),
//			          .y(2*MAX_Y/3),
//						 .hcount(hcount),.vcount(vcount),
//						 .pixel(h_rec_pixel),
//						 .color( GRAY ));
//	//hover mag					 
//	blob  #(.WIDTH(100),.HEIGHT(2*MAX_Y/3))
//			hover_mag(.x(0),
//			          .y(2*MAX_Y/3),
//						 .hcount(hcount),.vcount(vcount),
//						 .pixel(h_mag_pixel),
//						 .color( GREEN ));
//						 
	assign pixel = left_hand_pixel | right_hand_pixel | dead_zone_pixel | 
						divider_pixel |line1_pixel|line2_pixel|line3_pixel|line4_pixel|
						dead_zone_line_pixel|on_pixel|h_mag_pixel|h_rec_pixel;
   
endmodule
