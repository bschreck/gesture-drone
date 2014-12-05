`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:28:27 11/12/2014
// Design Name:   On_FSM
// Module Name:   /afs/athena.mit.edu/user/l/e/leegross/Documents/6.111/FinalProject/FinalProject/On_FSM_test.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: On_FSM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module On_FSM_test;

	// Inputs
	reg clock;
	reg [15:0] x;
	reg [15:0] y;
	reg reset;

	// Outputs
	wire is_on;

	// Instantiate the Unit Under Test (UUT)
	On_FSM uut (
		.clock(clock), 
		.x(x), 
		.y(y),  
		.reset(reset), 
		.is_on(is_on)
	);

	always #5 clock = !clock;
	initial begin
		// Initialize Inputs
		clock = 0;
		x = 0;
		y = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		x = 5;
		y = 7;
		
		#10
		x = 2;
		y = 7;
		
		#10
		x = 2;
		y = 5;
		
		#10
		x = 2;
		y = 2;
		
		#10
		x = 5;
		y = 2;
		
		#10
		x = 7;
		y = 2;
		
		#10
		x = 7;
		y = 5;
		
		#10
		x = 7;
		y = 7;
		
		#10
		x = 5;
		y = 7;
		

	end
      
endmodule

