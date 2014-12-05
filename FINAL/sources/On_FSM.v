`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:46:27 11/12/2014 
// Design Name: 
// Module Name:    On_FSM 
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
module On_FSM
	#(parameter MAX_X = 9,   //1024         
               MAX_Y = 9) 	//767
	(input clock,
    input [15:0] x,
    input [15:0] y,
	 input reset,
    output reg is_on,
	 output [3:0] on_fsm);

//states	 
//3 4 5
//2   6
//1 0 7
parameter IDLE = 4'd10;
parameter STATE0 = 4'd1;
parameter STATE1 = 4'd2;
parameter STATE2 = 4'd3;
parameter STATE3 = 4'd4;
parameter STATE4 = 4'd5;
parameter STATE5 = 4'd6;
parameter STATE6 = 4'd7;
parameter STATE7 = 4'd8;
parameter TURN_ON = 4'd9;

//dividing lines
parameter vline0 = 0;
parameter vline1 = MAX_X/3;
parameter vline2 = 2*MAX_X/3;
parameter vline3 = MAX_X;

parameter hline0 = 0;
parameter hline1 = MAX_Y/3;
parameter hline2 = 2*MAX_Y/3;
parameter hline3 = MAX_Y;

reg [2:0] buffer; //allows for some errors for state transitions
parameter BUFFER_CUTOFF = 7;

reg [3:0] state = IDLE;
assign on_fsm = state;

always @(posedge clock) begin
	if (reset) state <= IDLE;
	else begin
		case (state)
			STATE0: //stay in State0, go to State1 or go to IDLE
			begin
				if (x>vline1 && x<vline2 && y>hline2 && y<hline3) state <= STATE0;
				else if(x>vline0 && x<vline1 && y>hline2 && y<hline3) state <= STATE1;
				else state <= IDLE;
			end
			STATE1: //stay in State1, go to State2 or go to IDLE
			begin
				if (x>vline0 && x<vline1 && y>hline2 && y<hline3) state <= STATE1;
				else if (x>vline0 && x<vline1 && y>hline1 && y<hline2) state <= STATE2;
				else state <= IDLE;
			end
			
			STATE2: //stay in State2, go to State3 or go to IDLE
			begin
				if (x>vline0 && x<vline1 && y>=hline1 && y<hline2) state <= STATE2;
				else if (x>vline0 && x<vline1 && y>hline0 && y<hline1) state <= STATE3;
				//else state <= IDLE;
				else state <=STATE2;
			end
			
			STATE3: //stay in State3, go to State4 or go to IDLE
			begin
				if (x>vline0 && x<vline1 && y>hline0 && y<hline1) state <= STATE3;
				else if (x>vline1 && x<vline2 && y>hline0 && y<hline1) state <= STATE4;
				//else state <= IDLE;
				else state <=STATE3;
			end
			
			STATE4: //stay in State4, go to State5 or go to IDLE
			begin
				if (x>vline1 && x<vline2 && y>hline0 && y<hline1) state <= STATE4;
				else if (x>vline2 && x<vline3 && y>hline0 && y<hline1) state <= STATE5;
				//else state <= IDLE;
				else state <= STATE4;
			end
			
			STATE5: //stay in State5, go to State6 or go to IDLE
			begin
				if (x>vline2 && x<vline3 && y>hline0 && y<hline1) state <= STATE5;
				else if (x>vline2 && x<vline3 && y>hline1 && y<hline2) state <= STATE6;
				//else state <= IDLE;
				else state <=STATE5;
			end
					
			STATE6: //stay in State6, go to State7 or go to IDLE
			begin
				if (x>vline2 && x<vline3 && y>hline1 && y<hline2) state <= STATE6;
				else if (x>vline2 && x<vline3 && y>hline2 && y<hline3) state <= STATE7;
				//else state <= IDLE;
				else state <=STATE6;
			end
			
			STATE7: //stay in State7, go to TURN_ON or go to IDLE
			begin
				if (x>vline2 && x<vline3 && y>hline2 && y<hline3) state <= STATE7;
				else if (x>vline1 && x<vline2 && y>hline2 && y<hline3) state <= TURN_ON;
				//else state <= IDLE;
				else state <= STATE7;
			end
			
			TURN_ON: //send a pulse to turn on and go to IDLE
			begin
				is_on <=1;
				//state <= IDLE;
			end
			default://stay in IDLE or go to State0
			begin
				if (x>vline1 && x<vline2 && y>hline2 && y<hline3) state <= STATE0;
				is_on <=0;
			end
			
		endcase 
	end
end


endmodule
