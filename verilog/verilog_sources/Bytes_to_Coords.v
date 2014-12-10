`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:33:01 11/24/2014 
// Design Name: 
// Module Name:    Bytes_to_Coords 
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

//takes 8 bit data from USB input module and converts to the hand coordinates

module Bytes_to_Coords(
    input clock,
    input reset,
	 input rxf,
    input [7:0] data,
	 output rd,
	 output reg ready,
    output reg [15:0] x1,
    output reg [15:0] y1,
    output reg [15:0] z1,
    output reg [15:0] x2,
    output reg [15:0] y2,
    output reg [15:0] z2,
	 output newout,
	 output reg [3:0] state,
	 output [3:0] debug
    );
	 
//state parameter for coords state
parameter NUM = 2'b11; //when char contains a num
parameter COORDS_START = 2'b01; //when start sending new coords

parameter NULL = 2'b00;
wire [7:0] current_num;
wire [1:0] coords_state;

//states for reading states
parameter IDLE = 4'd0;
parameter START = 4'd14;
parameter X1_MSB = 4'd2;
parameter X1_LSB = 4'd3;
parameter Y1_MSB = 4'd4;
parameter Y1_LSB = 4'd5;
parameter Z1_MSB = 4'd6;
parameter Z1_LSB = 4'd7;
parameter X2_MSB = 4'd8;
parameter X2_LSB = 4'd9;
parameter Y2_MSB = 4'd10;
parameter Y2_LSB = 4'd11;
parameter Z2_MSB = 4'd12;
parameter Z2_LSB = 4'd13;
parameter DONE = 4'd1;

reg hold = 0;
wire [7:0] data_byte;
reg done_writing = 0;
reg reset_usb;

ASCII_to_Num atn(.clock(clock),
					  .reset(reset),
					  .ascii(data_byte),
					  .num(current_num),
					  .coords_state(coords_state));

usb_input usb_i(.clk(clock),
					.reset(reset_usb),
					.data(data), //incoming data from usb
			   	.rd(rd),
						 .rxf(rxf),
						 .out(data_byte), //output data - not always valid
						 .newout(newout), //signals out is valid
						 .hold(hold),
						 .state(debug));
						 
reg flag = 0;
					  
always @(posedge clock) begin
	if (!flag) begin
		state <= IDLE;
		flag = !flag;
	end
	else begin
		case (state)
			START: 
			begin
				if (newout) begin
				  state <= X1_MSB;
				  hold <= 1;
				end
			end
			X1_MSB:
			begin
					if (!done_writing) begin
					  x1[15:8] <= data_byte; //current_num;
					  done_writing <= 1;
					  hold <= 0;
					end else if (newout) begin
						done_writing <= 0;
						state <= X1_LSB;
						hold <= 1;
					end
			end
			X1_LSB:
			begin
					if (!done_writing) begin
						x1[7:0] <= data_byte; //current_num;
						done_writing <= 1;
						hold <= 0;
					end else if (newout) begin
						done_writing <= 0;
						state <= Y1_MSB;
						hold <= 1;
					end
			end
			Y1_MSB:
			begin
					if (!done_writing) begin
						y1[15:8] <= data_byte; //current_num;
						done_writing <= 1;
						hold <= 0;
					end else if (newout) begin
						done_writing <= 0;
						state <= Y1_LSB;
						hold <= 1;
					end
			end
			Y1_LSB:
			begin
					if (!done_writing) begin
						done_writing <= 1;
						y1[7:0] <= data_byte; //current_num;
						hold <= 0;
					end else if (newout) begin
						done_writing <= 0;
						state <= Z1_MSB;
						hold <= 1;
					end
			end
			Z1_MSB:
			begin
					if (!done_writing) begin
						done_writing <= 1;
						z1[15:8] <= data_byte; //current_num;
						hold <= 0;
					end else if (newout) begin
						state <= Z1_LSB;
						done_writing <= 0;
						hold <= 1;
					end
			end
			Z1_LSB:
			begin
					if (!done_writing) begin
						done_writing <= 1;
						z1[7:0] <= data_byte; //current_num;
						hold <= 0;
					end else if (newout) begin
						state <= X2_MSB;
						done_writing <= 0;
						hold <= 1;
					end
			end
			X2_MSB:
			begin
					if (!done_writing) begin
						done_writing <= 1;
						x2[15:8] <= data_byte; //current_num;
						hold <= 0;
					end else if (newout) begin
						state <= X2_LSB;
						done_writing <= 0;
						hold <= 1;
					end
			end
			X2_LSB:
			begin
					if (!done_writing) begin
						done_writing <= 1;
						x2[7:0] <= data_byte; //current_num;
						hold <= 0;
					end else if (newout) begin
						state <= Y2_MSB;
						done_writing <= 0;
						hold <= 1;
					end
			end
			Y2_MSB:
			begin
					if (!done_writing) begin
						done_writing <= 1;
						y2[15:8] <= data_byte; //current_num;
						hold <= 0;
					end else if (newout) begin
						state <= Y2_LSB;
						done_writing <= 0;
						hold <= 1;
					end
			end
			Y2_LSB:
			begin
					if (!done_writing) begin
						done_writing <= 1;
						y2[7:0] <= data_byte; //current_num;
						hold <= 0;
					end else if (newout) begin
						 state <= Z2_MSB;
						 done_writing <= 0;
						 hold <= 1;
					end
			end
			Z2_MSB:
			begin
					if (!done_writing) begin
						done_writing <= 1;
						z2[15:8] <= data_byte; //current_num;
						hold <= 0;
					end else if (newout) begin
						state <= Z2_LSB;
						done_writing <= 0;
						hold <= 1;
					end
			end
			Z2_LSB:
			begin
					z2[7:0] <= data_byte; //current_num;
					state <= DONE;
					ready <= 1;
			end
			DONE:
			begin
				state <= IDLE;
				ready <= 0;
				hold <= 0;
			end
			default:
			begin

				if (newout && coords_state == COORDS_START) state <= START;
			end
		endcase
	end
end

endmodule
