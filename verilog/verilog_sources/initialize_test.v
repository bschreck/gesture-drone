`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:40:17 12/06/2014
// Design Name:   Initialize_Remote
// Module Name:   /afs/athena.mit.edu/user/l/e/leegross/Documents/6.111/FINAL/sources//initialize_test.v
// Project Name:  FINAL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Initialize_Remote
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module initialize_test;

	// Inputs
	reg clock;
	reg on_state;

	// Outputs
	wire [7:0] initial_signal;

	// Instantiate the Unit Under Test (UUT)
	Initialize_Remote uut (
		.clock(clock), 
		.on_state(on_state), 
		.initial_signal(initial_signal)
	);

	always #5 clock = !clock;
	initial begin
		// Initialize Inputs
		clock = 0;
		on_state = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here	
		#15
		on_state = 1;
		
		
		#4000
		on_state = 0;
		
		#500
		on_state = 1;

	end
      
endmodule

