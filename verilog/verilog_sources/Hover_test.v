`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:49:48 11/14/2014
// Design Name:   Hover
// Module Name:   /afs/athena.mit.edu/user/l/e/leegross/Documents/6.111/FinalProject/sources//Hover_test.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Hover
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Hover_test;

	// Inputs
	reg clock;
	reg [15:0] y1;
	reg [15:0] y2;
	reg reset;
	reg on;

	// Outputs
	wire [7:0] hover;

	// Instantiate the Unit Under Test (UUT)
	Hover uut (
		.clock(clock),  
		.y1(y1), 
		.y2(y2), 
		.reset(reset), 
		.on(on),
		.hover(hover)
	);

	always #5 clock = !clock;
	initial begin
		// Initialize Inputs
		clock = 0;
		y1 = 0;
		y2 = 0;
		reset = 0;
		on = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		y1 = 20;
		y2 = 20;
		
		#20
		y1 = 12;
		y2 = 12;
		
		#20
		on = 1;
		
		#20
		y1 = 8;
		y2 = 8;
		
		#20
		on = 0;
		
		#20
		y1 = 4;
		y2 = 4;
		
		#20
		y1 = 16;
		y2 = 16;
	end
      
endmodule

