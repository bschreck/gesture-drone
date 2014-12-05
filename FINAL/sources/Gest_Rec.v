`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:34:58 11/14/2014 
// Design Name: 
// Module Name:    Gest_Rec 
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
module gest_rec
	(input wire clock,
    input wire [15:0] left_x,
    input wire [15:0] left_y,
    input wire [15:0] left_z,
    input wire [15:0] right_x,
    input wire [15:0] right_y,
    input wire [15:0] right_z,
    input wire reset,
    output wire [7:0] hover,
    output wire [7:0] roll,
    output wire [7:0] pitch,
    output reg on,
	 output wire [4:0] off_state,
	 output [1:0] roll_direction
    );

//CHANGE THESE
parameter MAX_X = 650;
parameter MAX_Y = 460;
parameter MAX_Z = 1300;
parameter MIN_Z = 550; //depth

wire is_off;
wire is_on1, is_on2;

//wire [1:0] roll_direction;

parameter NO_ROLL = 2'd0;
parameter ROLL_LEFT = 2'd1;
parameter ROLL_RIGHT = 2'd2;

//------------------------------------------
//Determine on and off state
//------------------------------------------
Off_FSM #(.MAX_X(MAX_X), .MAX_Y(MAX_Y)) 
			off(.clock(clock),
				 .x1(left_x), 
				 .y1(left_y),
				 .x2(right_x),
				 .y2(right_y),
				 .reset(reset),
				 .is_off(is_off),
				 .state_right(off_state));
				 
//On_FSM #(.MAX_X(MAX_X), .MAX_Y(MAX_Y)) 
//			on1(.clock(clock),
//				 .x(left_x), 
//				 .y(left_y),
//				 .reset(reset),
//				 .is_on(is_on1));
//				 
//On_FSM #(.MAX_X(MAX_X), .MAX_Y(MAX_Y)) 
//			on2(.clock(clock),
//				 .x(right_x), 
//				 .y(right_y),
//				 .reset(reset),
//				 .is_on(is_on2),
//				 .on_fsm(on_fsm2));
//				 
//on_off_state oos(.clock(clock),
//				 .reset(reset),
//				 .is_on(is_on1|is_on2),
//				 .is_off(is_off),
//				 .on_off_s(on));
always @(clock) begin
  if (is_off) on <= ~on;
end
//------------------------------------------
//Determine hover
//------------------------------------------
				 
Hover #(.MAX_X(MAX_X),.MAX_Y(MAX_Y),.NUM_BUCKETS(4))
			  h(.clock(clock),
				 .y1(left_y),
				 .y2(right_y),
				 .on(1),
				 .reset(reset),
				 .hover(hover));

//------------------------------------------
//Determine roll
//------------------------------------------

Roll #(.MAX_X(MAX_X),.MAX_Y(MAX_Y),.NUM_BUCKETS(4))
			  r(.clock(clock),
				 .y1(right_y),
				 .y2(left_y),
				 .reset(reset),
				 .roll_mag(roll),
				 .direction(roll_direction));


//------------------------------------------
//Determine pitch
//------------------------------------------



endmodule
