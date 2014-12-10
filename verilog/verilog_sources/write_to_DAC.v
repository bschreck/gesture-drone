`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:55:23 12/06/2014 
// Design Name: 
// Module Name:    write_to_DAC 
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
module write_to_DAC(
    input clock,
    input [7:0] hover,
	 input [7:0] pitch,
	 input [7:0] roll,
    output reg write_signal,
    output reg [1:0] gest_select,
	 output reg [7:0] gest_out
    );


	reg [15:0] cycle_counter;

  always @(posedge clock) begin
		cycle_counter <= cycle_counter +1;
		if (cycle_counter < 16384) begin
			if (cycle_counter > 16380 || cycle_counter < 5) write_signal <= 1;
			else write_signal <= 0;
		  gest_out <= 0;
		  gest_select <= 0;
		end
		else if(cycle_counter < 32768) begin
			if (cycle_counter > 32764 || cycle_counter < 16389) write_signal <= 1;
			else write_signal <= 0;
		  gest_out <= roll[7:0];
		  gest_select <= 1;
		end
		else if (cycle_counter <49152) begin
			if (cycle_counter > 49148 || cycle_counter < 32773) write_signal <= 1;
			else write_signal <= 0;
		  gest_out <= hover[7:0];
		  gest_select <= 2;
		end
		else begin
			if (cycle_counter > 65532 || cycle_counter < 49157) write_signal <= 1;
			else write_signal <= 0;
		  gest_out <= pitch[7:0];
		  gest_select <= 3;
		end
		
  end

endmodule
