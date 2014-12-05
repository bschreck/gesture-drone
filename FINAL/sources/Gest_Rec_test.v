`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:47:52 11/14/2014
// Design Name:   Gest_Rec
// Module Name:   /afs/athena.mit.edu/user/l/e/leegross/Documents/6.111/FinalProject/sources//Gest_Rec_test.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Gest_Rec
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Gest_Rec_test;

	// Inputs
	reg clock;
	reg [15:0] x1;
	reg [15:0] y1;
	reg [15:0] z1;
	reg [15:0] x2;
	reg [15:0] y2;
	reg [15:0] z2;
	reg reset;

	// Outputs
	wire [7:0] hover;
	wire [7:0] roll;
	wire [7:0] pitch;
	wire on;

	// Instantiate the Unit Under Test (UUT)
	gest_rec uut (
		.clock(clock), 
		.x1(x1), 
		.y1(y1), 
		.z1(z1), 
		.x2(x2), 
		.y2(y2), 
		.z2(z2), 
		.reset(reset), 
		.hover(hover), 
		.roll(roll), 
		.pitch(pitch), 
		.on(on)
	);

	always #5 clock = !clock;
	initial begin
		// Initialize Inputs
		clock = 0;
		x1 = 0;
		y1 = 0;
		z1 = 0;
		x2 = 0;
		y2 = 0;
		z2 = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		//turn on
		x1 = 5;
		y1 = 7;
		
		#10
		x1 = 2;
		y1 = 7;
		
		#10
		x1 = 2;
		y1 = 5;
		
		#10
		x1 = 2;
		y1 = 2;
		
		#10
		x1 = 5;
		y1 = 2;
		
		#10
		x1 = 7;
		y1 = 2;
		
		#10
		x1 = 7;
		y1 = 5;
		
		#10
		x1 = 7;
		y1 = 7;
		
		#10
		x1 = 5;
		y1 = 7;

	end
      
endmodule

