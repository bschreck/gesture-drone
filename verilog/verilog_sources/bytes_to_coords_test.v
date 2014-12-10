`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:08:47 11/24/2014
// Design Name:   Bytes_to_Coords
// Module Name:   /afs/athena.mit.edu/user/b/s/bschreck/6.111/final_project_repo/Verilog/sources//bytes_to_coords_test.v
// Project Name:  final_project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Bytes_to_Coords
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module bytes_to_coords_test;

	// Inputs
	reg clock;
	reg reset;
	reg [7:0] data_byte;
	reg we;

	// Outputs
	wire ready;
	wire [15:0] x1;
	wire [15:0] y1;
	wire [15:0] z1;
	wire [15:0] x2;
	wire [15:0] y2;
	wire [15:0] z2;

	// Instantiate the Unit Under Test (UUT)
	Bytes_to_Coords uut (
		.clock(clock), 
		.reset(reset), 
		.data_byte(data_byte), 
		.we(we), 
		.ready(ready), 
		.x1(x1), 
		.y1(y1), 
		.z1(z1), 
		.x2(x2), 
		.y2(y2), 
		.z2(z2)
	);

	always #5 clock = !clock;
	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 0;
		data_byte = 0;
		we = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		we = 1;
		data_byte = 83;
		
		#10
		we = 0;
		
		#20
		data_byte = 50;
		
		#250
		data_byte = 69;

	end
      
endmodule

