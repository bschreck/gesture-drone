`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:39:15 11/12/2014
// Design Name:   Off_FSM
// Module Name:   /afs/athena.mit.edu/user/l/e/leegross/Documents/6.111/FinalProject/sources//Off_FSM_test.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Off_FSM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Off_FSM_test;

	// Inputs
	reg clock;
	reg [10:0] x1;
	reg [10:0] y1;
	reg [10:0] x2;
	reg [10:0] y2;
	reg reset;

	// Outputs
	wire is_off;

	// Instantiate the Unit Under Test (UUT)
	Off_FSM uut (
		.clock(clock), 
		.x1(x1), 
		.y1(y1), 
		.x2(x2), 
		.y2(y2), 
		.reset(reset), 
		.is_off(is_off)
	);
	
	always #5 clock = !clock;
	initial begin
		// Initialize Inputs
		clock = 0;
		x1 = 0;
		y1 = 0;
		x2 = 0;
		y2 = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		y1 = 12;
		y2 = 12;
		x1 = 7;
		
		#10
		x1 = 4;
		
		#10
		x1 = 1;
		
		#10
		x1 = 4;
		
		#10
		x1 = 7;
		
		#10
		x2 = 7;
		
		#10
		x2 = 10;
		
		#10
		x2 = 13;
		
		#10
		x2 = 10;
		
		#10
		x2 = 7;

	end
      
endmodule

