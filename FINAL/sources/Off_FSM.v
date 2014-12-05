`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:45:29 11/12/2014 
// Design Name: 
// Module Name:    Off_FSM 
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
module Off_FSM
	#(parameter MAX_X = 15,   //1024         
               MAX_Y = 15) //767
	(
    input clock,
    input [15:0] x1,//left hand
    input [15:0] y1,
    input [15:0] x2, //right hand
    input [15:0] y2,
    input reset,
    output reg is_off,
	 output reg [4:0] state_right
    );
	 
//states
parameter IDLE = 4'd0;
parameter STEP0 = 4'd1; //when hands are at center
parameter STEP1 = 4'd2; //first step to left or right
parameter STEP2 = 4'd3; //second step to left or right
parameter STEP3 = 4'd4; //third step back towards center
parameter STEP4 = 4'd5; //fourth step - hand returns to center

reg [4:0] state_left = IDLE;
//reg [4:0] state_right = IDLE;

//dividing lines
parameter line0 = 0;
parameter line1 = MAX_X/5;
parameter line2 = 2*MAX_X/5;
parameter line3 = 3*MAX_X/5;
parameter line4 = 4*MAX_X/5;
parameter line5 = MAX_X;
parameter boundry = 2*MAX_Y/3; //bottom third of the screen

	 
always @(posedge clock) begin
	if (reset) begin
		state_left <= IDLE;
		state_right <= IDLE;
	end
	//if both hands have gone to the sides and back then set a pulse to indicate turning off
	else if (y1 > boundry && y2 > boundry && state_left == STEP4 && state_right == STEP4) begin
		is_off <=1;
		state_left <=IDLE;
		state_right <= IDLE;
	end
	else if (y1 > boundry && y2 > boundry) begin
		case (state_left)
			IDLE: //stay in IDLE or go to STEP0
			begin
				if (x1 > line2 && x1 <line3) state_left <= STEP0;
				is_off <=0;
			end
			STEP0: //stay in Step0, go to Step1 or IDLE
			begin
				if (x1 > line2 && x1 <line3) state_left <= STEP0;
				else if (x1>line1 && x1<line2) state_left <=STEP1;
				else state_left <= IDLE;
			end
			STEP1: //stay in Step1, go to Step2 or IDLE
			begin
				if (x1>line1 && x1<line2) state_left <=STEP1;
				else if (x1>line0 && x1<line1) state_left <=STEP2;
				else state_left <= IDLE;
			end
			STEP2: //stay in Step2, go to Step3 or IDLE
			begin
				if (x1>line0 && x1<line1) state_left <=STEP2;
				else if (x1>line1 && x1<line2) state_left <=STEP3;
				else state_left <= IDLE;
			end
			STEP3: //stay in Step3, go to Step4 or IDLE
			begin
				if (x1>line1 && x1<line2) state_left <=STEP3;
				else if (x1>line2 && x1<line3) state_left <=STEP4;
				else state_left <= IDLE;
			end
		endcase
		
		
		case (state_right)
			IDLE: //stay in IDLE or go to STEP0
			begin
				if (x2 > line2 && x2 <line3) state_right <= STEP0;
				is_off <=0;
			end
			STEP0: //stay in Step0, go to Step1 or IDLE
			begin
				if (x2 > line2 && x2 <line3) state_right <= STEP0;
				else if (x2>line3 && x2<line4) state_right <=STEP1;
				else state_right <= IDLE;
			end
			STEP1: //stay in Step1, go to Step2 or IDLE
			begin
				if (x2>line3 && x2<line4) state_right <=STEP1;
				else if (x2>line4 && x2<line5) state_right <=STEP2;
				else state_right <= IDLE;
			end
			STEP2: //stay in Step2, go to Step3 or IDLE
			begin
				if (x2>line4 && x2<line5) state_right <=STEP2;
				else if (x2>line3 && x2<line4) state_right <=STEP3;
				else state_right <= IDLE;
			end
			STEP3: //stay in Step3, go to Step4 or IDLE
			begin
				if (x2>line3 && x2<line4) state_right <=STEP3;
				else if (x2>line2 && x2<line3) state_right <=STEP4;
				else state_right <= IDLE;
			end
		endcase
	
	end
end


endmodule
