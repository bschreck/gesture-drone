`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:29:14 11/14/2014
// Design Name:   Roll
// Module Name:   /afs/athena.mit.edu/user/l/e/leegross/Documents/6.111/FinalProject/sources//Roll_test.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Roll
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Roll_test;
// Inputs
	reg clock;
	reg [10:0] y1;
	reg [10:0] y2;
	reg reset;

	// Outputs
	wire [3:0] roll_mag;
	wire [1:0] direction;

	// Instantiate the Unit Under Test (UUT)
	Roll uut (
		.clock(clock),  
		.y1(y1), 
		.y2(y2), 
		.reset(reset), 
		.roll_mag(roll_mag),
		.direction(direction)
	);

	always #5 clock = !clock;
	initial begin
		// Initialize Inputs
		clock = 0;
		y1 = 0;
		y2 = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		y1 = 15;
		
		#20
		y1 = 7;
		
		#20
		y1 = 5;
		
		#20
		y1 = 2;
		
		#20
		y1 = 23;

	end
      
endmodule

