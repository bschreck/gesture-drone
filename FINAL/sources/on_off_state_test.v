`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:18:36 11/13/2014
// Design Name:   on_off_state
// Module Name:   /afs/athena.mit.edu/user/l/e/leegross/Documents/6.111/FinalProject/sources//on_off_state_test.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: on_off_state
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module on_off_state_test;

	// Inputs
	reg clock;
	reg is_on;
	reg is_off;
	reg reset;

	// Outputs
	wire on_off_s;

	// Instantiate the Unit Under Test (UUT)
	on_off_state uut (
		.clock(clock), 
		.is_on(is_on), 
		.is_off(is_off), 
		.reset(reset), 
		.on_off_s(on_off_s)
	);

	always #5 clock = !clock;
	initial begin
		// Initialize Inputs
		clock = 0;
		is_on = 0;
		is_off = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		is_on = 1;
		
		#10
		is_on = 0;
		
		#20
		is_off = 1;
		
		#10
		is_off = 0;
		
		#40
		is_on = 1;
		
		#10
		is_on =0;

	end
      
endmodule

