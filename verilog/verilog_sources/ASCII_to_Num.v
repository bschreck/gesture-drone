`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:37:52 11/24/2014 
// Design Name: 
// Module Name:    ASCII_to_Num 
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
module ASCII_to_Num(
    input clock,
    input reset,
    input [7:0] ascii,
    output [7:0] num,
	 output [1:0] coords_state
    );

parameter NUM = 2'b11; //when char contains a num
parameter START = 2'b01; //when start sending new coors
parameter END = 2'b10; //when end sending set of coords
parameter NULL = 2'b00;

assign num = (ascii < 8'd58 && ascii > 8'd47)? ascii-8'd48:0;
assign coords_state = (ascii == 8'd83)? START: 
		(ascii == 8'd69)?END:
		(ascii < 8'd58 && ascii > 8'd47)?NUM:NULL;

endmodule
